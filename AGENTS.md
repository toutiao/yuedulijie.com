# yuedulijie.com — 阅读理解

## Stack
- Jekyll + GitHub Pages (branch `master`, auto-deployed)
- Domain: `yuedulijie.com`
- **Local dev**: Docker (ruby:3.2-slim, `docker compose`), **no** local Ruby/Jekyll needed
- **CI**: `.github/workflows/deploy.yml` — push to master → build → Pages
- **Sub-site**: [UP-6 英语学习导航](https://up-6.yuedulijie.com) — `github.com/Lax/up-6.yuedulijie.com`

## Project Layout
```
_config.yml       # Site config, collections, permalinks, plugins
_includes/        # Reusable Liquid fragments (header, per-collection listing)
_layouts/         # Layouts: default, post, page, home, per-collection pages
_movies/ (14)     # Movie reviews
_books/ (0)       # Book reviews (empty)
_essays/ (0)      # Essays (empty)
_articles/ (13)   # HN discussion summary articles (populated Jun 2026)
_sass/            # SCSS source (empty — styles in assets/main.scss)
assets/           # main.scss (entry, has front matter), main.js, favicon
```
Nav pages (`movies.html`, `books.html`, `articles.html`) use `nav: true` in front matter. `archives.html` is hardcoded in header, not nav.

## Collections & Permalinks
| Collection | Path | Permalink | Notes |
|---|---|---|---|
| movies | `_movies/` | `/movies/:year/:name` | No default author |
| books | `_books/` | `/books/:year/:name` | No default author |
| essays | `_essays/` | `/essays/:name` | Default author: `深井兵太郎` |
| articles | `_articles/` | `/articles/:year/:name` | No default author |

## Front Matter Patterns
- **Movies**: minimal — usually only `title:` (no `layout`, `date`, `categories` in older posts)
- **Articles** (HN summaries): `layout: post`, `title:`, `date:`, `categories: [articles]`
- **Essays**: default author `深井兵太郎` from `_config.yml`
- **Nav pages**: `layout: <type>`, `title:`, `nav: true`

## File Naming
- `YYYY-MM-DD-title-with-hyphens.md`
- After 2024-03, **movies** add a dot before year: `YYYY-MM-DD-title.YEAR.md`
- **Articles** (HN summaries): `_articles/YYYY-MM-DD-hn-keywords.md`

## Commands
| Command | Action | Agent |
|---|---|---|
| `/test` | `make build` (Docker) — validate site compiles | jekyll-builder |
| `/deploy` | Build → stage → commit (Chinese msg) → push master | git-publisher |
| `/plan` | Analyze project, suggest next work | project-manager |
| `/content` | Audit collections and front matter | content-manager |
| `/evolve` | Self-review agent configs, skills, infrastructure | self-evolve |
| `/hn [url]` | Create HN discussion summary → `_articles/` | hn-summarizer |

## Dev Workflow
1. Edit content/config/layout
2. `make build` (or `docker compose run --rm build`) — validates in Docker
3. `make serve` (or `docker compose up jekyll`) — live at http://localhost:4000
4. Commit & push to master — GH Actions auto-deploys

Build env: `JEKYLL_ENV=production` (build), `development` (serve). Persisted gem volume: `bundle_data`.

## Commit Style
Conventional commits in Chinese: `feat:`, `fix:`, `style:`, `docs:`, `refactor:` prefixes. Always build first. `make deploy msg='...'` does build → `git add -A` → commit → push in one step.

## Dev Environment Rules (Hard)

**Never modify** git/SSh/GitHub CLI configuration when git operations fail. Report the error instead.

- `git config --global`, `git config --system`: **denied** — modifying global/user-level git settings is forbidden
- `git remote set-url`, `git remote add`, `git remote remove`: **denied** — the remote URL is pre-configured and coordinated with SSH/gh CLI
- `gh auth`: **denied** — GitHub CLI authentication is pre-configured
- `~/.ssh/config`: **do not edit** — SSH configuration is pre-configured
- `~/.gitconfig`: **do not edit** — global git config is pre-configured
- The local git, GitHub CLI, and SSH configs work together for normal `fetch`/`push`/`clone`. Do not assume they need fixing when a specific operation fails (e.g., timeout, auth error).

If a git operation fails with an auth or network error, report the error message to the user and stop. Do not try to "fix" the environment.

## Plugin
Only `jekyll-seo-tag`. HTML compression via `compress_html` in `_config.yml` (production only).
