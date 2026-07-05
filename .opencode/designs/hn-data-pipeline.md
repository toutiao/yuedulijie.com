# HN Data Pipeline — 数据源优化设计

> 创作流程大提升计划 第1阶段
> 状态: 已实施完成 | 日期: 2026-07-01 | 以下为实际实现记录，后续改以此文档为起点

## 目标

将 Hacker News 数据抓取与 AI 创作解耦，引入缓存层，降低重复网络请求，提高创作数据质量。

## 第一性原理

| 假设 | 违背场景 | 捕捉层 | 未捕捉后果 |
|---|---|---|---|
| 原始 HN 数据可缓存复用 | CI 重跑/失败重试时重新抓取同一讨论 | 本地缓存命中跳过 fetch | 浪费 HN 请求 |
| 按周组织可生成可预测 cache key | 跨年、闰周、假期 | Ruby `Date#cweek` + `date -u +%V` ISO 8601 | cache miss |
| 目标文章正文提升 AI 生成质量 | Gemini 只能从评论推断原文 | readability + reverse_markdown 提取 | 原文概要失真 |
| Git commit 排除缓存数据 | 缓存数据混入 main 分支 | `.gitignore` + CI 只提交 `_articles/` | repo 膨胀 |
| 双 cache entry 避免无限增长 | 单 entry 包含全量数据 | 周隔离 cache key | 缓存累积、命中降低 |
| post.yaml 兼容 url 为空/抓取失败 | Ask HN 帖子无外链；目标站 5xx | `url: null` + `article_fetch_status` 枚举 | NPE / 脚本崩溃 |

## 目录结构

```
_data/hn/                          # gitignored
└── 2026/
    ├── W09/                        # ISO 周
    │   ├── stories.yaml            # 帖子索引（~30条）
    │   ├── 44123456/
    │   │   ├── post.yaml
    │   │   ├── comments.yaml
    │   │   └── article.yaml
    │   └── 44123457/
    └── W10/
        └── ...
```

## 数据模型

### post.yaml

```yaml
id: "44123456"                     # HN 帖子 ID
title: "Show HN: Example"          # 标题（必有）
url: "https://example.com"         # 帖子链接 URL（可为 null）
hn_url: "https://news.ycombinator.com/item?id=44123456"
score: 120
author: "username"
posted_at: "2026-07-01T12:00:00Z"  # HN 原始发布时间
fetched_at: "2026-07-01T14:00:00Z" # 最后一次抓取时间
article_url: "https://..."         # 目标文章 URL（可为 null）
article_fetch_status: "success"    # skipped | success | blocked | not_found | error
```

#### HN 帖子类型与 url 行为

| 类型 | 标题链接到 | `post.url` | `article_url` | `article_fetch_status` |
|---|---|---|---|---|
| 常规链接帖 | 外部 URL | 外部 URL | 外部 URL | `success` / `blocked` / `error` |
| Ask HN | HN discussion | **null** | **null** | **skipped** |
| Show HN (链接帖) | 外部 project URL | 外部 URL | 外部 URL | `success` / `blocked` / `error` |
| Show HN (自述帖) | HN discussion | **null** | **null** | **skipped** |
| Tell HN | HN discussion | **null** | **null** | **skipped** |
| Poll | HN discussion | **null** | **null** | **skipped** |
| Jobs | 外部招聘 URL | 外部 URL | 外部 URL | `success` / `blocked` / `error` |

**null 策略：** `url` / `article_url` 为 `null` 时 `extract_article` / `extract_article_simple` 直接返回 `fetch_status: "skipped"`，不发起 HTTP 请求。脚本不崩溃。`fetch_stories` (Algolia API) 直接返回 `url` 字段，无外链帖为 null。

**post.yaml 实际示例：**

Ask HN（自述帖）：
```yaml
id: "44123456"
title: "Ask HN: What's your tech stack?"
url: null
hn_url: "https://news.ycombinator.com/item?id=44123456"
article_url: null
article_fetch_status: null
```

Show HN（链接帖）：
```yaml
id: "44123457"
title: "Show HN: My open-source tool"
url: "https://github.com/user/repo"
hn_url: "https://news.ycombinator.com/item?id=44123457"
article_url: "https://github.com/user/repo"
article_fetch_status: "success"
```

### comments.yaml

```yaml
comments:
  - id: "44123457"
    parent_id: "44123456"
    author: "commenter1"
    text: "原始评论文本..."
    score: 15
    posted_at: "2026-07-01T12:05:00Z"
```

### article.yaml

```yaml
url: "https://example.com/article"  # 可为 null
title: "Example Article"            # 可为 null
fetch_status: "success"             # skipped | success | blocked | not_found | error
fetched_at: "2026-07-01T14:00:00Z"
content: "Markdown 提取正文..."     # 可为 null
error: null                         # fetch_status=error 时有值
```

### stories.yaml（帖子索引）

```yaml
fetched_at: "2026-07-01T14:00:00Z"
stories:
  - id: "44123456"
    title: "..."
    url: "https://..."  # 可为 null
    hn_url: "https://news.ycombinator.com/item?id=44123456"
    score: 345
    author: "alice"
  # ... 全部 ~30 条
```

## 文章正文提取策略

双模式设计：

### 模式 A: Simple HTTP（`--fetch-articles-simple`，默认）

纯 Ruby `Net::HTTP`，不需要任何外部服务。适用于 ubuntu-latest CI 和本地开发。

```
HTTP GET (浏览器 UA, 10s open / 20s read timeout)
  → 质量门禁 6 道 (HTTP 200 / Content-Type / JS阻断 / 软404 / 最小200字 / 可打印字符>=80%)
  → nokogiri 语义标签提取 (<article>/<main>/[role="main"])，去导航/广告
  → reverse_markdown gem (HTML → Markdown)
  → YAML content 字段
```

**质量门禁失败时**：保留 renderer 缓存的 `article.yaml`（如果有）。

### 模式 B: Playwright Renderer（`extract_article`，默认旧模式）

需要 `playwright-renderer` Docker 容器 (`localhost:3000`)。仅 self-hosted runner 可能具备。

```
RENDERER_URL → JS 渲染 → nokogiri 提取 → reverse_markdown
```

**依赖：**
- `nokogiri`（内置）
- `reverse_markdown` gem
- `playwright-renderer` 容器（仅 renderer 模式需要）

**fallback 链（simple 模式）：**
1. Simple HTTP 成功 + 6 道门禁通过 → 优质内容 ✅
2. Simple HTTP 失败 → preserve renderer 缓存（如有）
3. 无 renderer 缓存 → `fetch_status: "error"` → skill 中 webfetch 兜底

## Cache 策略

### 架构

```
Entry 1: 当前周 (刷新，保存)
  key:  hn-data-2026-W10-<run_id>
  path: _data/hn/2026/W10/

Entry 2: 上周 (只恢复，不保存)
  key:  hn-data-2026-W09-<run_id>
  path: _data/hn/2026/W09/
```

### CI 步骤

1. 计算 week key:
   - `CUR_PATH` = `date -u +%G/W%V`（目录路径 `2026/W15`）
   - `CUR_KEY` = `date -u +%G-W%V`（cache key 标识 `2026-W15`）
   - `PREV_PATH` = `date -u -d '7 days ago' +%G/W%V`
   - `PREV_KEY` = `date -u -d '7 days ago' +%G-W%V`
2. Restore 当前周 cache entry → `_data/hn/<CUR_PATH>/`
3. Restore 上周 cache entry → `_data/hn/<PREV_PATH>/`
4. `hn-fetch.rb --best` → 仅写入当前周目录
5. `opencode /hn --auto` (hn-discussion-summary skill) → 读缓存生成文章
6. Save 当前周 cache entry → key = `hn-data-<CUR_KEY>-<run_id>`

### 淘汰模型

```
W10 Mon: restore W10 + W09 → save W10 (W09-202600701 最后活动日)
W11 Mon: restore W11 + W10 → save W11 (W09 不再 restore → 7天后淘汰)
```

### 待观察

> NOTE: 上周 cache entry 不显式 save，依赖 GitHub 7天无活动淘汰。如果实测发现
> 上周 entry 提前过期（<7天），原因是 restore 不计为 activity。解决：给上周也
> 加 cache/save（相同 key 覆盖，刷新活动时间戳）。当前标注「只读」是预期行为，
> 先不加 save。

## hn-fetch.rb 设计

### CLI

```
ruby scripts/hn-fetch.rb --best [--max N] [--force] [--jobs N]
                          [--fetch-articles-simple] [--skip-articles] [--timeout N]
ruby scripts/hn-fetch.rb --url <hn_url> [--force] [--fetch-articles-simple] [--skip-articles]
ruby scripts/hn-fetch.rb --fetch-article-url <url> [--timeout N]  # AI 补充用
ruby scripts/hn-fetch.rb --fill-missing [--jobs N]   # renderer 补充抓取
ruby scripts/hn-fetch.rb --output <dir>  # 默认 _data/hn
```

### 逻辑

1. 计算目标周目录 `_data/hn/<CUR_PATH>/`
2. `--best`: 抓 HN `/best` → 解析 30 stories → 写 `stories.yaml` → 对 score >= `SCORE_THRESHOLD` 的帖子完整抓取
3. `--url`: 抓单篇 → 写 `post.yaml` + `comments.yaml` + `article.yaml`
4. 缓存命中检查：`post.yaml` 存在且 `raw_comment_count` 未变 → 跳过
5. `--force` 忽略缓存，强制重新抓取
6. 文章提取分两模式：`:simple` (纯HTTP, 含质量门禁) 和 `:renderer` (Playwright, 需renderer服务)
7. `--fill-missing`: 扫描缓存，只处理 `fetch_status` 非 `success`/`skipped` 的文章。renderer 对 thin content（<2000 chars）无改善效果（实测27篇仅+595 chars），不处理成功状态

### stdout 输出

```
✓ 44123456 "Show HN: Example" (120 pts) — 2 fetched, 34 from cache, article extracted
✓ 44123457 "Other Post" (95 pts) — cache hit
Summary: 2 new posts fetched, 1 article extracted, 95% cache hit
```

## hn-auto.rb → opencode skill 改造

> `hn-auto.rb` 最终未独立实现。替代方案：`hn-discussion-summary` opencode skill（`opencode/skills/hn-discussion-summary/SKILL.md`），通过 `/hn` 命令触发。

### 缓存读取逻辑（在 skill 中实现）

Skill Phase 1 直接从 `_data/hn/` 读取缓存：
1. `glob _data/hn/*/W*/stories.yaml` → 选取最新周
2. `glob _data/hn/*/W*/{id}/post.yaml` → 帖子元数据
3. `glob _data/hn/*/W*/{id}/comments.yaml` → 评论数据
4. `glob _data/hn/*/W*/{id}/article.yaml` → 文章正文（`fetch_status == 'success'` 时使用）

### 给 AI 的 article_text

Skill Phase 2 增加文章内容充分性检查（见 SKILL.md）：
- `< 2000 chars` → MUST 运行 `--fetch-article-url` 补充
- `2000..4000` → SHOULD
- `> 4000` → MAY 跳过

## CI YAML（实际实现）

两个独立 workflow：

### `hn-fetch.yml` — 自托管 runner，每日 3 次数据缓存

### `hn-fetch.yml` — 双 job：fetch (ubuntu) + fill (self-hosted, renderer)

```yaml
name: HN Data Fetcher + Article Filler
on:
  schedule:
    - cron: "0 0,8,16 * * *"
  workflow_dispatch:

jobs:
  fetch:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v7
      - uses: ruby/setup-ruby@v1
        with: { ruby-version: "3.2", bundler-cache: true }
      - uses: ./.github/actions/hn-cache/restore
      - name: Fetch HN data (simple HTTP)
        run: bundle exec ruby scripts/hn-fetch.rb --best --max 15 --fetch-articles-simple --jobs 5
      - uses: ./.github/actions/hn-cache/save

  fill:
    needs: fetch
    runs-on: self-hosted
    steps:
      - uses: actions/checkout@v7
      - name: Install Ruby deps
        run: gem install nokogiri reverse_markdown 2>&1 | tail -3
      - uses: ./.github/actions/hn-cache/restore
      - name: Fill missing articles (renderer)
        run: |
          if ! curl -sf http://localhost:3000/health >/dev/null 2>&1; then
            docker compose build renderer 2>&1 | tail -1
            docker compose up -d renderer 2>&1
            for i in $(seq 1 10); do
              curl -sf http://localhost:3000/health >/dev/null && break
              sleep 2
            done
          fi
          if curl -sf http://localhost:3000/health >/dev/null 2>&1; then
            ruby scripts/hn-fetch.rb --fill-missing --jobs 3
          else
            echo "Renderer unavailable. Skipping fill."
          fi
      - uses: ./.github/actions/hn-cache/save
```

Cache key 使用 `github.job` 自动后缀（`hn-data-{YR}{WK}-{run_id}-fetch` / `hn-data-{YR}{WK}-{run_id}-fill`），通过 `restore-keys` 前缀匹配保证 hn-auto.yml 恢复最新数据。

### `hn-auto.yml` — GitHub ubuntu-latest，每日 02:00 UTC 生成

```yaml
name: HN Auto-Summarizer
on:
  schedule:
    - cron: "0 2 * * *"
  workflow_dispatch:
    inputs:
      model:
        description: "AI 模型"
        type: choice
        required: false
        default: "deepseek/deepseek-v4-flash"
        options:
          - "google/gemini-2.5-flash"
          - "google/gemini-2.5-flash-lite"
          - "google/gemini-3.1-flash-lite"
          - "google/gemini-3.5-flash"
          - "deepseek/deepseek-v4-flash"
      mode:
        description: "运行模式 — auto 自动选择 / url 手动指定"
        type: choice
        required: false
        default: "auto"
        options:
          - "auto"
          - "url"
      hn_url:
        description: "HN 讨论 URL（mode=url 时必填）"
        required: false
        default: ""
      force_fetch:
        description: "强制重新抓取，忽略缓存"
        type: boolean
        required: false
        default: false
permissions:
  contents: write
jobs:
  generate:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v7
        with: { fetch-depth: 0, persist-credentials: false }
      - uses: ruby/setup-ruby@v1
        with: { ruby-version: "3.2", bundler-cache: true }
      - name: Configure Git
        env: { PAT: "\${{ secrets.PAT_FOR_DEPLOY }}" }
        run: |
          git config user.name "HN Auto-Summarizer"
          git config user.email "hn-auto@yuedulijie.com"
          git remote set-url origin "https://github.com/\${{ github.repository }}"
      - uses: ./.github/actions/setup-opencode
      - uses: ./.github/actions/hn-cache/restore
      - name: Fresh fetch discussions + articles (simple HTTP)
        run: bundle exec ruby scripts/hn-fetch.rb --best --max 15 --fetch-articles-simple --jobs 5 --timeout 20
      - name: Generate articles (opencode auto)
        env:
          GOOGLE_GENERATIVE_AI_API_KEY: "\${{ secrets.GEMINI_API_KEY }}"
          DEEPSEEK_API_KEY: "\${{ secrets.DEEPSEEK_API_KEY }}"
        run: opencode run "/hn --auto \$FLAGS" --dir . --dangerously-skip-permissions ...
      - name: Validate Jekyll build
        run: bundle exec jekyll build
      - name: Push to master
        run: git push
```

> 注意：`hn-cache/restore` 和 `hn-cache/save` 是 `.github/actions/` 中的 composite action，封装了 `actions/cache@v4` 的周级 key 计算。

## Makefile

```makefile
fetch:
	docker compose run --rm build ruby scripts/hn-fetch.rb --url "$(url)" --fetch-articles-simple

fetch-best:
	docker compose run --rm build ruby scripts/hn-fetch.rb --best --fetch-articles-simple --jobs 5
```

## 实施顺序

1. ✅ 基础设施 — 目录、gitignore、Gemfile
2. ✅ `hn-fetch.rb` — 核心数据抓取脚本（v1: Firebase → Algolia + 线程池 + simple HTTP + 质量门禁）
3. ✅ `hn-discussion-summary` skill — 替代 `hn-auto.rb`，通过 opencode `/hn` 命令触发
4. ✅ CI YAML — 双 cache entry + 分步（`hn-cache` action + `hn-fetch.yml` + `hn-auto.yml`）
5. ✅ Makefile — fetch/fetch-best 目标
6. ✅ 本地验证 — `make build` + 抓取测试
7. ✅ 对抗式审查 — 见 AGENTS.md Adversarial Review Gate
