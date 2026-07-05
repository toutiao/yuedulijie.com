#!/usr/bin/env ruby
# frozen_string_literal: true

# HN Data Fetcher — cache HN discussions + target articles for AI consumption
#
# Usage:
#   ruby scripts/hn-fetch.rb --best [--max N] [--force] [--jobs N]
#                            [--fetch-articles-simple] [--skip-articles] [--timeout N]
#   ruby scripts/hn-fetch.rb --url <hn_url> [--force]
#   ruby scripts/hn-fetch.rb --fetch-article-url <url> [--timeout N]
#   ruby scripts/hn-fetch.rb --output <dir>

require 'net/http'
require 'uri'
require 'json'
require 'yaml'
require 'nokogiri'
require 'reverse_markdown'
require 'date'
require 'fileutils'
require 'optparse'
require 'time'

RENDERER_URL = ENV.fetch('RENDERER_URL', 'http://localhost:3000')

$stdout.sync = true
$print_mutex = Mutex.new

CACHE_DIR = '_data/hn'
SCORE_THRESHOLD = 80
MAX_DEFAULT = 30
COMMENT_THRESHOLD = 0
COMMENT_CAP = 100
ARTICLE_TRUNCATE = 8000
HN_API_BASE = 'https://hacker-news.firebaseio.com/v0'
ALGOLIA_API = 'https://hn.algolia.com/api/v1'

# Per-domain concurrency limit for simple article fetch
MAX_PER_DOMAIN = 2
$domain_mutex = Mutex.new
$domain_conns = {}
$domain_cv = ConditionVariable.new

# ── API (thread-safe, per-request HTTP) ──

def api_get_json(url, open_timeout: 10, read_timeout: 15)
  uri = URI(url)
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = uri.scheme == 'https'
  http.open_timeout = open_timeout
  http.read_timeout = read_timeout
  resp = http.request(Net::HTTP::Get.new(uri.request_uri))
  JSON.parse(resp.body)
rescue => e
  raise "API fetch failed #{url}: #{e.message}"
end

def firebase_get(endpoint)
  api_get_json("#{HN_API_BASE}/#{endpoint}")
end

def algolia_get(endpoint)
  api_get_json("#{ALGOLIA_API}/#{endpoint}")
rescue => e
  warn "Algolia API error #{endpoint}: #{e.message}" if $stderr.tty?
  nil
end

# ── Stories ──

def fetch_stories_algolia
  cutoff = (Time.now.to_i - 48 * 3600).to_s
  data = algolia_get("search?tags=story&hitsPerPage=#{MAX_DEFAULT}&numericFilters=points>=80,created_at_i>=#{cutoff}")
  return nil unless data && data['hits']
  data['hits'].map { |h|
    {
      'id' => h['objectID'],
      'title' => h['title'] || '',
      'url' => h['url'],
      'hn_url' => "https://news.ycombinator.com/item?id=#{h['objectID']}",
      'score' => h['points'] || 0,
      'author' => h['author'] || '',
      'descendants' => h['num_comments'] || 0,
    }
  }
end

def fetch_stories_firebase
  ids = firebase_get('beststories.json')
  ids.first(MAX_DEFAULT * 2).map do |id|
    item = firebase_get("item/#{id}.json")
    next unless item && item['type'] == 'story' && item['score'] && item['score'] >= SCORE_THRESHOLD
    {
      'id' => id.to_s,
      'title' => item['title'] || '',
      'url' => item['url'],
      'hn_url' => "https://news.ycombinator.com/item?id=#{id}",
      'score' => item['score'],
      'author' => item['by'] || '',
      'descendants' => item['descendants'] || 0,
    }
  end.compact.first(MAX_DEFAULT)
end

def fetch_stories
  fetch_stories_algolia || fetch_stories_firebase
end

# ── Comments ──

def flatten_comments(children)
  (children || []).select { |c| c['type'] == 'comment' }.flat_map { |c|
    [{
      'id' => c['id'].to_s,
      'parent_id' => (c['parent_id'] || '0').to_s,
      'author' => c['author'] || 'anonymous',
      'text' => c['text'] || '',
      'score' => c['points'] || 0,
      'posted_at' => c['created_at'] ? Time.parse(c['created_at']).utc.iso8601 : nil,
    }] + flatten_comments(c['children'])
  }
end

def fetch_discussion_algolia(post_id)
  data = algolia_get("items/#{post_id}")
  return nil unless data
  comments = flatten_comments(data['children'])
  active = comments.select { |c| c['score'] >= COMMENT_THRESHOLD }
  if active.length > 20
    active = active.sort_by { |c| -c['score'] }.first(COMMENT_CAP)
  end
  DiscussionResult.new(
    data['title'] || '',
    data['url'],
    data['points'] || 0,
    data['author'] || '',
    data['created_at'] ? Time.parse(data['created_at']).utc.iso8601 : nil,
    active,
    comments.length,
  )
end

def parse_comments_firebase(ids)
  comments = []
  ids.each do |cid|
    c = firebase_get("item/#{cid}.json")
    next unless c && c['type'] == 'comment' && c['text'] && !c['text'].empty?
    text = Nokogiri::HTML(c['text']).text.strip
    next if text.empty?
    comments << {
      'id' => cid.to_s,
      'parent_id' => c['parent'].to_s,
      'author' => c['by'] || 'anonymous',
      'text' => text,
      'score' => c['score'] || 0,
      'posted_at' => c['time'] ? Time.at(c['time']).utc.iso8601 : nil,
    }
  end
  comments
end

def fetch_discussion_firebase(post_id)
  item = firebase_get("item/#{post_id}.json")
  return nil unless item

  comments = item['kids'] ? parse_comments_firebase(item['kids']) : []
  active = comments.select { |c| c['score'] >= COMMENT_THRESHOLD }
  if active.length > 20
    active = active.sort_by { |c| -c['score'] }.first(COMMENT_CAP)
  end

  DiscussionResult.new(
    item['title'] || '',
    item['url'],
    item['score'] || 0,
    item['by'] || '',
    item['time'] ? Time.at(item['time']).utc.iso8601 : nil,
    active,
    comments.length,
  )
end

def fetch_discussion(post_id)
  fetch_discussion_algolia(post_id) || fetch_discussion_firebase(post_id)
end

DiscussionResult = Struct.new(:post_title, :post_url, :score, :author, :posted_at, :comments, :raw_comment_count)

# ── Browser fetch (for article JS rendering, requires renderer service) ──

def fetch_with_browser(url, js_render: false)
  uri = URI("#{RENDERER_URL}/render")
  params = { url: url }
  params[:js_render] = '1' if js_render
  uri.query = URI.encode_www_form(params)
  resp = Net::HTTP.get_response(uri)
  [resp.code.to_i, resp.body.force_encoding('UTF-8')]
rescue => e
  raise "Browser fetch failed for #{url}: #{e.message}"
end

# ── Article extraction (renderer-based, requires browser service) ──

def extract_article(url)
  result = {
    'url' => url,
    'title' => nil,
    'fetch_status' => nil,
    'content' => nil,
    'error' => nil,
    'fetched_at' => Time.now.utc.iso8601
  }

  if url.nil? || url.empty?
    result['fetch_status'] = 'skipped'
    return result
  end

  begin
    _, html = fetch_with_browser(url, js_render: true)
    doc = Nokogiri::HTML(html)

    result['title'] = doc.at_css('title')&.text&.strip

    doc.css(
      'script, style, nav, footer, header, aside, noscript, iframe, ' \
      '.sidebar, .nav, .menu, .comments, .comment-list, .related-posts'
    ).each(&:remove)

    article_el = doc.at_css(
      'article, main, [role="main"], .article, .post-content, ' \
      '.entry-content, .content, .post, .blog-post, #content'
    )
    body = article_el || doc.at_css('body') || doc

    markdown = ReverseMarkdown.convert(body.inner_html, unknown_tags: :drop)
    markdown = markdown.gsub(/\n{3,}/, "\n\n").strip

    result['content'] = markdown[0, ARTICLE_TRUNCATE]
    result['fetch_status'] = 'success'
  rescue => e
    msg = e.message || ''
    if msg.include?('403') || msg.include?('Forbidden')
      result['fetch_status'] = 'blocked'
    elsif msg.include?('404') || msg.include?('Not Found')
      result['fetch_status'] = 'not_found'
    else
      result['fetch_status'] = 'error'
    end
    result['error'] = msg[0, 500]
  end

  result
end

# ── Simple article extraction (pure HTTP, no renderer) ──

JS_BLOCKER_PATTERNS = [
  /enable.{0,30}javascript/i,
  /checking your browser/i,
  /verifying your browser/i,
  /\bcloudflare\b.{0,50}(challenge|security|ray\s*id)/i,
  /attention required/i,
  /captcha/i,
  /document\.(write|cookie|location)/,
  /<meta\s[^>]*http-equiv=["']refresh["']/i,
].freeze

SOFT_404_PATTERNS = [
  /page\s+not\s+found/i,
  /this\s+page\s+could\s+not\s+be\s+found/i,
  /404\s*(not\s*)?found/i,
].freeze

MIN_ARTICLE_CHARS = 200
MIN_PRINTABLE_RATIO = 0.80

def printable_ratio(text)
  printable = text.count(" -~\n\r\t")
  total = text.length
  total > 0 ? printable.to_f / total : 0.0
end

def content_passes_gates(body, url)
  return :empty if body.nil? || body.empty?

  # JS blocker / challenge detection (structural)
  return :js_blocker if JS_BLOCKER_PATTERNS.any? { |p| body.match?(p) }

  # Soft 404 via title + h1
  doc = Nokogiri::HTML(body)
  title = doc.at_css('title')&.text || ''
  h1 = doc.at_css('h1')&.text || ''
  combined = title + ' ' + h1
  return :soft_404 if SOFT_404_PATTERNS.any? { |p| combined.match?(p) }

  # Strip HTML, check plain text length
  text = doc.text.strip
  return :too_short if text.length < MIN_ARTICLE_CHARS

  # Check printable character ratio
  return :binary if printable_ratio(text) < MIN_PRINTABLE_RATIO

  :pass
end

def extract_article_simple(url, open_timeout: 10, read_timeout: 20)
  result = {
    'url' => url,
    'title' => nil,
    'fetch_status' => nil,
    'content' => nil,
    'error' => nil,
    'fetched_at' => Time.now.utc.iso8601
  }

  return result.merge('fetch_status' => 'skipped') if url.nil? || url.empty?

  begin
    uri = URI(url)
    unless uri.is_a?(URI::HTTP)
      return result.merge('fetch_status' => 'skipped', 'error' => "non-http scheme: #{uri.scheme}")
    end

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = uri.scheme == 'https'
    http.open_timeout = open_timeout
    http.read_timeout = read_timeout
    http.max_retries = 0

    request = Net::HTTP::Get.new(uri.request_uri)
    request['User-Agent'] = 'Mozilla/5.0 (compatible; yuedulijie.com/1.0; HN article fetcher)'
    request['Accept'] = 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8'
    request['Accept-Language'] = 'en-US,en;q=0.5'

    resp = http.request(request)

    # Gate 1: HTTP status
    code = resp.code.to_i
    unless code == 200
      status = case code
               when 403 then 'blocked'
               when 404 then 'not_found'
               else 'error'
               end
      return result.merge('fetch_status' => status, 'error' => "HTTP #{code}")
    end

    # Gate 2: Content-Type must be HTML
    content_type = (resp['Content-Type'] || '').downcase
    unless content_type.start_with?('text/html', 'application/xhtml+xml')
      return result.merge('fetch_status' => 'skipped', 'error' => "non-html content-type: #{content_type}")
    end

    body = resp.body
    body.force_encoding('UTF-8')
    unless body.valid_encoding?
      body = body.encode('UTF-8', invalid: :replace, undef: :replace)
    end

    # Gates 3-6: content quality
    gate = content_passes_gates(body, url)
    unless gate == :pass
      return result.merge('fetch_status' => 'error', 'error' => "gate: #{gate}")
    end

    # Parse article
    doc = Nokogiri::HTML(body)
    result['title'] = doc.at_css('title')&.text&.strip

    doc.css(
      'script, style, nav, footer, header, aside, noscript, iframe, ' \
      '.sidebar, .nav, .menu, .comments, .comment-list, .related-posts'
    ).each(&:remove)

    article_el = doc.at_css(
      'article, main, [role="main"], .article, .post-content, ' \
      '.entry-content, .content, .post, .blog-post, #content'
    )
    content_source = article_el || doc.at_css('body') || doc

    markdown = ReverseMarkdown.convert(content_source.inner_html, unknown_tags: :drop)
    markdown = markdown.gsub(/\n{3,}/, "\n\n").strip

    result['content'] = markdown[0, ARTICLE_TRUNCATE]
    result['fetch_status'] = 'success'
  rescue Net::OpenTimeout, Net::ReadTimeout => e
    result.merge('fetch_status' => 'error', 'error' => "timeout: #{e.message[0, 100]}")
  rescue => e
    result.merge('fetch_status' => 'error', 'error' => e.message[0, 500])
  end

  result
end

# ── Per-domain concurrency limiter ──

def with_domain(domain)
  $domain_mutex.synchronize do
    $domain_conns[domain] ||= 0
    while $domain_conns[domain] >= MAX_PER_DOMAIN
      $domain_cv.wait($domain_mutex)
    end
    $domain_conns[domain] += 1
  end

  yield
ensure
  $domain_mutex.synchronize do
    current = $domain_conns[domain]
    $domain_conns[domain] = current && current > 0 ? current - 1 : 0
    $domain_cv.broadcast
  end
end

# ── Cache path helpers ──

def week_key(date = Date.today)
  year = date.cwyear.to_s
  week = date.cweek.to_s.rjust(2, '0')
  [year, "W#{week}"]
end

def post_cache_dir(post_id, date: nil)
  date ||= Date.today
  yr, wk = week_key(date)
  File.join(CACHE_DIR, yr, wk, post_id)
end

def stories_index_path
  yr, wk = week_key
  File.join(CACHE_DIR, yr, wk, 'stories.yaml')
end

def find_post_dir(post_id)
  Dir.glob(File.join(CACHE_DIR, '*', 'W*', post_id, 'post.yaml')).each do |f|
    dir = File.dirname(f)
    return dir if File.directory?(dir)
  end
  nil
end

def cache_fresh?(post_id)
  dir = find_post_dir(post_id)
  return false unless dir
  post_file = File.join(dir, 'post.yaml')
  return false unless File.exist?(post_file)
  YAML.safe_load_file(post_file, permitted_classes: [Time])
rescue
  false
end

def load_cached_post(post_id)
  dir = find_post_dir(post_id)
  return nil unless dir
  f = File.join(dir, 'post.yaml')
  File.exist?(f) ? YAML.safe_load_file(f, permitted_classes: [Time]) : nil
rescue
  nil
end

def load_cached_comments(post_id)
  dir = find_post_dir(post_id)
  return nil unless dir
  f = File.join(dir, 'comments.yaml')
  File.exist?(f) ? YAML.safe_load_file(f, permitted_classes: [Time]) : nil
rescue
  nil
end

def load_cached_article(post_id)
  dir = find_post_dir(post_id)
  return nil unless dir
  f = File.join(dir, 'article.yaml')
  File.exist?(f) ? YAML.safe_load_file(f, permitted_classes: [Time]) : nil
rescue
  nil
end

def write_cache(post_id, post_data, comments_data, article_data)
  dir = post_cache_dir(post_id)
  FileUtils.mkdir_p(dir)
  File.write(File.join(dir, 'post.yaml'), YAML.dump(post_data))
  File.write(File.join(dir, 'comments.yaml'), YAML.dump(comments_data))
  File.write(File.join(dir, 'article.yaml'), YAML.dump(article_data))
  dir
end

# ── Core fetch + cache ──

def fetch_and_cache(hn_url, known_meta: nil, force: false, article_mode: :renderer,
                    simple_timeout: 20)
  post_id = known_meta ? known_meta['id'] : hn_url[/\d+/]
  return [:error, nil, "no post_id extracted from #{hn_url}"] unless post_id

  if !force && cache_fresh?(post_id)
    cached_post = load_cached_post(post_id)
    comments = load_cached_comments(post_id)
    article = load_cached_article(post_id)
    if cached_post && known_meta && known_meta['descendants'] == cached_post['raw_comment_count']
      return [:cached, { 'post' => cached_post, 'comments' => comments, 'article' => article }, nil]
    end
  end

  disc = fetch_discussion(post_id)
  unless disc
    cached_comments = load_cached_comments(post_id)
    if cached_comments && cached_comments['comments']&.any?
      return [:cached, { 'post' => load_cached_post(post_id), 'comments' => cached_comments, 'article' => load_cached_article(post_id) }, nil]
    end
    return [:error, nil, "failed to fetch discussion for #{post_id}"]
  end

  article_url = disc.post_url || known_meta&.dig('url')

  post_data = {
    'id' => post_id,
    'title' => disc.post_title,
    'url' => article_url,
    'hn_url' => hn_url,
    'score' => known_meta ? known_meta['score'] : disc.score,
    'author' => known_meta ? known_meta['author'] : disc.author,
    'posted_at' => disc.posted_at,
    'fetched_at' => Time.now.utc.iso8601,
    'article_url' => article_url,
    'article_fetch_status' => nil,
    'article_fetched_at' => nil,
    'raw_comment_count' => disc.raw_comment_count,
  }

  cached_article = load_cached_article(post_id)

  article_data = case article_mode
                 when :skip
                   cached_article || { 'fetch_status' => 'skipped' }

                 when :simple
                   domain = URI.parse(article_url.to_s).host rescue nil
                   if domain
                     with_domain(domain) do
                       attempt = extract_article_simple(article_url, read_timeout: simple_timeout)
                       if attempt['fetch_status'] == 'success'
                         attempt
                       elsif cached_article && cached_article['fetch_status'] == 'success'
                         cached_article
                       else
                         attempt
                       end
                     end
                   else
                     cached_article || extract_article_simple(article_url, read_timeout: simple_timeout)
                   end

                 else # :renderer
                   if cached_article && cached_article['fetch_status'] == 'success' && cached_article['url'] == article_url && !force
                     cached_article
                   else
                     extract_article(article_url)
                   end
                 end

  post_data['article_fetch_status'] = article_data['fetch_status']
  post_data['article_fetched_at'] = article_data['fetched_at'] if article_data['fetched_at']

  comments_data = { 'comments' => disc.comments }

  dir = write_cache(post_id, post_data, comments_data, article_data)

  [:fetched, { 'post' => post_data, 'comments' => comments_data, 'article' => article_data, 'dir' => dir }, nil]
end

# ── stdout summary ──

def print_result_line(result)
  return unless result

  post = result['post']
  return unless post

  id = post['id']
  title = post['title'] || ''
  score = post['score'] || 0
  comments = result['comments']
  active_count = comments ? comments['comments'].length : 0
  raw_count = post['raw_comment_count'] || 0
  article = result['article']
  astat = article ? (article['fetch_status'] || 'unknown') : 'unknown'
  article_chars = (article && article['content']) ? article['content'].length : 0

  parts = []
  parts << "#{id} \"#{title[0, 60]}\" (#{score} pts)"
  parts << "raw:#{raw_count} active:#{active_count}#{active_count == 0 ? ' ⚠' : ''}"

  case astat
  when 'success'      then parts << "article #{article_chars} chars"
  when 'skipped'      then parts << 'no article URL'
  when 'blocked'      then parts << 'article blocked'
  when 'not_found'    then parts << 'article 404'
  when 'error'        then parts << 'article error'
  when 'unknown'      then parts << 'article unknown'
  end

  $print_mutex.synchronize do
    puts "  #{parts.join(' — ')}"
  end
end

# ── stories index writer ──

def write_stories_index(stories)
  existing_ids = Dir.glob('_articles/**/*.md').flat_map { |f|
    File.read(f).scan(/item\?id=(\d+)/).flatten
  }.uniq

  if existing_ids.any?
    before = stories.length
    stories = stories.reject { |s| existing_ids.include?(s['id']) }
    after = stories.length
    puts "  Dedup: #{before - after} stories already in _articles/, #{after} remaining"
  end

  path = stories_index_path
  FileUtils.mkdir_p(File.dirname(path))
  File.write(path, YAML.dump({
    'fetched_at' => Time.now.utc.iso8601,
    'stories' => stories
  }))
end

# ── Parallel processing ──

def process_stories_parallel(stories, force: false, article_mode: :renderer,
                             jobs: 5, simple_timeout: 20)
  queue = Queue.new
  stories.each { |s| queue << s }
  results_queue = Queue.new

  workers = Array.new(jobs) do
    Thread.new do
      loop do
        story = queue.pop(true) rescue nil
        break unless story
        status, result, err = fetch_and_cache(
          story['hn_url'],
          known_meta: story,
          force: force,
          article_mode: article_mode,
          simple_timeout: simple_timeout,
        )
        results_queue << { status: status, result: result, err: err, story: story }
      end
    end
  end

  workers.each(&:join)

  stats = { fetched: 0, cached: 0, articles_ok: 0, errors: 0, error_details: [] }

  until results_queue.empty?
    entry = results_queue.pop(true) rescue nil
    break unless entry

    case entry[:status]
    when :cached
      stats[:cached] += 1
      print_result_line(entry[:result])
    when :fetched
      stats[:fetched] += 1
      print_result_line(entry[:result])
      stats[:articles_ok] += 1 if entry[:result]&.dig('article', 'fetch_status') == 'success'
    when :error
      stats[:errors] += 1
      stats[:error_details] << "  ✗ #{entry[:story]['id']}: #{entry[:err]}"
    end
  end

  stats
end

# ── Fill missing articles (renderer) ──

def fill_missing_articles(jobs: 3)
  yr, wk = week_key
  week_dir = File.join(CACHE_DIR, yr, wk)

  unless Dir.exist?(week_dir)
    puts "No cache found at #{week_dir}"
    return
  end

  Dir.glob(File.join(week_dir, '*', '*.tmp')).each { |f| File.delete(f) rescue nil }

  post_dirs = Dir.glob(File.join(week_dir, '*', 'post.yaml')).map { |f| File.dirname(f) }
  puts "Scanning #{post_dirs.length} posts..."

  to_fill = []
  post_dirs.each do |dir|
    post_id = File.basename(dir)
    article_path = File.join(dir, 'article.yaml')

    status = if File.exist?(article_path)
               begin
                 YAML.safe_load_file(article_path, permitted_classes: [Time])['fetch_status']
               rescue
                 'error'
               end
             else
               'missing'
             end

    case status
    when 'success'
      puts "  #{post_id}: success, skip"
    when 'skipped'
      puts "  #{post_id}: skipped (no URL), skip"
    when 'missing'
      puts "  #{post_id}: missing article.yaml, needs fill"
      to_fill << dir
    else
      puts "  #{post_id}: #{status}, needs fill"
      to_fill << dir
    end
  end

  if to_fill.empty?
    puts "All articles have 'success' status. Nothing to fill."
    return
  end

  puts "Found #{to_fill.length} articles to fill"

  ru = RENDERER_URL
  begin
    resp = Net::HTTP.get_response(URI("#{ru}/health"))
    unless resp.code.to_i == 200
      puts "Renderer unhealthy (HTTP #{resp.code}). Skip fill."
      return
    end
  rescue => e
    puts "Renderer unreachable: #{e.message}. Skip fill."
    return
  end
  puts "Renderer healthy."

  queue = Queue.new
  to_fill.each { |d| queue << d }
  results_mutex = Mutex.new
  results = { filled: 0, skipped: 0, errors: 0 }

  threads = Array.new([jobs, to_fill.length].min) do
    Thread.new do
      loop do
        dir = queue.pop(true) rescue nil
        break unless dir
        fill_one_article(dir, results, results_mutex)
      end
    end
  end

  threads.each(&:join)

  puts "\nFill summary: #{results[:filled]} filled, #{results[:skipped]} skipped, #{results[:errors]} errors"
end

def fill_one_article(dir, results, mutex)
  post_path = File.join(dir, 'post.yaml')
  post = YAML.safe_load_file(post_path, permitted_classes: [Time])
  post_id = post['id']
  article_url = post['article_url'] || post['url']

  unless article_url
    mutex.synchronize { results[:skipped] += 1 }
    puts "  #{post_id}: no URL, skip"
    return
  end

  puts "  #{post_id}: fetching #{article_url[0, 80]}..."

  article = extract_article(article_url)

  if article['fetch_status'] == 'success' && article['content'] && !article['content'].strip.empty?
    article_path = File.join(dir, 'article.yaml')
    tmp_path = article_path + '.tmp'
    File.write(tmp_path, YAML.dump(article))
    File.rename(tmp_path, article_path)

    post['article_fetch_status'] = 'success'
    post['article_fetched_at'] = article['fetched_at']
    File.write(post_path, YAML.dump(post))

    chars = article['content'].length
    puts "  #{post_id}: filled (#{chars} chars)"
    mutex.synchronize { results[:filled] += 1 }
  else
    reason = article['fetch_status'] || 'unknown'
    reason = 'empty content' if article['fetch_status'] == 'success' && (!article['content'] || article['content'].strip.empty?)
    puts "  #{post_id}: renderer failed (#{reason})"
    mutex.synchronize { results[:errors] += 1 }
  end
end

# ── CLI ──

def run
  options = {
    mode: nil, url: nil, force: false, max: MAX_DEFAULT, output: nil,
    jobs: 5, fetch_articles_simple: false, skip_articles: false,
    timeout: 20
  }

  OptionParser.new do |opts|
    opts.banner = "Usage: ruby scripts/hn-fetch.rb [options]"
    opts.on('--best', 'Fetch HN /best page') { options[:mode] = :best }
    opts.on('--url URL', 'Fetch single HN post') { |v| options[:mode] = :url; options[:url] = v }
    opts.on('--fetch-article-url URL', 'Fetch single article URL, print content to stdout, exit') { |v|
      options[:mode] = :fetch_article_url; options[:url] = v
    }
    opts.on('--max N', Integer, "Max posts to fetch (default: #{MAX_DEFAULT})") { |v| options[:max] = v }
    opts.on('--force', 'Force re-fetch, ignore cache') { options[:force] = true }
    opts.on('--jobs N', Integer, "Parallel workers (default: 5)") { |v| options[:jobs] = v }
    opts.on('--fetch-articles-simple', 'Use simple HTTP fetch (no renderer) for articles') {
      options[:fetch_articles_simple] = true
    }
    opts.on('--skip-articles', 'Skip article fetching entirely') {
      options[:skip_articles] = true
    }
    opts.on('--timeout N', Integer, "Read timeout in seconds for simple article fetch (default: 20)") { |v|
      options[:timeout] = v
    }
    opts.on('--fill-missing', 'Scan cache and fill missing articles via renderer') {
      options[:mode] = :fill_missing
    }
    opts.on('--output DIR', "Cache root (#{CACHE_DIR})") { |v| options[:output] = v }
    opts.on('-h', '--help') { puts opts; exit }
  end.parse!

  # ── --fetch-article-url mode: single URL to stdout ──
  if options[:mode] == :fetch_article_url
    result = extract_article_simple(options[:url],
                                    open_timeout: 8, read_timeout: options[:timeout])
    if result['fetch_status'] == 'success'
      puts result['content']
    else
      warn "ERROR: #{result['error'] || result['fetch_status']}"
      exit 1
    end
    return
  end

  # ── --fill-missing mode ──
  if options[:mode] == :fill_missing
    fill_missing_articles(jobs: options[:jobs])
    return
  end

  unless options[:mode]
    warn "ERROR: use --best, --url, --fetch-article-url, or --fill-missing"
    exit 1
  end

  now = Time.now.utc
  puts "=" * 50
  puts "HN Data Fetcher"
  puts "Mode: #{options[:mode]}"
  puts "Date: #{now.strftime('%Y-%m-%d %H:%M UTC')}"
  puts "Jobs: #{options[:jobs]}"
  puts "=" * 50

  # ── --url mode: single HN post ──
  if options[:mode] == :url
    unless options[:url].match?(/news\.ycombinator\.com/)
      warn "ERROR: expected HN URL"
      exit 1
    end
    article_mode = options[:skip_articles] ? :skip :
                   options[:fetch_articles_simple] ? :simple : :renderer
    puts "\nFetching..."
    status, result, err = fetch_and_cache(
      options[:url],
      force: options[:force],
      article_mode: article_mode,
      simple_timeout: options[:timeout],
    )
    if status == :error
      warn "ERROR: #{err}"
      exit 1
    end
    print_result_line(result)
    puts "\nDone!"
    return
  end

  # ── --best mode ──
  puts "\n[1/3] Fetching HN best page (API)..."
  stories = fetch_stories
  puts "  #{stories.length} stories"
  write_stories_index(stories)

  stories.first(10).each do |s|
    url_tag = s['url'] ? ' [link]' : ' [text]'
    puts "    [#{s['score']}] #{s['title'][0, 70]}#{url_tag}"
  end

  if stories.length > 10
    puts "    ... and #{stories.length - 10} more"
  end

  article_mode = options[:skip_articles] ? :skip :
                 options[:fetch_articles_simple] ? :simple : :renderer

  puts "\n[2/3] Fetching discussions... (parallel: #{options[:jobs]} workers, article mode: #{article_mode})"

  stats = process_stories_parallel(
    stories,
    force: options[:force],
    article_mode: article_mode,
    jobs: options[:jobs],
    simple_timeout: options[:timeout],
  )

  unless stats[:error_details].empty?
    stats[:error_details].each { |line| warn line }
  end

  puts "\n---"
  puts "Summary: #{stats[:fetched]} fetched, #{stats[:cached]} cached, #{stats[:articles_ok]} articles, #{stats[:errors]} errors"
end

run
