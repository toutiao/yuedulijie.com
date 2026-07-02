#!/usr/bin/env ruby
# frozen_string_literal: true

# HN Data Fetcher — cache HN discussions + target articles for AI consumption
#
# Usage:
#   ruby scripts/hn-fetch.rb --best [--max N] [--force]
#   ruby scripts/hn-fetch.rb --url <hn_url> [--force]
#   ruby scripts/hn-fetch.rb --output <dir>  # override cache root

require 'net/http'
require 'uri'
require 'yaml'
require 'nokogiri'
require 'reverse_markdown'
require 'date'
require 'fileutils'
require 'optparse'
require 'time'
require 'net/http'
require 'uri'

RENDERER_URL = ENV.fetch('RENDERER_URL', 'http://localhost:3000')

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

$stdout.sync = true

CACHE_DIR = '_data/hn'
CACHE_TTL = 3600
HN_BEST_URL = 'https://news.ycombinator.com/best'
SCORE_THRESHOLD = 80
MAX_DEFAULT = 15
COMMENT_THRESHOLD = 0
COMMENT_CAP = 100
DISCUSSION_TRUNCATE = 80_000
ARTICLE_TRUNCATE = 8000

USER_AGENTS = [
  'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36',
  'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:136.0) Gecko/20100101 Firefox/136.0',
  'Mozilla/5.0 (Macintosh; Intel Mac OS X 14_6) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.0 Safari/605.1.15',
  'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36',
  'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36 Edg/142.0.0.0',
]

# ── HTTP ──

def fetch(uri_str, max_retries: 2, timeout: 30)
  uri = URI(uri_str)
  retries = 0
  begin
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = uri.scheme == 'https'
    http.open_timeout = timeout
    http.read_timeout = timeout
    request = Net::HTTP::Get.new(uri.request_uri)
    request['User-Agent'] = USER_AGENTS.sample
    request['Accept'] = 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8'
    request['Accept-Language'] = 'en-US,en;q=0.9'
    request['Accept-Encoding'] = 'gzip, deflate, br'
    request['DNT'] = '1'
    request['Connection'] = 'keep-alive'
    request['Upgrade-Insecure-Requests'] = '1'
    response = http.request(request)
    [response.code.to_i, response.body.force_encoding('UTF-8')]
  rescue Net::ReadTimeout, Net::OpenTimeout,
         Errno::ECONNREFUSED, Errno::ECONNRESET => e
    retries += 1
    if retries <= max_retries
      sleep retries * 3
      retry
    end
    raise "Failed to fetch #{uri_str}: #{e.message}"
  end
end

# ── HN best page parser ──

def parse_best_page(html)
  doc = Nokogiri::HTML(html)
  stories = []

  doc.css('tr.athing').each do |row|
    id = row['id']
    next unless id

    link = row.at_css('.titleline a') || row.at_css('td.title a.storylink')
    next unless link

    title = link.text.strip
    raw_url = link['href']
    url = raw_url.match?(/\Ahttps?:\/\//) ? raw_url : nil

    score = 0
    author = nil
    sib = row.next_element
    while sib
      score_el = sib.at_css('.score')
      if score_el
        m = score_el.text.match(/(\d+)/)
        score = m[1].to_i if m
      end
      user_el = sib.at_css('.hnuser')
      author = user_el.text.strip if user_el
      break if score_el
      sib = sib.next_element
    end

    stories << {
      'id' => id,
      'title' => title,
      'url' => url,
      'hn_url' => "https://news.ycombinator.com/item?id=#{id}",
      'score' => score,
      'author' => author
    }
  end

  stories
end

# ── HN discussion page parser ──

DiscussionResult = Struct.new(:post_title, :post_url, :score, :author, :posted_at, :comments, :raw_comment_count)

def parse_discussion_page(html, hn_url)
  doc = Nokogiri::HTML(html)
  post_id = hn_url[/\d+/]

  title_el = doc.at_css('title')
  post_title = title_el ? title_el.text.strip.sub(/\A[HN: ]+/, '').strip : 'HN Discussion'

  posted_at = nil
  age_el = doc.at_css('.age')
  posted_at = age_el['title'] if age_el && age_el['title']

  story_link = doc.at_css('.titleline a')
  post_url = story_link ? story_link['href'] : nil
  post_url = nil unless post_url&.match?(/\Ahttps?:\/\//)

  author_el = doc.at_css('.hnuser')
  author = author_el ? author_el.text.strip : nil

  score = 0
  score_el = doc.at_css('.score')
  score = score_el.text[/\d+/].to_i if score_el

  comments = []
  doc.css('tr.athing.comtr').each do |row|
    cid = row['id']
    next unless cid

    user_el = row.at_css('.hnuser')
    username = user_el&.text&.strip || 'anonymous'

    cscore = 0
    cscore_el = row.at_css('.score')
    cscore = cscore_el.text[/\d+/].to_i if cscore_el

    text_el = row.at_css('.commtext')
    text = text_el&.text&.strip || ''
    next if text.empty?

    c_age_el = row.at_css('.age')
    c_posted_at = c_age_el&.text&.strip

    ind_el = row.at_css('.ind img')
    parent_id = ind_el && ind_el['width'] ? post_id : nil

    comments << {
      'id' => cid,
      'parent_id' => parent_id,
      'author' => username,
      'text' => text,
      'score' => cscore,
      'posted_at' => c_posted_at
    }
  end

  active = comments.select { |c| c['score'] >= COMMENT_THRESHOLD }
  if active.length > 20
    active = active.sort_by { |c| -c['score'] }.first(COMMENT_CAP)
  end

  DiscussionResult.new(post_title, post_url, score, author, posted_at, active, comments.length)
end

# ── Article extraction (nokogiri + reverse_markdown) ──

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
  begin
    post = YAML.safe_load_file(post_file, permitted_classes: [Time])
    ts = post['fetched_at']
    return false unless ts
    (Time.now - Time.parse(ts)) < CACHE_TTL
  rescue
    false
  end
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

def fetch_and_cache(hn_url, known_meta: nil, force: false)
  post_id = known_meta ? known_meta['id'] : hn_url[/\d+/]
  return [:error, nil, "no post_id extracted from #{hn_url}"] unless post_id

  if !force && cache_fresh?(post_id)
    cached = load_cached_post(post_id)
    comments = load_cached_comments(post_id)
    article = load_cached_article(post_id)
    return [:cached, { 'post' => cached, 'comments' => comments, 'article' => article }, nil]
  end

  begin
    status_code, html = fetch_with_browser(hn_url)
  rescue => e
    return [:error, nil, "fetch discussion failed: #{e.message}"]
  end

  disc = parse_discussion_page(html, hn_url)

  if disc.raw_comment_count == 0 && known_meta && known_meta['score'].to_i >= SCORE_THRESHOLD
    if status_code == 429 || html.match?(/Sorry/)
      sleep 30
      _, html = fetch_with_browser(hn_url)
      disc = parse_discussion_page(html, hn_url)
    end
  end

  if disc.raw_comment_count == 0 && !force
    cached_comments = load_cached_comments(post_id)
    if cached_comments && cached_comments['comments']&.any?
      cached_post = load_cached_post(post_id)
      cached_article = load_cached_article(post_id)
      return [:cached, { 'post' => cached_post, 'comments' => cached_comments, 'article' => cached_article }, nil]
    end
  end

  post_data = {
    'id' => post_id,
    'title' => disc.post_title,
    'url' => known_meta ? known_meta['url'] : disc.post_url,
    'hn_url' => hn_url,
    'score' => known_meta ? known_meta['score'] : disc.score,
    'author' => known_meta ? known_meta['author'] : disc.author,
    'posted_at' => disc.posted_at,
    'fetched_at' => Time.now.utc.iso8601,
    'article_url' => disc.post_url,
    'article_fetch_status' => nil,
    'raw_comment_count' => disc.raw_comment_count
  }

  article_url = disc.post_url
  if article_url.nil? && known_meta
    article_url = known_meta['url']
  end

  article_data = extract_article(article_url)
  post_data['article_fetch_status'] = article_data['fetch_status']

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
  parts << "✓ #{id} \"#{title[0, 60]}\" (#{score} pts)"
  parts << "raw:#{raw_count} active:#{active_count}#{active_count == 0 ? ' ⚠' : ''}"

  case astat
  when 'success'      then parts << "article #{article_chars} chars"
  when 'skipped'      then parts << 'no article URL'
  when 'blocked'      then parts << 'article blocked'
  when 'not_found'    then parts << 'article 404'
  when 'error'        then parts << 'article error'
  when 'unknown'      then parts << 'article unknown'
  end

  puts "  #{parts.join(' — ')}"
end

# ── stories index writer ──

def write_stories_index(stories, cache_root)
  dir = post_cache_dir('_index_')
  FileUtils.mkdir_p(File.dirname(dir))
  index_file = File.join(File.dirname(dir), 'stories.yaml')
  File.write(index_file, YAML.dump({
    'fetched_at' => Time.now.utc.iso8601,
    'stories' => stories
  }))
end

# ── CLI ──

def run
  options = { mode: nil, url: nil, force: false, max: MAX_DEFAULT, output: nil }
  OptionParser.new do |opts|
    opts.banner = "Usage: ruby scripts/hn-fetch.rb [options]"
    opts.on('--best', 'Fetch HN /best page') { options[:mode] = :best }
    opts.on('--url URL', 'Fetch single HN post') { |v| options[:mode] = :url; options[:url] = v }
    opts.on('--max N', Integer, "Max posts to fetch (default: #{MAX_DEFAULT})") { |v| options[:max] = v }
    opts.on('--force', 'Force re-fetch, ignore cache') { options[:force] = true }
    opts.on('--output DIR', "Cache root (#{CACHE_DIR})") { |v| options[:output] = v }
    opts.on('-h', '--help') { puts opts; exit }
  end.parse!

  unless options[:mode]
    warn "ERROR: use --best or --url"
    exit 1
  end

  now = Time.now.utc
  puts "=" * 50
  puts "HN Data Fetcher"
  puts "Mode: #{options[:mode]}"
  puts "Date: #{now.strftime('%Y-%m-%d %H:%M UTC')}"
  puts "=" * 50

  if options[:mode] == :url
    unless options[:url].match?(/news\.ycombinator\.com/)
      warn "ERROR: expected HN URL"
      exit 1
    end
    puts "\nFetching..."
    status, result, err = fetch_and_cache(options[:url], force: options[:force])
    if status == :error
      warn "ERROR: #{err}"
      exit 1
    end
    print_result_line(result)
    puts "\nDone!"
    return
  end

  puts "\n[1/3] Fetching HN best page..."
  _, html = fetch_with_browser(HN_BEST_URL)
  stories = parse_best_page(html)
  puts "  #{stories.length} stories"
  write_stories_index(stories, options[:output] || CACHE_DIR)

  stories.sort_by { |s| -s['score'] }.first(10).each do |s|
    url_tag = s['url'] ? ' [link]' : ' [text]'
    puts "    [#{s['score']}] #{s['title'][0, 70]}#{url_tag}"
  end

  candidates = stories
    .select { |s| s['score'] >= SCORE_THRESHOLD }
    .sort_by { |s| -s['score'] }
    .first(options[:max])

  puts "\n[2/3] Candidates (#{candidates.length}, score >= #{SCORE_THRESHOLD}):"
  candidates.each { |s| puts "  [#{s['score']}] #{s['title'][0, 70]}" }

  puts "\n[3/3] Fetching discussions..."
  fetched = 0
  cached = 0
  articles_ok = 0
  errors = 0

  candidates.each_with_index do |story, i|
    sleep rand(2.0..5.0) if i > 0

    status, result, err = fetch_and_cache(
      story['hn_url'],
      known_meta: story,
      force: options[:force]
    )

    case status
    when :cached
      cached += 1
      print_result_line(result)
    when :fetched
      fetched += 1
      print_result_line(result)
      articles_ok += 1 if result && result.dig('article', 'fetch_status') == 'success'
    when :error
      errors += 1
      warn "  ✗ #{story['id']}: #{err}"
    end
  end

  puts "\n---"
  puts "Summary: #{fetched} fetched, #{cached} cached, #{articles_ok} articles, #{errors} errors"
end

run
