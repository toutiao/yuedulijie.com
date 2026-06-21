#!/usr/bin/env ruby
# frozen_string_literal: true

# HN Auto-Summarizer — daily HN discussion summary articles for yuedulijie.com
#
# CI mode (no args):
#   GEMINI_API_KEY=xxx bundle exec ruby scripts/hn-auto.rb
#
# Local mode (with HN URL):
#   GEMINI_API_KEY=xxx bundle exec ruby scripts/hn-auto.rb https://news.ycombinator.com/item?id=12345678

require 'net/http'
require 'uri'
require 'json'
require 'nokogiri'
require 'set'
require 'date'
require 'fileutils'

# ── Configuration ──────────────────────────────────────────────────

GEMINI_API_KEY = ENV['GEMINI_API_KEY']
HN_BEST_URL = 'https://news.ycombinator.com/best'
ARTICLES_DIR = '_articles'
SCORE_THRESHOLD = 80
MAX_ARTICLES = 2
GEMINI_MODEL = 'gemini-2.5-flash'

LOCAL_MODE = ARGV.any? { |a| a.match?(/\Ahttps?:\/\//) }

unless GEMINI_API_KEY
  warn "ERROR: GEMINI_API_KEY environment variable not set"
  exit 1
end

# ── HTTP Helpers ───────────────────────────────────────────────────

def fetch(uri_str, max_retries: 2, timeout: 30)
  uri = URI(uri_str)
  retries = 0
  begin
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = uri.scheme == 'https'
    http.open_timeout = timeout
    http.read_timeout = timeout

    request = Net::HTTP::Get.new(
      uri.request_uri,
      'User-Agent' => 'Mozilla/5.0 (compatible; HNAutoSummarizer/1.0)'
    )
    http.request(request).body.force_encoding('UTF-8')
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

def call_gemini(system_prompt, user_prompt)
  uri = URI("https://generativelanguage.googleapis.com/v1beta/models/" \
            "#{GEMINI_MODEL}:generateContent?key=#{GEMINI_API_KEY}")

  body = {
    system_instruction: { parts: [{ text: system_prompt }] },
    contents: [{ parts: [{ text: user_prompt }] }],
    generationConfig: { temperature: 0.3, maxOutputTokens: 4096 }
  }

  retries = 0
  begin
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.open_timeout = 30
    http.read_timeout = 120

    request = Net::HTTP::Post.new(
      uri.request_uri,
      'Content-Type' => 'application/json'
    )
    request.body = JSON.generate(body)

    response = http.request(request)
    result = JSON.parse(response.body)

    candidate = result.dig('candidates', 0)
    text = candidate&.dig('content', 'parts', 0, 'text')
    unless text
      raise "Gemini API error: #{JSON.pretty_generate(result)}"
    end

    warn "  WARNING: Response truncated (MAX_TOKENS)" if candidate['finishReason'] == 'MAX_TOKENS'
    text
  rescue Net::ReadTimeout, Net::OpenTimeout => e
    retries += 1
    if retries <= 2
      sleep retries * 5
      retry
    end
    raise "Gemini API timeout: #{e.message}"
  end
end

# ── HN Scraper ─────────────────────────────────────────────────────

def parse_stories(html)
  doc = Nokogiri::HTML(html)
  stories = []

  doc.css('tr.athing').each do |row|
    id = row['id']
    next unless id

    link = row.at_css('.titleline a') || row.at_css('td.title a.storylink')
    next unless link

    title = link.text.strip
    url = link['href']
    url = "https://news.ycombinator.com/#{url}" unless url.match?(/\Ahttps?:\/\//)

    score = 0
    sib = row.next_element
    while sib
      score_el = sib.at_css('.score')
      if score_el
        m = score_el.text.match(/(\d+)/)
        score = m[1].to_i if m
        break
      end
      sib = sib.next_element
    end

    stories << {
      id: id, title: title, url: url,
      hn_url: "https://news.ycombinator.com/item?id=#{id}",
      score: score
    }
  end

  stories
end

def get_existing_keywords
  keywords = Set.new
  Dir["#{ARTICLES_DIR}/*.md"].each do |f|
    stem = File.basename(f, '.md').sub(/^\d{4}-\d{2}-\d{2}-/, '').downcase
    stem.split('-').each { |w| keywords << w if w.length > 3 }
  end
  keywords
end

def select_stories(stories, existing_keywords)
  stories = stories.select { |s| s[:score] >= SCORE_THRESHOLD }
  return [] if stories.empty?

  stories.sort_by! { |s| -s[:score] }

  filtered = stories.reject do |s|
    words = s[:title].downcase.scan(/[a-z0-9]+/).to_set
    (words & existing_keywords).length >= 3
  end

  return [] if filtered.empty?

  selected = [filtered.shift]
  selected << filtered.sample unless filtered.empty?
  selected.first(MAX_ARTICLES)
end

def extract_discussion(hn_url)
  html = fetch(hn_url)
  doc = Nokogiri::HTML(html)

  title_el = doc.at_css('title')
  story_title = title_el&.text&.strip || "HN Discussion"

  comments = []
  doc.css('.commtext').each do |el|
    username_el = el.ancestors('tr').first&.at_css('.comhead a')
    username = username_el&.text&.strip || 'anonymous'
    text = el.text.strip
    next if text.empty?
    comments << "@#{username}: #{text}"
  end

  text = "Title: #{story_title}\nURL: #{hn_url}\n\n"
  text += "--- Comments (#{comments.length}) ---\n#{comments.join("\n\n")}" unless comments.empty?
  [text, story_title]
end

# ── Article Generator ──────────────────────────────────────────────

EXAMPLE_ARTICLE = <<~EXAMPLE
---
layout: post
title: "GLM-5.2 — 开源权重模型新领跑者，HN 讨论摘要"
date: 2026-06-19
categories: [articles]
---

## 原文概要

[简要介绍原文内容(2-3段)，注明文章来源]

## 讨论焦点

### 焦点标题

> "英文原文引用" — 用户名

中文分析...

## 典型观点一览

| 立场 | 用户 | 一句话 |
|------|------|--------|
| ... | ... | ... |

## 总体情绪

[总结讨论的情绪倾向]

**总体情绪：[积极/消极/中性/争议性]**

## 引用帖子

| # | 标题 | URL |
|---|------|-----|
| 1 | ... | ... |

<div class="disclaimer">
本文为 Hacker News 讨论的中文摘要，仅作信息整理之用。文中引用的用户观点不代表本文立场。原文内容请参阅 HN 原帖。
</div>
EXAMPLE

SYSTEM_PROMPT = <<~PROMPT
你是一个专业的中文科技新闻摘要编辑。你的任务是根据 Hacker News 讨论内容撰写一篇中文摘要文章。

格式要求（必须严格遵守）：
1. Jekyll front matter: layout: post, title, date, categories: [articles]
2. 标题格式: "{原文标题} — HN 讨论摘要"
3. 章节（按顺序）：
   - ## 原文概要（2-3段，介绍原文 + HN 讨论概况，注明来源）
   - ## 讨论焦点（3-5个焦点，用 > 引用原文评论+用户名，配中文分析）
   - ## 典型观点一览（markdown 表格，列：立场 | 用户 | 一句话，至少4行）
   - ## 总体情绪（总结 + **总体情绪：[标签]**）
   - ## 引用帖子（表格：| # | 标题 | URL |，至少3行）
   - <div class="disclaimer">...</div>
4. 引用必须原文英文 + 中文翻译
5. 简体中文，客观中立
6. 不要用 emoji
7. 不要添加额外的说明文字，直接输出完整文章

参考示例：
#{EXAMPLE_ARTICLE}
PROMPT

def slugify(title)
  words = title.scan(/[a-zA-Z0-9]+/)
  stopwords = %w[a an the is it to in for of on and or be with]
  keywords = words.reject { |w| stopwords.include?(w.downcase) }.first(5).map(&:downcase)
  keywords.join('-').empty? ? 'hn-discussion' : keywords.join('-')
end

def write_article(text, story_title, article_date, hn_url)
  today_str = article_date.strftime('%Y-%m-%d')
  filename = "#{today_str}-hn-#{slugify(story_title)}.md"
  filepath = File.join(ARTICLES_DIR, filename)

  unless text.start_with?("---")
    article_title = "#{story_title} — HN 讨论摘要"
    front_matter = <<~FM
      ---
      layout: post
      title: "#{article_title}"
      date: #{today_str}
      categories: [articles]
      ---

    FM
    text = front_matter + text
  end

  File.write(filepath, text)
  puts "  -> #{filepath}"
  filepath
end

# ── Build & Git (CI only) ─────────────────────────────────────────

def run_build
  puts "  Building Jekyll..."
  out = `bundle exec jekyll build 2>&1`
  unless $?.success?
    puts "  Jekyll build FAILED:\n#{out[0..2000]}"
    return false
  end
  puts "  Jekyll build OK"
  true
end

def git_commit_push
  status = `git status --porcelain`.strip
  return false if status.empty?

  puts "  Staging..."
  system("git add -A") || raise("git add failed")

  today = Time.now.utc.strftime('%Y-%m-%d')
  msg = "feat: HN 自动摘要 #{today}"
  puts "  Committing: #{msg}"
  system("git commit -m '#{msg}'") || raise("git commit failed")

  puts "  Pushing..."
  system("git push origin HEAD") || begin
    puts "  Push failed, trying pull --rebase..."
    system("git pull --rebase origin HEAD") || raise("git rebase failed")
    system("git push origin HEAD") || raise("git push retry failed")
  end
  puts "  Push OK"
  true
end

# ── Main ───────────────────────────────────────────────────────────

def process_story(hn_url, date:, idx: nil)
  prefix = idx ? "  Story #{idx}" : "  Story"
  puts "#{prefix}: #{hn_url}"

  puts "  Fetching discussion..."
  discussion, title = extract_discussion(hn_url)

  if discussion.length > 80_000
    discussion = discussion[0...80_000] + "\n\n[...truncated]"
  end

  puts "  Calling Gemini API..."
  article = call_gemini(SYSTEM_PROMPT,
    "请为以下 Hacker News 讨论生成中文摘要文章。\n\n讨论内容：\n#{discussion}")

  puts "  Writing article..."
  write_article(article, title, date, hn_url)
end

def run
  now = Time.now.utc
  puts "=" * 50
  puts "HN Auto-Summarizer"
  puts "Mode: #{LOCAL_MODE ? 'local' : 'CI'}"
  puts "Date: #{now.strftime('%Y-%m-%d %H:%M UTC')}"
  puts "=" * 50

  if LOCAL_MODE
    # ── Local mode: process provided URL ──
    url = ARGV.find { |a| a.match?(/\Ahttps?:\/\//) }
    puts "\n[1/1] Processing single URL..."
    process_story(url, date: now)
    puts "\nDone! Article created in #{ARTICLES_DIR}/"
    return
  end

  # ── CI mode: fetch HN best → select → generate → build → push ──

  # Step 1: Fetch HN best page
  puts "\n[1/6] Fetching HN best page..."
  best_html = fetch(HN_BEST_URL)

  # Step 2: Parse stories
  puts "[2/6] Parsing stories..."
  stories = parse_stories(best_html)
  puts "  Found #{stories.length} stories"
  stories.sort_by { |s| -s[:score] }.first(10).each do |s|
    puts "    [#{s[:score]}] #{s[:title][0..70]}"
  end

  # Step 3: Select stories
  puts "[3/6] Selecting stories..."
  existing = get_existing_keywords
  selected = select_stories(stories, existing)
  if selected.empty?
    puts "  No new stories to summarize"
    return
  end
  puts "  Selected #{selected.length} stories:"
  selected.each { |s| puts "    [#{s[:score]}] #{s[:title][0..70]}" }

  # Step 4: Generate articles
  puts "[4/6] Generating articles..."
  generated = []
  selected.each_with_index do |story, i|
    begin
      path = process_story(story[:hn_url], date: now, idx: i + 1)
      generated << path
    rescue => e
      puts "  ERROR on story #{i + 1}: #{e.message}"
    end
  end

  if generated.empty?
    puts "\nNo articles generated"
    return
  end

  # Step 5: Build
  puts "\n[5/6] Validating Jekyll build..."
  unless run_build
    puts "  Build failed, reverting..."
    generated.each { |f| File.delete(f) if File.exist?(f) }
    system("git checkout -- .")
    exit 1
  end

  # Step 6: Commit & push
  puts "[6/6] Committing and pushing..."
  git_commit_push

  puts "\nDone! Generated and published:"
  generated.each { |f| puts "   #{f}" }
end

run
