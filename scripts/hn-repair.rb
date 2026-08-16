require 'json'
require 'net/http'
require 'yaml'

REQUIRED_KEYS = %w[layout title date categories]

def changed_articles
  `git status --porcelain -- _articles/`.lines.map { |l| l.strip.split(/\s+/, 2).last }.compact.uniq
end

def front_matter_yaml(content)
  content.match(/\A---\r?\n(.*?)\r?\n---/m)&.[](1)
end

def validate_front_matter(content)
  errors = []
  fm = front_matter_yaml(content)
  errors << 'no front matter' unless fm
  if fm
    begin
      data = YAML.safe_load(fm, permitted_classes: [Date, Time])
    rescue => e
      errors << "YAML parse error: #{e.message.lines.first.strip}"
      data = nil
    end
    if data.is_a?(Hash)
      REQUIRED_KEYS.each { |k| errors << "missing key: #{k}" if data[k].to_s.empty? }
      errors << "bad date: #{data['date']}" unless data['date'].to_s =~ /\A\d{4}-\d{2}-\d{2}\z/
    end
  end
  errors
end

def call_llm(prompt)
  if ENV['GOOGLE_GENERATIVE_AI_API_KEY']
    call_gemini(prompt)
  elsif ENV['DEEPSEEK_API_KEY']
    call_deepseek(prompt)
  else
    abort 'no AI API key (GOOGLE_GENERATIVE_AI_API_KEY / DEEPSEEK_API_KEY)'
  end
end

def call_gemini(prompt)
  key = ENV['GOOGLE_GENERATIVE_AI_API_KEY']
  uri = URI("https://generativelanguage.googleapis.com/v1beta/models/gemini-3.5-flash:generateContent?key=#{key}")
  req = Net::HTTP::Post.new(uri)
  req['Content-Type'] = 'application/json'
  req.body = { contents: [{ parts: [{ text: prompt }] }] }.to_json
  res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) { |h| h.request(req) }
  JSON.parse(res.body).dig('candidates', 0, 'content', 'parts', 0, 'text').to_s
end

def call_deepseek(prompt)
  key = ENV['DEEPSEEK_API_KEY']
  uri = URI('https://api.deepseek.com/chat/completions')
  req = Net::HTTP::Post.new(uri)
  req['Content-Type'] = 'application/json'
  req['Authorization'] = "Bearer #{key}"
  req.body = { model: 'deepseek-chat', messages: [{ role: 'user', content: prompt }] }.to_json
  res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) { |h| h.request(req) }
  JSON.parse(res.body).dig('choices', 0, 'message', 'content').to_s
end

def strip_fence(text)
  text.sub(/\A\s*```(?:markdown|md)?\s*\n?/, '').sub(/\n?```\s*\z/, '')
end

def repair_prompt(file, errors)
  <<~PROMPT
    修复 Jekyll 文章的 front matter。文件: #{file}

    检测错误:
    #{errors.map { |e| "  - #{e}" }.join("\n")}

    规则:
    - front matter 必须是合法 YAML
    - title/excerpt/tagline 用 block scalar `>-`，绝不用双引号 scalar（ASCII `"` 会终止 YAML）
    - 只修 front matter，正文一字不改

    文件内容:
    #{File.read(file)}

    只输出修复后的完整 markdown 文件。
  PROMPT
end

def generate_content_or_retry_once(input)
  feedback = nil
  outcome = yield(input, feedback)
  return outcome if outcome == true
  feedback = outcome.first
  yield(input, feedback)
end

check_only = ARGV.delete('--check-only')

failed = {}
changed_articles.each do |file|
  if check_only
    errs = validate_front_matter(File.read(file))
    failed[file] = errs unless errs.empty?
    next
  end
  result = generate_content_or_retry_once(file) do |f, feedback|
    if feedback
      repaired = strip_fence(call_llm(repair_prompt(f, feedback)))
      errs = validate_front_matter(repaired)
      if errs.empty?
        File.write(f, repaired)
        true
      else
        [errs, false]
      end
    else
      errs = validate_front_matter(File.read(f))
      errs.empty? ? true : [errs, false]
    end
  end
  failed[file] = result unless result == true
end

failed.each { |file, errs| warn "FAIL #{file}: #{errs.join('; ')}" }
exit(failed.empty? ? 0 : 1)
