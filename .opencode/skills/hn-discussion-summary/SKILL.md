---
name: hn-discussion-summary
description: Create Chinese HN discussion summary article for yuedulijie.com
metadata:
  domain: content
  collection: articles
---

## Auto Mode Detection

If the command includes `--auto` or env `CI=true`/`GITHUB_ACTIONS=true`, run in **auto mode**:
no user prompts, auto-decide cluster/single, auto-build, auto-deploy.
Otherwise run in **interactive mode** (existing flow).

## Phase 0 — Scan (no URL given)

### Auto mode (--auto or CI)

1. Try reading stories index from hn-fetch cache:
   - Glob `_data/hn/20*/W*/stories.yaml`
   - Parse and extract stories list (most recent week's file)
   - If cache missing → `webfetch` HN best (text format)
2. Parse stories: title + score + item URL
3. Filter:
   - score >= 80
   - dedup: item id not in `_articles/*.md`
   - same topic not covered today (grep today's date + keyword)
4. Sort by score descending
5. Auto-select top candidate
6. Report: "Auto-selected: [title] ([score] pts)"
7. Proceed to Phase 0.5

### Interactive mode (no --auto)

1. `webfetch` https://news.ycombinator.com/best?h=48 (text format)
2. Parse stories: title + score + item URL
3. Filter:
   - score >= 80
   - dedup: item id not in `_articles/*.md`
   - same topic not covered today (grep today's date + keyword)
4. For each remaining candidate, detect political context:
   - Check title against political keywords (election, protest, war, sanction, human rights, etc.)
   - If match, append tag: `⚑ political context`
5. Show top 5 candidates:

   ```
   HN hot candidates:
   [1] Title (N pts)
   [2] Title (N pts) ⚑ political context
   ...

   Input: number / URL / "n" to skip
   ```

## Phase 0.5 — Cluster Detection

After post selected or URL given:

### Auto mode (--auto or CI)

1. Derive keyword from selected post title:
   - Drop leading common words (Claude, new, update, Introducing)
   - Take first remaining meaningful token
2. Scan remaining candidates (from Phase 0) for same keyword, score >= 80, not self
3. If >= 2 related posts → **cluster mode** (include all related posts)
4. If < 2 → **single post mode**
5. Report: "Mode: [cluster/single], including N posts"

### Interactive mode (no --auto)

1. `webfetch` HN source page (format: html)
   - Topic from `/best` → `https://news.ycombinator.com/best?h=48`
   - Topic from `/news` → start at `/news`, follow "morelink" until score < 80 or age > 48h (parse "X hours ago" / "X days ago")
2. Parse `<tr class="athing">`: extract `id` + title + score
3. Derive keyword from selected post title:
   - Drop leading common words (Claude, new, update, Introducing)
   - Take first remaining meaningful token
4. Filter: title contains keyword, score >= 80, not self
5. If >= 2 matches → show:

   ```
   Detected cluster — {N} related posts:
     [1] {title} ({score} pts) — MAIN
     [2] {title} ({score} pts)
     ...
   Include all? [y] / select numbers [1,3,5] / [n] skip
   ```

   Otherwise → single post mode.

6. User input sets cluster scope for Phase 1.

## Phase 1 — Fetch + Analyze

Before fetching, try hn-fetch cache for each post:

1. Search cache: glob `_data/hn/20*/W*/<post_id>/comments.yaml`
2. If found and comments array is non-empty → use cached discussion data (skip webfetch for this post)
3. If found but comments is empty → cache is stale, fall back to webfetch
4. If not found → webfetch HN page

Also check `_data/hn/*/<post_id>/article.yaml` for cached article text.
If fetch_status == 'success': include in Gemini prompt context.

### Single post mode
1. `webfetch` HN page (markdown format) — skip if valid cache found
2. If linked article exists, `webfetch` target page — skip if cached article available
3. Extract: topic clusters / quotes+usernames / unique opinions
4. For each quote used, record HN comment item id

### Cluster mode
1. Main post: top 20 top-level comments (from cache or webfetch)
2. Each related post: top 8 top-level comments
3. Track `thread_id` per quote (e.g. "[thread 2]")
4. Merge all comments, group by theme (not by thread)

## Phase 2 — Write

Before writing, load chinese-writing-style skill.
(引文原文不受 style 约束, 保持原样. 翻译和讨论段受约束.)

### Front matter (date 自动填充, 禁止手动输入)
```
---
layout: post
title: "Topic — HN discussion digest"
date: $(date +%Y-%m-%d)
categories: [articles]
excerpt: "一句话摘要（1-2 句，~80 字）"
tagline: "浮夸版（不对外展示，搜索引擎可见）"
---
```

### excerpt 写作要求
- 短文（<3000 字）：精悍，一句话点明核心洞察
- 长文（>=3000 字）：钩子，挑最有趣/最反直觉的角度引读者点进去
- 不写 hacky/clickbait 句式，不写"震惊""惊人""万万没想到"
- 电影/书籍类：不剧透，含剧透须在开头标注「⚠ 含剧透」
- 例句参考：
  - ✅ "每天 5 分钟深呼吸就能改变你做风险决策的方式。"
  - ✅ "这个 0.2B 参数模型在图像修复任务上击败了 10B 级模型。"
  - ❌ "你绝对想不到深呼吸能带来什么变化！"

### tagline 写作要求
- 浮夸、轻松、卖焦虑、发散，不设限
- 必须有原文事实作为锚点（文章的事件/观点），不能凭空编造
- 可以夸张、可以调侃、可以贩卖焦虑，但不能脱离事实基础
- 不对外展示，位于 front matter 中，通过 `<a title="...">` 被搜索引擎索引
- 电影/书籍类：不剧透，含剧透须在开头标注「⚠ 含剧透」
- 风格参考：

  | 类别 | 特点 | 示例 |
  |------|------|------|
  | 吐槽/调侃 | 轻松拆台式幽默 | curl 维护者：黑客不休息？那我先休了。 |
  | 卖焦虑/FOMO | 制造紧迫感 | Anthropic 的护城河正在蒸发，速度比你想象的要快。 |
  | 金句/格言体 | 短促有力 | 救火的被奖励，防火的被遗忘。这是组织的终极真相。 |
  | 直击本质 | 一句话戳穿 | 你只是想写个代码，Anthropic 却要你的护照照片。 |
  | 感性/催泪 | 温柔一刀 | 全片台词不到十句，看完想给所有人打个电话。 |
  | 反讽/黑色幽默 | 冷嘲热讽 | 花最贵的钱，用最不确定的服务——AI 时代的买椟还珠。 |
  | 脑洞/发散 | 跨域类比 | 你抓精灵的时候，Niantic 在帮你参军。 |
  | 短促/悬念 | 半句话勾起好奇 | 中国电影史上最短的剧本：沿着城墙走，走不完的路。 |

### Structure (fixed order)
1. **原文概要** — context intro, 2-5 paragraphs
   - Note source: "HN 首页 (/news)" or "HN 热门榜 (/best)"
2. **讨论焦点** — key themes in `###` sections
   - Cluster mode: blockquotes annotate source `[thread #N]`
3. **典型观点一览** — table, columns: 立场 / 用户 / 一句话
4. **总体情绪** — 1-2 paragraphs
5. **引用帖子** — markdown table: # / 标题 / URL (auto-generated)
6. **免责声明** — `<div class="disclaimer">` at bottom, 含 AI 模型 disclosure 行

### Format rules
| Rule | Example |
|------|---------|
| Quote + attribution same line | `> "text" — user` |
| CN translation separate line | `> （译文）` |
| Tech terms in backticks | `` `R1` ``, `` `BPEL` `` |
| Product names NO backticks | LangChain, OpenAI, Claude |
| General concepts NO backticks | agent, framework, API |
| Source annotation (cluster) | `> "text" — user [thread 2]` |

### Naming
`_articles/YYYY-MM-DD-hn-keywords.md`

### AI 模型 disclosure
在免责声明末尾 append 一行，格式固定：
```
<br><br><em>本摘要由 AI 模型辅助生成：{provider}/{model}</em>
```
{provider}/{model} 必须填实际使用的模型，例如 `google/gemini-2.5-flash` 或 `deepseek/deepseek-v4-flash`。
禁止编造模型名。如果不知道完整名称，写 `{provider}/{model}` 原文（不替换）。

## Phase 2.5 — Fact Check (REQUIRED, no skip)

### Quote verification
For each blockquoted quote in the article:
1. `webfetch` HN comment page (format: html) — `https://news.ycombinator.com/item?id={comment_id}`
2. Locate comment in page: `<span class="commtext c00">`
3. Compare rendered text vs article quote:
   - Must match verbatim (no paraphrase, no added detail)
   - Attribution (username) must match
   - Ellipsis (...) must not change original meaning
   - CN translation must faithfully reflect EN intent
4. Fix any flagged discrepancy
5. Report per quote: ✓ verified / ⚠ fixed / ✗ flagged

### Sensitivity scan
After quote verification, scan article body for sensitive terms:
- Match list: `[china/ccp/tiananmen/taiwan/tibet/xinjiang/hong kong]` + `[censorship/surveillance/human rights/propaganda]`
- Scan article text (including blockquotes, excluding disclaimer)
- If hit found → tag article `⚑ sensitive`, continue to Phase 3 flagged path
- If clean → normal path

## Phase 3 — Output

1. Save to `_articles/`
2. 验证 date 字段:
   - `grep "date: $(date +%Y-%m-%d)"` 文章文件
   - 匹配 → 继续
   - 不匹配 → 报错 "date field mismatch", 自动修正为当天日期, 重新构建
3. `bundle exec jekyll build`
4. If build fails: report errors, fix, rebuild (max 1 retry)

### Auto mode (--auto or CI)

5. If build passes, check article tag:
   - Normal path: `git add -A && git commit -m "feat: HN 自动摘要 $(date +%Y-%m-%d)" && git push`
   - Flagged path (⚑ sensitive or ⚑ political context):
     - Add extended disclaimer line: "This article involves topics of public debate. Content presented for informational purposes only."
     - `git add -A && git commit -m "feat: HN 自动摘要 $(date +%Y-%m-%d)" && git push`
     - Show warning: "⚠ Sensitive article deployed. Review recommended."
6. No user prompts. Exit 0 on success.

### Interactive mode (no --auto)

5. If build passes, check article tag:
   - Normal path (no tag): ask deploy? → yes → auto-deploy skill
   - Flagged path (⚑ sensitive or ⚑ political context):
     - Show: "⚠ Sensitive topics detected. Extended disclaimer added. Review required."
     - Show matched terms
     - Add extended disclaimer line: "This article involves topics of public debate. Content presented for informational purposes only."
     - Ask: "Confirm deploy? [y/N]" (default NO)
     - y → deploy with extended disclaimer
     - N → article stays local, not committed
