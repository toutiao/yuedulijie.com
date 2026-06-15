---
name: hn-discussion-summary
description: Create Chinese HN discussion summary article for yuedulijie.com
metadata:
  domain: content
  collection: articles
---

## Phase 0 — Scan (no URL given)

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

## Phase 0.5 — Cluster Detection (auto)

After post selected or URL given:
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

### Single post mode
1. `webfetch` HN page (markdown format)
2. If linked article exists, `webfetch` target page
3. Extract: topic clusters / quotes+usernames / unique opinions
4. For each quote used, record HN comment item id

### Cluster mode
1. Main post: top 20 top-level comments
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
---
```

### Structure (fixed order)
1. **原文概要** — context intro, 2-5 paragraphs
   - Note source: "HN 首页 (/news)" or "HN 热门榜 (/best)"
2. **讨论焦点** — key themes in `###` sections
   - Cluster mode: blockquotes annotate source `[thread #N]`
3. **典型观点一览** — table, columns: 立场 / 用户 / 一句话
4. **总体情绪** — 1-2 paragraphs
5. **引用帖子** — markdown table: # / 标题 / URL (auto-generated)
6. **免责声明** — `<div class="disclaimer">` at bottom

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
4. If build fails: report errors, fix, rebuild
4. If build passes, check article tag:
   - Normal path (no tag): ask deploy? → yes → auto-deploy skill
   - Flagged path (⚑ sensitive or ⚑ political context):
     - Show: "⚠ Sensitive topics detected. Extended disclaimer added. Review required."
     - Show matched terms
     - Add extended disclaimer line: "This article involves topics of public debate. Content presented for informational purposes only."
     - Ask: "Confirm deploy? [y/N]" (default NO)
     - y → deploy with extended disclaimer
     - N → article stays local, not committed
