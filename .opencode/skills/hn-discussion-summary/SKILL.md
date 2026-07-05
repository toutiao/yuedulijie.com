---
name: hn-discussion-summary
description: Create Chinese HN discussion summary article for yuedulijie.com
metadata:
  domain: content
  collection: articles
---

## Mode Detection

| Condition | Mode |
|-----------|------|
| `--auto` flag OR env `CI=true` / `GITHUB_ACTIONS=true` | **auto** — no prompts, auto-decide, auto-build, auto-deploy |
| Otherwise | **interactive** — user prompts, confirm deploy |

---

## Phase 0 — Scan (no URL given)

### All modes — Story filtering
Stories must pass all:
- score >= 80
- item id not in `_articles/*.md` (dedup)
- same topic not covered today (grep today's date + keyword in existing articles)

> `stories.yaml` 已由 `hn-fetch.rb` 在写入时做过一次 dedup（过滤已出现在 `_articles/` 中的 HN ID）。此处为第二层检查，防止脚本层漏网。

### Auto mode
1. Source: Read cached stories from `_data/hn/`
   - `glob _data/hn/*/W*/stories.yaml` → pick newest week
   - `read` file → extract `stories` array (each has: id, title, score, hn_url, author, descendants)
2. Apply filters (All modes section)
3. Sort by score descending
4. Auto-select top candidate
5. Report: "Auto-selected: [title] ([score] pts)"
6. Proceed to Phase 0.5
7. Fallback: if no cached data, `webfetch` https://news.ycombinator.com/best?h=48

### Interactive mode
1. Source: `webfetch` https://news.ycombinator.com/best?h=48 (text format)
2. Parse stories: title + score + item URL
3. Apply filters (All modes section)
4. For each candidate, detect political context: title matches political keywords (election, protest, war, sanction, human rights, etc.)
   - If match: append `⚑ political context` tag
5. Show top 5 candidates:

   ```
   HN hot candidates:
   [1] Title (N pts)
   [2] Title (N pts) ⚑ political context
   ...

   Input: number / URL / "n" to skip
   ```

---

## Phase 0.5 — Cluster Detection

### All modes — Keyword derivation
From selected post title: drop leading common words (Claude, new, update, Introducing) → take first remaining meaningful token.

### Auto mode
1. Scan remaining candidates (from Phase 0) for same keyword, score >= 80, not self
2. If >= 2 related posts → **cluster mode** (include all)
3. If < 2 → **single post mode**
4. Report: "Mode: [cluster/single], including N posts"

### Interactive mode
1. `webfetch` HN source page (html format):
   - Topic from `/best` → `https://news.ycombinator.com/best?h=48`
   - Topic from `/news` → start at `/news`, follow "morelink" until score < 80 or age > 48h (parse "X hours ago" / "X days ago")
2. Parse `<tr class="athing">`: extract `id` + title + score
3. Filter by keyword (derived above), score >= 80, not self
4. If >= 2 matches → show:

   ```
   Detected cluster — {N} related posts:
     [1] {title} ({score} pts) — MAIN
     [2] {title} ({score} pts)
     ...
   Include all? [y] / select numbers [1,3,5] / [n] skip
   ```
5. Otherwise → single post mode.
6. User input sets cluster scope for Phase 1.

---

## Phase 1 — Fetch + Analyze

### Cache strategy

Prefer cached data from `_data/hn/`. Fallback to `webfetch` only when cache unavailable.

Cache file locations (replace `YYYY`/`WNN`/`{id}` as needed):
| Data | Path | Key fields |
|------|------|-----------|
| Post metadata | `_data/hn/YYYY/WNN/{id}/post.yaml` | title, score, author, posted_at, raw_comment_count |
| Comments | `_data/hn/YYYY/WNN/{id}/comments.yaml` | comments[].{id, author, text, score} |
| Article | `_data/hn/YYYY/WNN/{id}/article.yaml` | title, fetch_status, content |

Use `glob _data/hn/*/W*/` to find the week dir, then read files for the selected story id.

### Single post mode
1. Read `_data/hn/*/W*/{id}/comments.yaml` → extract quotes + usernames
2. If `article.fetch_status == 'success'`, read `article.yaml` → use `content` field
   - Fallback: `webfetch` linked article URL
3. Extract: topic clusters / quotes+usernames / unique opinions
4. Record HN comment item id for each quote used

### Cluster mode
1. Main post: read cached comments, top 20 by score
2. Each related post: read cached comments, top 8 by score
3. Track `thread_id` per quote (e.g. "[thread 2]")
4. Merge all comments, group by theme (not by thread)

---

## Phase 2 — Write

Load `chinese-writing-style` skill before writing.
(引文原文不受 style 约束, 保持原样. 翻译和讨论段受约束.)

### Front matter
```
---
layout: post
title: "Topic — HN discussion digest"
date: $(TZ=Asia/Shanghai date +%Y-%m-%d)
categories: [articles]
excerpt: >-
  一句话摘要（1-2 句，~80 字）
tagline: >-
  浮夸版（不对外展示，搜索引擎可见）
---
```
⚠ `excerpt` / `tagline` 使用 YAML block scalar `>-`，内容中的 ASCII 双引号 `"` 会被 YAML 解析为字符串终止。若文本内需要引号，用中文书名号《》或转义 `\"`。

⚠ `date` must be auto-filled via `$(TZ=Asia/Shanghai date +%Y-%m-%d)`. Never enter manually.

### excerpt rules
| Article length | Style | Example |
|----------------|-------|---------|
| Short (<3000 chars) | One sentence, core insight | "每天 5 分钟深呼吸就能改变你做风险决策的方式。" |
| Long (>=3000 chars) | Hook, most counterintuitive angle | "这个 0.2B 参数模型在图像修复任务上击败了 10B 级模型。" |

No hacky/clickbait: 震惊, 惊人, 万万没想到. Movies/books: spoiler-free, or prefix `⚠ 含剧透`.

### tagline rules

| Category | Tone | Example |
|----------|------|---------|
| 吐槽/调侃 | 轻松拆台式幽默 | curl 维护者：黑客不休息？那我先休了。 |
| 卖焦虑/FOMO | 制造紧迫感 | Anthropic 的护城河正在蒸发，速度比你想象的要快。 |
| 金句/格言体 | 短促有力 | 救火的被奖励，防火的被遗忘。这是组织的终极真相。 |
| 直击本质 | 一句话戳穿 | 你只是想写个代码，Anthropic 却要你的护照照片。 |
| 感性/催泪 | 温柔一刀 | 全片台词不到十句，看完想给所有人打个电话。 |
| 反讽/黑色幽默 | 冷嘲热讽 | 花最贵的钱，用最不确定的服务——AI 时代的买椟还珠。 |
| 脑洞/发散 | 跨域类比 | 你抓精灵的时候，Niantic 在帮你参军。 |
| 短促/悬念 | 半句话勾起好奇 | 中国电影史上最短的剧本：沿着城墙走，走不完的路。 |

Must anchor to actual article facts (event/viewpoint). Never fabricate. Not displayed externally — lives in front matter, indexed via `<a title="...">`.

### Article content sufficiency check (before writing)

After reading `article.yaml`, check `content` field length:
- `< 2000 chars` → **MUST** run `ruby scripts/hn-fetch.rb --fetch-article-url "<article_url>" --timeout 30` to attempt fuller fetch
- `2000..4000 chars` → **SHOULD** run the same command
- `> 4000 chars` → **MAY** proceed directly

If the fetch succeeds (exit 0), use the stdout content as supplementary context.
If it fails (exit 1), proceed with existing cached content.

### Article structure (fixed order)
1. **原文概要** — context intro, 2-5 paragraphs. Note source: "HN 首页 (/news)" or "HN 热门榜 (/best)"
2. **讨论焦点** — key themes in `###` sections. Each blockquote followed by CN translation:
   ```
   > "English text" — username
   > （中文翻译）
   ```
   - Translation line: no attribution
   - No blank line between quote and translation
   - Cluster mode: attribution → `[thread #N]`
3. **典型观点一览** — table: 立场 / 用户 / 一句话
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
`_articles/YYYY/YYYY-MM-DD-hn-keywords.md`

### AI model disclosure
Append to disclaimer:
```
<br><br><em>本摘要由 AI 模型辅助生成：{provider}/{model}</em>
```
Must use actual model, e.g. `google/gemini-2.5-flash` or `deepseek/deepseek-v4-flash`.
Never fabricate model name. If unsure, write literal `{provider}/{model}`.

---

## Phase 2.5 — Fact Check (REQUIRED, no skip)

### Quote verification per comment
1. `webfetch` HN comment page (html) — `https://news.ycombinator.com/item?id={comment_id}`
2. Locate comment: `<span class="commtext c00">`
3. Compare rendered text vs article quote:
   - Verbatim match (no paraphrase, no added detail)
   - Username attribution must match
   - Ellipsis (...) must not change original meaning
   - CN translation must faithfully reflect EN intent
4. Fix any flagged discrepancy
5. Report: ✓ verified / ⚠ fixed / ✗ flagged

### Sensitivity scan
After quote verification, scan article body (including blockquotes, excluding disclaimer) for sensitive terms:
`[china/ccp/tiananmen/taiwan/tibet/xinjiang/hong kong]` + `[censorship/surveillance/human rights/propaganda]`

| Hit found? | Action |
|------------|--------|
| Yes | Tag article `⚑ sensitive`. Continue to Phase 3 flagged path. |
| No | Normal path. |

---

## Phase 3 — Output

1. Save article to `_articles/`
2. Validate date field:
   - `grep "date: $(TZ=Asia/Shanghai date +%Y-%m-%d)"` article file
   - Match → continue
   - Mismatch → error "date field mismatch", auto-correct to today
3. Build:
   - **Auto/CI mode**: Skip build (CI validates in a separate step, no Docker).
   - **Interactive mode**: `make build` (Docker) — if fail, fix & rebuild (max 1 retry).

### Auto mode (--auto or CI)

| Tag | Action |
|-----|--------|
| Normal (no tag) | `git add -A && git commit -m "feat: HN 自动摘要 $(TZ=Asia/Shanghai date +%Y-%m-%d)"` (CI will push) |
| Flagged (`⚑` sensitive or `⚑` political context) | Add extended disclaimer line: "This article involves topics of public debate. Content presented for informational purposes only." → commit same as normal + show warning: "⚠ Sensitive article deployed. Review recommended." |

Exit 0 on success. No user prompts.

### Interactive mode (no --auto)

| Tag | Action |
|-----|--------|
| Normal (no tag) | Ask deploy? → yes → invoke auto-deploy skill |
| Flagged (`⚑` sensitive or `⚑` political context) | Show: "⚠ Sensitive topics detected. Extended disclaimer added. Review required." Show matched terms. Add extended disclaimer. Ask "Confirm deploy? [y/N]" (default NO). y → deploy with extended disclaimer. N → article stays local, not committed. |
