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
require 'yaml'
require 'nokogiri'
require 'set'
require 'date'
require 'time'
require 'fileutils'

# ── Configuration ──────────────────────────────────────────────────

GEMINI_API_KEY = ENV['GEMINI_API_KEY']
HN_BEST_URL = 'https://news.ycombinator.com/best'
ARTICLES_DIR = '_articles'
SCORE_THRESHOLD = 80
MAX_ARTICLES = 2
GEMINI_MODEL = 'gemini-2.5-flash'
CACHE_DIR = '_data/hn'

LOCAL_MODE = ARGV.any? { |a| a.match?(/\Ahttps?:\/\//) }
FROM_CACHE = ARGV.include?('--from-cache')

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

def call_gemini(system_prompt, user_prompt, temperature: 0.3, max_tokens: 4096)
  uri = URI("https://generativelanguage.googleapis.com/v1beta/models/" \
            "#{GEMINI_MODEL}:generateContent?key=#{GEMINI_API_KEY}")

  body = {
    system_instruction: { parts: [{ text: system_prompt }] },
    contents: [{ parts: [{ text: user_prompt }] }],
    generationConfig: { temperature: temperature, maxOutputTokens: max_tokens }
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

# ── Cache Helpers ──────────────────────────────────────────────────

def find_post_cache_dir(post_id)
  Dir.glob(File.join(CACHE_DIR, '*', 'W*', post_id, 'comments.yaml')).each do |f|
    dir = File.dirname(f)
    return dir if File.directory?(dir)
  end
  nil
end

def reconstruct_discussion_from_cache(dir)
  comments_file = File.join(dir, 'comments.yaml')
  post_file = File.join(dir, 'post.yaml')
  return nil unless File.exist?(comments_file)

  comments_data = YAML.safe_load_file(comments_file, permitted_classes: [Time])
  post_data = File.exist?(post_file) ? YAML.safe_load_file(post_file, permitted_classes: [Time]) : nil

  title = post_data ? post_data['title'] || 'HN Discussion' : 'HN Discussion'
  hn_url = post_data ? post_data['hn_url'] || '' : ''

  lines = ["Title: #{title}", "URL: #{hn_url}", ""]
  (comments_data['comments'] || []).each do |c|
    lines << "[comment: #{c['id']} | score: #{c['score']} | user: #{c['author']}]"
    lines << (c['text'] || '')
    lines << "---"
  end

  text = lines.join("\n")
  text = text[0...80_000] + "\n\n[...truncated]" if text.length > 80_000
  [text, title]
end

def load_article_from_cache(dir)
  article_file = File.join(dir, 'article.yaml')
  return nil unless File.exist?(article_file)

  data = YAML.safe_load_file(article_file, permitted_classes: [Time])
  return nil unless data && data['fetch_status'] == 'success'
  data['content']
end

def load_stories_index
  today = Date.today
  prev = today - 7
  [today, prev].each do |date|
    yr = date.cwyear.to_s
    wk = date.cweek.to_s.rjust(2, '0')
    index_path = File.join(CACHE_DIR, yr, "W#{wk}", 'stories.yaml')
    next unless File.exist?(index_path)

    data = YAML.safe_load_file(index_path, permitted_classes: [Time])
    stories = data['stories']
    next unless stories.is_a?(Array) && !stories.empty?

    return stories.map do |s|
      {
        id: s['id'], title: s['title'], url: s['url'],
        hn_url: s['hn_url'], score: s['score']
      }
    end
  end
  nil
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
  doc.css('tr.athing.comtr').each do |row|
    comment_id = row['id']
    next unless comment_id

    user_el = row.at_css('.hnuser')
    username = user_el&.text&.strip || 'anonymous'

    score = 0
    score_el = row.at_css('.score')
    if score_el
      m = score_el.text.match(/(\d+)/)
      score = m[1].to_i if m
    end

    text_el = row.at_css('.commtext')
    text = text_el&.text&.strip || ''
    next if text.empty?

    comments << { id: comment_id, score: score, user: username, text: text }
  end

  # Filter low-scored comments
  active = comments.select { |c| c[:score] > 1 }

  # Sort by score desc, cap at 40
  if active.length > 20
    active = active.sort_by { |c| -c[:score] }.first(40)
  end

  # Build structured output
  lines = ["Title: #{story_title}", "URL: #{hn_url}", ""]
  active.each do |c|
    lines << "[comment: #{c[:id]} | score: #{c[:score]} | user: #{c[:user]}]"
    lines << c[:text]
    lines << "---"
  end
  text = lines.join("\n")
  text = text[0...80_000] + "\n\n[...truncated]" if text.length > 80_000

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

[简要介绍原文内容(2-3段)，注明来源："HN 热门榜 (/best)"]

## 讨论焦点

### 焦点标题

> "英文原文引用" — 用户名 [comment: 12345678]
> （中文翻译）

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

## 格式要求（必须严格遵守）

### Front matter
---
layout: post
title: "{原文标题} — HN 讨论摘要"
date: {当前日期}
categories: [articles]
excerpt: "[一句话摘要]"
tagline: "[浮夸版，不对外展示]"
---

### 章节顺序
1. ## 原文概要（2-3 段，介绍原文内容 + HN 讨论概况，注明来源 "HN 热门榜 (/best)"）
2. ## 讨论焦点（3-5 个焦点，每个焦点用 ### 副标题）
3. ## 典型观点一览（markdown 表格：立场 | 用户 | 一句话，至少 4 行）
4. ## 总体情绪（1-2 段总结 + **总体情绪：[积极/消极/中性/争议性]**）
5. ## 引用帖子（表格：# | 标题 | URL，至少 3 行，列出原始 HN 帖和相关参考链接）
6. <div class="disclaimer">...</div>

### 引用格式
- 引文原文与 attribution 同一行：> "text" — username [comment: NNNNNN]
- comment id 取自每条评论的标题行（如 [comment: 12345678 | score: 5 | user: john]），放在 attribution 之后
- 中文翻译另起一行
- 引文原文必须保持原样，不得改写、润色、简化

### 格式规则
- 技术术语加 backtick：`R1` / `BPEL` / `agent` / `prompt`
- 产品名不加 backtick：LangChain, OpenAI, Claude
- 通用概念不加 backtick：agent, framework, API

### 中文写作规范
- 中文正文使用全角引号 ""
- 英文术语保持原样，首字母大写
- 通用概念使用中文：维护者 / 代码审查 / 开源项目
- 不翻译：品牌名、文件名、版本号、命令
- 客观语气，不使用"竟然""令人震惊""不得不"等情绪词
- 引用 attribution 使用"表示""指出""认为"，不使用"声称""宣称"
- 每段不超过 5 行
- 每篇文章独立可读，不依赖本系列其他文章，不提及"前文""上篇""本系列"
- 讨论段：一句话点明引文的洞察或指向的问题。想不到就不写，宁可没有也不要强行深刻

### excerpt 字段要求
- excerpt 写在 front matter 中，一句话概括文章核心（1-2 句，~80 字）
- 短文（<3000 字）：精悍，点明核心洞察
- 长文（>=3000 字）：钩子，挑最有趣/最反直觉的角度
- 不浮夸，不用"震惊""惊人""万万没想到"
- 电影/书籍类：不剧透，含剧透须在开头标注「⚠ 含剧透」

### tagline 字段要求
- tagline 写在 front matter 中，风格浮夸、轻松、卖焦虑、发散，不设限
- 必须有原文事实作为锚点（文章的事件/观点），不能凭空编造
- 不对外展示，通过 `<a title="...">` 被搜索引擎索引
- 电影/书籍类：不剧透，含剧透须在开头标注「⚠ 含剧透」
- 风格参考：
  | 类别 | 特点 | 示例 |
  | 吐槽/调侃 | 轻松拆台式幽默 | curl 维护者：黑客不休息？那我先休了。 |
  | 卖焦虑/FOMO | 制造紧迫感 | Anthropic 的护城河正在蒸发，速度比你想象的要快。 |
  | 金句/格言体 | 短促有力 | 救火的被奖励，防火的被遗忘。这是组织的终极真相。 |
  | 直击本质 | 一句话戳穿 | 你只是想写个代码，Anthropic 却要你的护照照片。 |
  | 反讽/黑色幽默 | 冷嘲热讽 | 花最贵的钱，用最不确定的服务——AI 时代的买椟还珠。 |
  | 脑洞/发散 | 跨域类比 | 你抓精灵的时候，Niantic 在帮你参军。 |

### 其他
- 简体中文
- 不要用 emoji
- 不要添加额外说明文字，直接输出完整文章

参考示例：
#{EXAMPLE_ARTICLE}
PROMPT

# ── Layered Generation (Phase C) ──────────────────────────────────

def call_gemini_layered(discussion_with_ids, story_title, article_prefix = "")
  # Pass 1: Theme clustering (compact, low temp)
  puts "  Pass 1: Theme clustering..."
  cluster_system = "你是一个讨论分析助手。将评论按主题分组，输出紧凑的分组结果。"
  cluster_user = <<~PROMPT
    将以下 HN 讨论评论归纳为 3-5 个主题分组。

    对每个主题输出：
    ## 主题名称 — 简要描述
    - [comment: id] 用户名: 核心观点（一句话）

    只输出分组结果，不要额外说明。

    讨论内容：
    #{discussion_with_ids}
  PROMPT

  clusters = call_gemini(cluster_system, cluster_user, temperature: 0.1, max_tokens: 2000)

  # Extract comment IDs from clusters, filter discussion to subset
  cluster_ids = clusters.scan(/\[comment:\s*(\d+)\]/).flatten.to_set
  filtered_lines = []
  keep = false
  discussion_with_ids.each_line do |line|
    if line.start_with?('[comment:')
      cid = line[/\[comment:\s*(\d+)\]/, 1]
      keep = cid && cluster_ids.include?(cid)
    end
    filtered_lines << line if keep
  end
  filtered_discussion = filtered_lines.join

  warn "  Clusters cover #{cluster_ids.size} comments (filtered from full discussion)"

  # Pass 2: Article with cluster guidance
  puts "  Pass 2: Generating article..."
  article_user = <<~PROMPT
    #{article_prefix}请为以下 Hacker News 讨论生成中文摘要文章。

    讨论主题分组（作为文章结构参考）：
    #{clusters}

    各主题下的原始评论（供精确引用，保留 comment id）：
    #{filtered_discussion}
  PROMPT

  call_gemini(SYSTEM_PROMPT, article_user)
end

# ── Post-generation checks ────────────────────────────────────────

def verify_quotes(article_text)
  results = []
  article_text.scan(/\[comment:\s*(\d+)\]/).flatten.uniq.each do |cid|
    begin
      comment_page = fetch("https://news.ycombinator.com/item?id=#{cid}")
      doc = Nokogiri::HTML(comment_page)
      comment_row = doc.at_css("tr.athing.comtr[id='#{cid}']")
      unless comment_row
        results << { status: '⚠', message: "comment #{cid} not found on HN" }
        next
      end

      original_text = comment_row.at_css('.commtext')&.text&.strip || ''
      original_user = comment_row.at_css('.hnuser')&.text&.strip || ''

      line = article_text.lines.find { |l| l.include?("[comment: #{cid}]") }
      unless line
        results << { status: '⚠', message: "comment #{cid} not found in article text" }
        next
      end

      quoted = line[/"([^"]*)"/, 1] || ''
      article_user = line[/—\s*(\S+)/, 1] || ''

      mismatches = []
      norm_orig = original_text.gsub(/\s+/, ' ')
      norm_quote = quoted.gsub(/\s+/, ' ')
      unless norm_orig.include?(norm_quote) || norm_quote.include?(norm_orig[0..[norm_quote.length, norm_orig.length].min])
        mismatches << "text mismatch"
      end

      unless article_user.downcase == original_user.downcase
        mismatches << "user mismatch: article=#{article_user}, original=#{original_user}"
      end

      if mismatches.empty?
        results << { status: '✓', message: "comment #{cid} — #{article_user}" }
      else
        results << { status: '⚠', message: "comment #{cid} — #{mismatches.join(', ')}" }
      end
    rescue => e
      results << { status: '⚠', message: "comment #{cid} — error: #{e.message}" }
    end
  end
  results
end

SENSITIVE_LEFT = %w[china ccp tiananmen taiwan tibet xinjiang hong_kong]
SENSITIVE_RIGHT = %w[censorship surveillance human_rights propaganda]

def sensitivity_scan(text)
  disclaimer_section = text.match(/<div class="disclaimer">.*?<\/div>/m)
  body = disclaimer_section ? text.sub(disclaimer_section.to_s, '') : text
  body_lower = body.downcase.gsub(' ', '_')

  SENSITIVE_LEFT.each do |left|
    left_idx = body_lower.index(left)
    next unless left_idx
    SENSITIVE_RIGHT.each do |right|
      right_idx = body_lower.index(right, left_idx)
      next unless right_idx
      if right_idx - left_idx <= 200
        warn "  ⚑ SENSITIVE: '#{left.tr('_', ' ')}' near '#{right.tr('_', ' ')}' (#{right_idx - left_idx} chars)"
        warn "    context: ...#{body[left_idx..right_idx + right.length].tr('_', ' ')}..."
        return true
      end
    end
  end
  false
end

def append_extended_disclaimer(filepath)
  text = File.read(filepath)
  extended = '<br>This article involves topics of public debate. Content presented for informational purposes only.'
  if text.include?('</div>')
    text.sub!('</div>', "#{extended}\n</div>")
    File.write(filepath, text)
    true
  else
    false
  end
end

def slugify(title)
  words = title.scan(/[a-zA-Z0-9]+/)
  stopwords = %w[a an the is it to in for of on and or be with]
  keywords = words.reject { |w| stopwords.include?(w.downcase) }.first(5).map(&:downcase)
  keywords.join('-').empty? ? 'hn-discussion' : keywords.join('-')
end

def fallback_excerpt(text)
  body = text.sub(/\A---.*?---\n*/m, '')
    .gsub(/^#+ .*$/, '')
    .gsub(/`([^`]+)`/, '\1')
    .gsub(/\[([^\]]+)\]\([^)]+\)/, '\1')
    .strip.gsub(/\s+/, ' ')
  excerpt = body[0, 120]
  if body.length > 120
    excerpt = excerpt.gsub(/[^。！？.!?\n]*$/, '') + '…'
  end
  excerpt.strip
end

def ensure_frontmatter_fields(text)
  result = text
  unless result =~ /^excerpt: /
    excerpt = fallback_excerpt(result)
    result = result.sub(/^categories:.*$/) { |m| "#{m}\nexcerpt: \"#{excerpt}\"" }
  end
  unless result =~ /^tagline: /
    tagline = result[/^excerpt: "([^"]+)"/, 1] || ''
    result = result.sub(/^(excerpt:.*)$/) { |m| "#{m}\ntagline: \"#{tagline}\"" }
  end
  result
end

def write_article(text, story_title, article_date, hn_url)
  today_str = article_date.strftime('%Y-%m-%d')
  filename = "#{today_str}-hn-#{slugify(story_title)}.md"
  filepath = File.join(ARTICLES_DIR, filename)

  if text.start_with?("---")
    text = text.sub(/^date:.*$/, "date: #{today_str}")
  else
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

  text = ensure_frontmatter_fields(text)

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

def process_story(hn_url, date:, idx: nil, story: nil)
  prefix = idx ? "  Story #{idx}" : "  Story"
  puts "#{prefix}: #{hn_url}"

  post_id = story ? story[:id] : hn_url[/\d+/]
  discussion = nil
  title = nil
  article_text = nil

  cache_dir = post_id ? find_post_cache_dir(post_id) : nil

  if cache_dir
    puts "  Loading from cache: #{cache_dir}"
    discussion, title = reconstruct_discussion_from_cache(cache_dir)
    article_text = load_article_from_cache(cache_dir)
    if article_text
      puts "  Article text loaded: yes (#{article_text.length} chars)"
    else
      puts "  Article text loaded: no"
    end
  end

  unless discussion
    puts "  Cache miss, fetching live..."
    discussion, title = extract_discussion(hn_url)
  end

  comment_count = discussion.scan(/\[comment: \d+\]/).length

  article_prefix = if article_text
    "---原文内容（撰写「原文概要」时优先参考）---\n#{article_text}\n---原文结束---\n\n"
  else
    ""
  end

  if comment_count > 50
    puts "  Large discussion (#{comment_count} comments), using two-pass..."
    article = call_gemini_layered(discussion, title, article_prefix)
  else
    puts "  Calling Gemini API..."
    article = call_gemini(SYSTEM_PROMPT,
      "#{article_prefix}请为以下 Hacker News 讨论生成中文摘要文章。\n\n讨论内容：\n#{discussion}")
  end

  puts "  Writing article..."
  filepath = write_article(article, title, date, hn_url)

  puts "  Verifying quotes..."
  results = verify_quotes(File.read(filepath))
  results.each { |r| puts "    #{r[:status]} #{r[:message]}" }

  puts "  Running sensitivity scan..."
  if sensitivity_scan(File.read(filepath))
    append_extended_disclaimer(filepath)
    puts "    ⚑ Sensitive topics detected, extended disclaimer added"
  else
    puts "    ✓ Clean"
  end

  filepath
end

def run
  now = Time.now.utc
  mode_str = LOCAL_MODE ? 'local' : (FROM_CACHE ? 'CI (from cache)' : 'CI (live)')
  puts "=" * 50
  puts "HN Auto-Summarizer"
  puts "Mode: #{mode_str}"
  puts "Date: #{now.strftime('%Y-%m-%d %H:%M UTC')}"
  puts "=" * 50

  if LOCAL_MODE
    # ── Local mode: process provided URL ──
    url = ARGV.find { |a| a.match?(/\Ahttps?:\/\//) }
    puts "\n[1/1] Processing single URL..."
    post_id = url[/\d+/]
    story = { id: post_id, hn_url: url, url: nil, score: 0, title: nil }
    process_story(url, date: now, story: story)
    puts "\nDone! Article created in #{ARTICLES_DIR}/"
    return
  end

  # ── CI mode: fetch HN best → select → generate → build → push ──

  if FROM_CACHE
    puts "\n[1/5] Loading stories index from cache..."
    stories = load_stories_index
    if stories.nil? || stories.empty?
      puts "  No cached stories found, fetching live..."
      stories = fetch_live_stories
    else
      puts "  Loaded #{stories.length} stories from cache"
      stories.sort_by { |s| -s[:score] }.first(10).each do |s|
        puts "    [#{s[:score]}] #{s[:title][0..70]}"
      end
    end
  else
    stories = fetch_live_stories
  end

  # Step 2: Select stories
  puts "[2/5] Selecting stories..."
  existing = get_existing_keywords
  selected = select_stories(stories, existing)
  if selected.empty?
    puts "  No new stories to summarize"
    return
  end
  puts "  Selected #{selected.length} stories:"
  selected.each { |s| puts "    [#{s[:score]}] #{s[:title][0..70]}" }

  # Step 3: Generate articles
  puts "[3/5] Generating articles..."
  generated = []
  selected.each_with_index do |story, i|
    begin
      path = process_story(story[:hn_url], date: now, idx: i + 1, story: story)
      generated << path
    rescue => e
      puts "  ERROR on story #{i + 1}: #{e.message}"
    end
  end

  if generated.empty?
    puts "\nNo articles generated"
    return
  end

  # Step 4: Build (skip in --from-cache mode, CI handles separately)
  unless FROM_CACHE
    puts "\n[4/5] Validating Jekyll build..."
    unless run_build
      puts "  Build failed, reverting..."
      generated.each { |f| File.delete(f) if File.exist?(f) }
      system("git checkout -- .")
      exit 1
    end

    # Step 5: Commit & push
    puts "[5/5] Committing and pushing..."
    git_commit_push
  end

  puts "\nDone! Generated:"
  generated.each { |f| puts "   #{f}" }
end

def fetch_live_stories
  puts "[1/5] Fetching HN best page..."
  best_html = fetch(HN_BEST_URL)
  stories = parse_stories(best_html)
  puts "  Found #{stories.length} stories"
  stories.sort_by { |s| -s[:score] }.first(10).each do |s|
    puts "    [#{s[:score]}] #{s[:title][0..70]}"
  end
  stories
end

run
