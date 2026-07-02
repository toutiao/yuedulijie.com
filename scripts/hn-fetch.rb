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

CACHE_DIR = '_data/hn'
CACHE_TTL = 3600
SCORE_THRESHOLD = 80
MAX_DEFAULT = 15
COMMENT_THRESHOLD = 0
COMMENT_CAP = 100
ARTICLE_TRUNCATE = 8000
HN_API_BASE = 'https://hacker-news.firebaseio.com/v0'
$hn_http = nil

def hn_http
  $hn_http ||= begin
    uri = URI(HN_API_BASE)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.open_timeout = 10
    http.read_timeout = 15
    http.start
    http
  end
end

def fetch_via_api(endpoint)
  resp = hn_http.get("/v0/#{endpoint}")
  body = JSON.parse(resp.body)
  [resp.code.to_i, body]
rescue => e
  raise "API fetch failed #{endpoint}: #{e.message}"
end

def fetch_stories
  _, ids = fetch_via_api('beststories.json')
  ids.first(MAX_DEFAULT * 2).map do |id|
    _, item = fetch_via_api("item/#{id}.json")
    next unless item && item['type'] == 'story' && item['score'] && item['score'] >= SCORE_THRESHOLD
    {
      'id' => id.to_s,
      'title' => item['title'] || '',
      'url' => item['url'],
      'hn_url' => "https://news.ycombinator.com/item?id=#{id}",
      'score' => item['score'],
      'author' => item['by'] || '',
    }
  end.compact.first(MAX_DEFAULT)
end

def parse_comments(ids)
  comments = []
  ids.each do |cid|
    _, c = fetch_via_api("item/#{cid}.json")
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

def fetch_discussion(post_id)
  _, item = fetch_via_api("item/#{post_id}.json")
  return nil unless item

  comments = item['kids'] ? parse_comments(item['kids']) : []
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

DiscussionResult = Struct.new(:post_title, :post_url, :score, :author, :posted_at, :comments, :raw_comment_count)

# ── Browser fetch (for article JS rendering) ──

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

  disc = fetch_discussion(post_id)
  unless disc
    cached_comments = load_cached_comments(post_id)
    if cached_comments && cached_comments['comments']&.any?
      return [:cached, { 'post' => load_cached_post(post_id), 'comments' => cached_comments, 'article' => load_cached_article(post_id) }, nil]
    end
    return [:error, nil, "failed to fetch discussion for #{post_id}"]
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
    'raw_comment_count' => disc.raw_comment_count,
  }

  article_url = disc.post_url
  article_url = known_meta['url'] if article_url.nil? && known_meta

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

  puts "\n[1/3] Fetching HN best page (API)..."
  stories = fetch_stories
  puts "  #{stories.length} stories"
  write_stories_index(stories, options[:output] || CACHE_DIR)

  stories.first(10).each do |s|
    url_tag = s['url'] ? ' [link]' : ' [text]'
    puts "    [#{s['score']}] #{s['title'][0, 70]}#{url_tag}"
  end

  if stories.length > 10
    puts "    ... and #{stories.length - 10} more"
  end

  puts "\n[2/3] Fetching discussions..."
  fetched = 0
  cached = 0
  articles_ok = 0
  errors = 0

  stories.each_with_index do |story, i|
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
ensure
  $hn_http&.finish rescue nil
end

run
