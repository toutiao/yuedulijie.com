# HN Data Pipeline — 数据源优化设计

> 创作流程大提升计划 第1阶段
> 状态: 实施中 | 日期: 2026-07-01

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
article_fetch_status: "success"    # skipped | success | blocked | error
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

**null 策略：** `url` / `article_url` 为 `null` 时 `extract_article` 直接返回 `fetch_status: "skipped"`，不发起 HTTP 请求。脚本不崩溃。`parse_best_page` 中 `/\Ahttps?:\/\//` 正则匹配区分外部链接与自述帖。

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

参考 opencode webfetch 工具设计（HTTP → HTML → Markdown），增加 Readability 层过滤：

```
HTTP GET (浏览器 UA, 5MB limit, 30s timeout)
  → readability gem (Mozilla Readability — 提取主内容，去导航/广告)
  → reverse_markdown gem (HTML → Markdown, 类 Turndown)
  → YAML content 字段
```

**依赖：**
- `readability` gem (Mozilla Readability ruby port)
- `reverse_markdown` gem (HTML → Markdown)

**fallback 链：**
1. `readability` 提取成功 → Markdown 正文
2. `readability` 无结果 → 全页 HTML → `reverse_markdown` 转 Markdown
3. HTTP 失败 / 404 — `fetch_status: "error"`，`content: null`

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
5. `hn-auto.rb` → 读缓存生成文章
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
ruby scripts/hn-fetch.rb --best [--max N] [--force]
ruby scripts/hn-fetch.rb --url <hn_url> [--force]
ruby scripts/hn-fetch.rb --output <dir>  # 默认 _data/hn
```

### 逻辑

1. 计算目标周目录 `_data/hn/<WEEK_KEY>/`
2. `--best`: 抓 HN `/best` → 解析 30 stories → 写 `stories.yaml` → 对 score >= `SCORE_THRESHOLD` 的帖子完整抓取
3. `--url`: 抓单篇 → 写 `post.yaml` + `comments.yaml` + `article.yaml`
4. 缓存命中检查：`post.yaml` 存在且 `fetched_at` < 1h → 跳过
5. `--force` 忽略缓存，强制重新抓取

### stdout 输出

```
✓ 44123456 "Show HN: Example" (120 pts) — 2 fetched, 34 from cache, article extracted
✓ 44123457 "Other Post" (95 pts) — cache hit
Summary: 2 new posts fetched, 1 article extracted, 95% cache hit
```

## hn-auto.rb 改造

### 新增标志

```
ruby scripts/hn-auto.rb --from-cache   # CI 模式：只读缓存，不抓取
ruby scripts/hn-auto.rb <hn_url>       # 本地模式：优先缓存，回落抓取
```

### 缓存读取逻辑

```ruby
def load_discussion_from_cache(post_id)
  # 搜索 _data/hn/*/<post_id>/ 所有周目录
  # 命中: 读取 YAML → 重建 discuss 字符串格式
  # 未命中: 返回 nil
end

def process_story(story, date:)
  cached = load_discussion_from_cache(story[:id])
  if cached
    discussion, title = cached
  else
    # 回落实时抓取
    discussion, title = extract_discussion(story[:hn_url])
  end

  article_text = load_article_from_cache(story[:id])

  # ... Gemini 调用，传 article_text
end
```

### 给 AI 的 article_text

Gemini prompt 新增段：
```
## 原文参考
以下为该 HN 帖子的目标文章内容。撰写"原文概要"时优先参考：
---原文---
{article_content}
---原文---
```

## CI YAML

```yaml
name: HN Auto-Summarizer
on:
  schedule: [{ cron: "0 2 * * *" }]
  workflow_dispatch:

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

      - name: Configure Git ...

      - name: Set week keys
        run: |
          echo "CUR_PATH=$(date -u +%G/W%V)" >> $GITHUB_ENV
          echo "CUR_KEY=$(date -u +%G-W%V)" >> $GITHUB_ENV
          echo "PREV_PATH=$(date -u -d '7 days ago' +%G/W%V)" >> $GITHUB_ENV
          echo "PREV_KEY=$(date -u -d '7 days ago' +%G-W%V)" >> $GITHUB_ENV

      - name: Restore current week cache
        uses: actions/cache/restore@v4
        with:
          path: _data/hn/${{ env.CUR_PATH }}
          key: hn-data-${{ env.CUR_KEY }}-${{ github.run_id }}
          restore-keys: hn-data-${{ env.CUR_KEY }}-

      - name: Restore previous week cache
        uses: actions/cache/restore@v4
        with:
          path: _data/hn/${{ env.PREV_PATH }}
          key: hn-data-${{ env.PREV_KEY }}-${{ github.run_id }}
          restore-keys: hn-data-${{ env.PREV_KEY }}-

      - name: Fetch HN data
        run: bundle exec ruby scripts/hn-fetch.rb --best

      - name: Generate articles
        run: bundle exec ruby scripts/hn-auto.rb --from-cache

      - name: Build Jekyll
        id: jekyll_build
        run: bundle exec jekyll build
        continue-on-error: true

      - name: Revert on build failure
        if: steps.jekyll_build.outcome == 'failure'
        run: |
          git checkout -- _articles/
          exit 1

      - name: Commit and push articles
        if: steps.jekyll_build.outcome == 'success'
        run: |
          git add -A _articles/
          if [ -n "$(git status --porcelain _articles/)" ]; then
            git commit -m "feat: HN 自动摘要 $(date -u +%Y-%m-%d)"
            git push origin HEAD || (git pull --rebase && git push)
          fi

      - name: Save current week cache
        uses: actions/cache/save@v4
        with:
          path: _data/hn/${{ env.CUR_PATH }}
          key: hn-data-${{ env.CUR_KEY }}-${{ github.run_id }}
          key: hn-data-${{ env.WEEK_KEY }}-${{ github.run_id }}
```

## Makefile

```makefile
fetch:
	docker compose run --rm build ruby scripts/hn-fetch.rb --url "$(url)"

fetch-best:
	docker compose run --rm build ruby scripts/hn-fetch.rb --best
```

## 实施顺序

1. 基础设施 — 目录、gitignore、Gemfile
2. `hn-fetch.rb` — 核心数据抓取脚本
3. `hn-auto.rb` — 缓存读取改造
4. CI YAML — 双 cache entry + 分步
5. Makefile — fetch/fetch-best 目标
6. 本地验证 — `make build` + 抓取测试
7. 对抗式审查
