---
name: hn-discussion-summary
description: Create Chinese HN discussion summary article for yuedulijie.com
metadata:
  domain: content
  collection: articles
---

## Mode

| Condition | Mode |
|-----------|------|
| `--auto` / `CI=true` / `GITHUB_ACTIONS=true` | **auto** — no prompts, auto-decide, auto-build, auto-deploy |
| else | **interactive** — user prompts, confirm deploy |

---

## Phase 0 — Scan

### Filters (all modes)
Story pass all:
- score >= 80
- ID not in `_articles/*.md`
- same topic not covered today (grep date + keyword in existing articles)

> `hn-fetch.rb` already dedup at write time (filter IDs in `_articles/`). This is 2nd layer.

### Auto mode
1. Read `_data/hn/*/W*/stories.yaml` → pick newest week
2. Apply filters
3. Sort by score desc
4. Pick top candidate
5. Report: `Auto-selected: [title] ([score] pts)`
6. Go to Phase 0.5
7. Fallback: `webfetch https://news.ycombinator.com/best?h=48`

### Interactive mode
1. `webfetch https://news.ycombinator.com/best?h=48` (text)
2. Parse id + title + score
3. Apply filters
4. Political match → tag `⚑ political context`
5. Show top 5:

   ```
   HN hot candidates:
   [1] Title (N pts)
   ...
   Input: number / URL / "n" to skip
   ```

---

## Phase 0.5 — Cluster

### Keyword
Drop leading common words (Claude, new, update, Introducing) → first meaningful token.

### Auto
1. Scan candidates for same keyword, score >= 80, not self
2. >= 2 related → **cluster mode** (include all)
3. < 2 → **single post mode**
4. Report: `Mode: [cluster/single], N posts`

### Interactive
1. `webfetch` HN source (html):
   - `/best` → `https://news.ycombinator.com/best?h=48`
   - `/news` → start `/news`, follow "morelink" till score < 80 or age > 48h
2. Parse `<tr class="athing">`: id + title + score
3. Filter by keyword, score >= 80, not self
4. >= 2 → show:

   ```
   Detected cluster — {N} related posts:
     [1] {title} ({score} pts) — MAIN
     ...
   Include all? [y] / select numbers [1,3,5] / [n] skip
   ```
5. else → single mode
6. User input sets cluster scope

---

## Phase 1 — Research (raw data → RD)

### Cache
Prefer `_data/hn/`. Fallback `webfetch` only.

| Data | Path | Key fields |
|------|------|-----------|
| Post meta | `_data/hn/YYYY/WNN/{id}/post.yaml` | title, score, author, posted_at, raw_comment_count |
| Comments | `_data/hn/YYYY/WNN/{id}/comments.yaml` | comments[].{id, author, text, score} |
| Article | `_data/hn/YYYY/WNN/{id}/article.yaml` | title, fetch_status, content |

Find week: `glob _data/hn/*/W*/`.

### Step 1 — Article sufficiency
Read `article.yaml`. Check `content` length:
- `< 2000` → **MUST** run `bundle exec ruby scripts/hn-fetch.rb --fetch-article-url "<url>" --timeout 30`
- `2000..4000` → **SHOULD** run
- `> 4000` → **MAY** proceed

exit 0 → use stdout content. exit 1 → use cached.

### Step 2 — Extract concrete details
Read article. Extract specifics for 原文概要:

| Type | Extract | Why |
|------|---------|-----|
| 角色 | person name / role | story feel |
| 数字 | %, $, time, count | precise > vague |
| 产品功能 | feature name | "蜡烛按钮" >> "各种功能" |
| 荒诞点 | absurd / irony / paradox | most memorable |
| 情节 | cause → twist → outcome | narrative line |

> Output: **Details block** (~5-8 items, EN/CN mix ok)

### Step 3 — Theme + quote pool
Read `comments.yaml` (top 100 by score). Group 4-8 themes:

```
Theme: [name] (热度: 🔥/💬/📎)
  立场: for / against / neutral / split
  candidates:
  - [comment:id] "quote" — user
  观察: what's unique about this theme?
```

Record comment ID for each quote (Phase 2.5 verify).

### Step 4 — Discussion structure
Identify:
- Clear opposition (two camps)?
- Personal experience (共鸣)?
- Humor / parody side-thread?
- Consensus or split?

### Phase 1 output

Merge Step 2-4 into **Research Document** (context only, no disk):

```
—— Research Document ——
【原文具体细节】
- 角色: ...
- 数字: ...
- 荒诞点: ...
- 情节: ...

【主题分布】
- Theme 1: ... (引文: comment:id)
- Theme 2: ...

【讨论结构】
- 争议: ...
- 情绪: ...
—— RD END ——
```

Verify RD complete before Phase 2. No missing key themes.

### Single mode
Same Step 2-4.

### Cluster mode
1. Main: top 20 comments by score
2. Related: top 8 each
3. Track `thread_id` per quote (e.g. `[thread 2]`)
4. RD label each quote with thread

---

## Phase 2 — Write

Load `chinese-writing-style` first.
(引文原文不受 style 约束. 翻译和讨论段受约束.)

> caveman mode applies to AI communication only. Article body stays normal expressive CN.

**Re-read full RD** before writing. Ensure all details + quotes in working memory.

### Front matter

```
---
layout: post
title: "Topic — HN discussion digest"
date: $(TZ=Asia/Shanghai date +%Y-%m-%d)
categories: [articles]
excerpt: >-
  1-2句, ~80字
tagline: >-
  浮夸版（不展示, 搜索引擎可见）
---
```
⚠ `excerpt` / `tagline` use YAML block scalar `>-`. ASCII `"` terminates YAML. Use 《》 or `\"`.

⚠ `date` via `$(TZ=Asia/Shanghai date +%Y-%m-%d)`. Never manual.

### excerpt rules
| Length | Style | Example |
|--------|-------|---------|
| < 3k chars | Core insight | "每天 5 分钟深呼吸就能改变你做风险决策的方式。" |
| >= 3k chars | Hook, counterintuitive | "0.2B 模型击败 10B 级模型。" |

No clickbait: 震惊, 惊人, 万万没想到.

### tagline rules
| Tone | Example |
|------|---------|
| 吐槽 | curl 维护者：黑客不休息？那我先休了。 |
| FOMO | Anthropic 的护城河正在蒸发。 |
| 金句 | 救火的被奖励，防火的被遗忘。 |
| 直击 | 你只是想写个代码，Anthropic 却要你的护照照片。 |
| 感性 | 全片台词不到十句，看完想给所有人打个电话。 |
| 反讽 | 花最贵的钱，用最不确定的服务。 |
| 脑洞 | 抓精灵时，Niantic 在帮你参军。 |
| 悬念 | 中国电影史上最短的剧本：沿着城墙走，走不完的路。 |

Must anchor to facts. Never fabricate. Not displayed — indexed via `<a title="...">`.

### Quality rules

1. **Concrete > abstract** — "面包 33% 烤焦率" not "产品有问题". Use RD Details block.
2. **Quote-driven** — each theme section >= 1 quote (EN + CN). No "很多读者认为".
3. **Narrative arc** — 原文概要: cause → twist → outcome. 总体情绪: divergence → strong closing line.

### Article structure (fixed order)
1. **原文概要** — 2-5 paragraphs. Source: "HN 首页 (/news)" or "HN 热门榜 (/best)". Use RD specifics (names, numbers, features).
2. **讨论焦点** — `###` sections. Each:
   ```
   > "text" — user
   > （译文）
   ```
   - Translation no attribution
   - No blank between quote and translation
   - Cluster: `[thread #N]`
3. **典型观点一览** — table: 立场 / 用户 / 一句话
4. **总体情绪** — 1-2 paragraphs. End with strong closing line.
5. **引用帖子** — table: # / 标题 / URL
6. **免责声明** — `<div class="disclaimer">`

### Format rules

| Rule | Example |
|------|---------|
| Quote + user same line | `> "text" — user` |
| CN trans separate line | `> （译文）` |
| Tech terms `` ` `` | `` `R1` ``, `` `BPEL` `` |
| Product names plain | LangChain, OpenAI, Claude |
| General plain | agent, framework, API |
| Cluster thread | `> "text" — user [thread 2]` |

### Naming
`_articles/YYYY/YYYY-MM-DD-hn-keywords.md`

### AI model disclosure
Append to disclaimer:
```
<br><br><em>本摘要由 AI 模型辅助生成：{provider}/{model}</em>
```
Use actual model (e.g. `google/gemini-2.5-flash`, `deepseek/deepseek-v4-flash`). Never fabricate.

---

## Phase 2.5 — Fact Check + Revise (REQUIRED)

### Step 1 — Quote verify
1. `webfetch` HN comment page (html) — `https://news.ycombinator.com/item?id={comment_id}`
2. Find: `<span class="commtext c00">`
3. Check:
   - Verbatim match (no paraphrase)
   - Username match
   - Ellipsis (...) preserved meaning
   - CN translation faithful
4. Fix mismatch
5. Report: ✓ / ⚠ / ✗

### Step 2 — Quality review
Read full draft. Checklist:

| # | Check | Pass |
|---|-------|------|
| 1 | 原文概要 specific? | >= 3 RD items (names/numbers/features) |
| 2 | 讨论焦点 quotes? | Each theme section >= 1 quote |
| 3 | Concrete not vague? | No "很多人表示". Each sentence anchored. |
| 4 | 观点表 covers split? | >= 4 rows, includes opposing views |
| 5 | 总体情绪 closing? | Last line not repeat. Synthesize or punch. |

Fail any → revise section → re-check.

### Sensitivity scan

Scan body (exclude disclaimer) for:
`[china/ccp/tiananmen/taiwan/tibet/xinjiang/hong kong]` + `[censorship/surveillance/human rights/propaganda]`

| Hit | Action |
|-----|--------|
| Yes | Tag `⚑ sensitive`. Go to Phase 3 flagged path. |
| No | Normal path. |

---

## Phase 3 — Output

1. Save article to `_articles/`
2. Validate date:
   - `grep "date: $(TZ=Asia/Shanghai date +%Y-%m-%d)"` article file
   - Match → continue
   - Mismatch → correct to today
3. Build:
   - **Auto/CI**: Skip (CI validates later).
   - **Interactive**: `make build` — fail → fix → rebuild (max 1 retry).

### Auto mode

| Tag | Action |
|-----|--------|
| Normal | `git add -A && git commit -m "feat: HN 自动摘要 $(TZ=Asia/Shanghai date +%Y-%m-%d)"` (CI pushes) |
| ⚑ sensitive/political | Add extended disclaimer → commit same + warning: "⚠ Review recommended." |

Exit 0. No prompts.

### Interactive mode

| Tag | Action |
|-----|--------|
| Normal | Ask deploy? yes → invoke auto-deploy skill |
| ⚑ sensitive/political | Show matched terms. Add extended disclaimer. Ask "Confirm deploy? [y/N]" (default N). y → deploy. N → stay local. |
