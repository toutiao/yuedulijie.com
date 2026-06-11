---
name: hn-discussion-summary
description: Create Chinese HN discussion summary article for yuedulijie.com
metadata:
  domain: content
  collection: articles
---

## Phase 0 — Scan (no URL given)

1. `webfetch` https://news.ycombinator.com/best (text format)
2. Parse stories: title + score + item URL
3. Filter:
   - score >= 80
   - dedup: grep item id in `_articles/*.md`
   - topic: AI/programming/engineering/startup/open source/culture
4. Show top 5 candidates:

   ```
   HN hot candidates:
   [1] Title (N pts)
   [2] Title (N pts)
   ...

   Input: number / URL / "n" to skip
   ```

## Phase 1 — Fetch + Analyze

1. `webfetch` target HN page (markdown format)
2. If topic has linked article, `webfetch` target page too
3. Extract: topic clusters / quotes+usernames / unique opinions

## Phase 2 — Write

### Front matter
```
---
layout: post
title: "Topic — HN discussion digest"
date: YYYY-MM-DD
categories: [articles]
---
```

### Structure (fixed order)
1. **原文概要** — context intro, 2-5 paragraphs
2. **讨论焦点** — key themes in `###` sections
   - Per section: context paragraph -> blockquote (EN + CN translation)
3. **典型观点一览** — table, columns: 立场 / 用户 / 一句话
4. **总体情绪** — 1-2 paragraphs
5. **免责声明** — `<div class="disclaimer">` at bottom

### Format rules
| Rule | Example |
|------|---------|
| Quote + attribution same line | `> "text" — user` |
| CN translation separate line | `> （译文）` |
| Tech terms in backticks | `` `R1` ``, `` `BPEL` `` |
| Product names NO backticks | LangChain, OpenAI, Claude |
| General concepts NO backticks | agent, framework, API |

### Disclaimer
```html
<div class="disclaimer">
**免责声明**: 原文链接 <URL>. 观点来自 HN 评论者, 不代表本人立场.
</div>
```

### Naming
`_articles/YYYY-MM-DD-hn-keywords.md`

## Phase 3 — Output

1. Save to `_articles/`
2. `bundle exec jekyll build`
3. Ask: deploy? -> load auto-deploy skill
