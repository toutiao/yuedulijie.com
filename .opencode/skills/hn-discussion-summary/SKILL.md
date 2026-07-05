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

## Phase 1 — Research (输入 → Research Document)

### Cache strategy

Prefer cached data from `_data/hn/`. Fallback to `webfetch` only when cache unavailable.

Cache file locations (replace `YYYY`/`WNN`/`{id}` as needed):
| Data | Path | Key fields |
|------|------|-----------|
| Post metadata | `_data/hn/YYYY/WNN/{id}/post.yaml` | title, score, author, posted_at, raw_comment_count |
| Comments | `_data/hn/YYYY/WNN/{id}/comments.yaml` | comments[].{id, author, text, score} |
| Article | `_data/hn/YYYY/WNN/{id}/article.yaml` | title, fetch_status, content |

Use `glob _data/hn/*/W*/` to find the week dir, then read files for the selected story id.

### Step 1 — 确保原文内容充足

Read `article.yaml`. Check `content` field length:
- `< 2000 chars` → **MUST** run `ruby scripts/hn-fetch.rb --fetch-article-url "<article_url>" --timeout 30` to attempt fuller fetch
- `2000..4000 chars` → **SHOULD** run the same command
- `> 4000 chars` → **MAY** proceed directly

If the fetch succeeds (exit 0), use the stdout content as supplementary context.
If it fails (exit 1), proceed with existing cached content.

### Step 2 — 精读原文，提取具体细节

Read the article content. Extract concrete details worth referencing in 原文概要:

| 类别 | 提取什么 | 原因 |
|------|---------|------|
| 角色 | 人名 / 角色名 / 真实人物 | 让概要有故事感 |
| 数字 | 百分比 / 金额 / 时间 / 数量 | 具体数字比"很多"有力 |
| 产品功能 | 具体功能名称 / 特性 | 相比"各种功能","蜡烛按钮"更生动 |
| 荒诞点 | 反常识 / 讽刺 / 矛盾 | 读完后最容易被记住的点 |
| 关键情节 | 起因 → 转折 → 结局链条 | 概要需要一条叙事线 |

> 这一步产出一个 **Details 块**（~5-8 条，中英夹杂没关系，供自己参考）

### Step 3 — 分类评论，建立主题 + 引文池

Read `comments.yaml` (top 100 by score). Group into 4-8 themes:

```
Theme: [主题名称] （热度: 🔥高/💬中/📎低）
  立场: 支持 / 反对 / 中立 / 争议
  引文候选:
  - [comment:id] "quote" — username（赞成 or 反对）
  - [comment:id] "quote" — username
  关键观察: 这个主题的讨论有何独特性？
```

每条引文的 comment ID 必须记录（Phase 2.5 验证需要）。

### Step 4 — 判断讨论结构

识别讨论的整体格局：
- 是否存在明显争议（两派对立）？
- 是否大量读者有亲身经历（共鸣帖）？
- 是否存在幽默/讽刺/戏仿的副线？
- 讨论是共识居多还是分裂居多？

### Phase 1 产出

将 Step 2-4 汇总为一个 **Research Document**（保留在上下文，不落盘）。结构：

```
—— Research Document ——
【原文具体细节】  ← 来自 Step 2
- 角色: ...
- 数字: ...
- 荒诞点: ...
- 关键情节: ...

【主题分布】  ← 来自 Step 3
- Theme 1: ...（引文: comment:id, comment:id）
- Theme 2: ...

【讨论结构】  ← 来自 Step 4
- 争议焦点: ...
- 情绪基调: ...
—— RD END ——
```

进入 Phase 2 前确认 Research Document 完整，不缺失关键主题。

### Single post mode
同上 Step 2-4。

### Cluster mode
1. Main post: top 20 comments by score
2. Each related post: top 8 by score
3. Track `thread_id` per quote (e.g. "[thread 2]")
4. Research Document 标注每条引文的 thread 归属

---

## Phase 2 — Write

Load `chinese-writing-style` skill before writing.
(引文原文不受 style 约束, 保持原样. 翻译和讨论段受约束.)

写作前**重新完整通读一遍 Research Document**，确保所有关键细节和引文都在工作记忆中。

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

### 写作质量要求

写作时始终遵循以下三条：

1. **具体优先于抽象** — 用"面包 33% 烤焦率"代替"产品存在问题"；用"蜡烛按钮、壁炉模式、斋月模式"代替"各种新功能"。Research Document 的 Details 块就是干这个的。

2. **引文驱动讨论** — 每个讨论主题 section 至少展示一条引文（原文 + 翻译），引文是讨论焦点的核心载体。不要空泛归纳"很多读者认为"。

3. **有叙事弧线** — 原文概要从起因到结局有一条完整线。总体情绪从分歧走向一个有力的退场句，避免平淡收尾。

### Article structure (fixed order)
1. **原文概要** — context intro, 2-5 paragraphs. Note source: "HN 首页 (/news)" or "HN 热门榜 (/best)". 必须使用 Research Document 中的具体细节（人名、数字、产品功能），避免抽象概括。
2. **讨论焦点** — key themes in `###` sections. Each blockquote followed by CN translation:
   ```
   > "English text" — username
   > （中文翻译）
   ```
   - Translation line: no attribution
   - No blank line between quote and translation
   - Cluster mode: attribution → `[thread #N]`
3. **典型观点一览** — table: 立场 / 用户 / 一句话
4. **总体情绪** — 1-2 paragraphs, end with a strong closing line
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

## Phase 2.5 — Fact Check + Revision (REQUIRED, no skip)

### Step 1 — 引文验证

1. `webfetch` HN comment page (html) — `https://news.ycombinator.com/item?id={comment_id}`
2. Locate comment: `<span class="commtext c00">`
3. Compare rendered text vs article quote:
   - Verbatim match (no paraphrase, no added detail)
   - Username attribution must match
   - Ellipsis (...) must not change original meaning
   - CN translation must faithfully reflect EN intent
4. Fix any flagged discrepancy
5. Report: ✓ verified / ⚠ fixed / ✗ flagged

### Step 2 — 质量自审

通读全文，Checklist:

| # | 检查项 | 通过条件 |
|---|--------|---------|
| 1 | 原文概要是否有具体细节？ | 包含至少 3 个 Research Document 中的具体项（人名/数字/功能名） |
| 2 | 讨论焦点是否引文充分？ | 每个主题 section 至少 1 条引文 |
| 3 | 整体语言是否具体而非空泛？ | 无"很多人表示"类批发表述，每句都锚定具体信息 |
| 4 | 观点表是否覆盖主要争议？ | 至少 4 行，包含正反立场 |
| 5 | 总体情绪是否有有力的退场句？ | 最后一句不只重复前文，而是收束或点睛 |

有未通过的项 → 修改对应段落 → 重新检查。

### Sensitivity scan

After revision, scan article body (including blockquotes, excluding disclaimer) for sensitive terms:
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
