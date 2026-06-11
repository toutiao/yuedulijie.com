# yuedulijie.com — 阅读理解

## Stack
- Jekyll static site, GitHub Pages deployment
- Domain: https://yuedulijie.com
- Branch: `master` (deployed directly to Pages)
- Ruby gem: `github-pages`
- **Local dev**: Docker (ruby:3.2-slim), no local Ruby needed
- **CI/CD**: GitHub Actions (`.github/workflows/deploy.yml`), auto-deploys on push to master
- **Sub-site**: [UP-6 英语学习导航](https://up-6.yuedulijie.com) — `github.com/Lax/up-6.yuedulijie.com`

## Project Layout
```
_config.yml      # Site config (title, collections, plugins)
CNAME            # Custom domain: yuedulijie.com
_includes/       # Reusable HTML fragments
_layouts/        # Page/post layouts (Liquid)
_movies/         # Movie review collection (14 posts)
_books/          # Book review collection (empty)
_essays/         # Essay collection (empty)
_articles/       # Article reading notes collection (empty)
_sass/           # SCSS partials
assets/          # CSS (SCSS), JS, favicon
index.html       # Home page
archives.html    # Archive page
books.html       # Books listing
movies.html      # Movies listing
articles.html   # Articles listing
Gemfile          # Ruby dependencies
Gemfile.lock     # Gem dependency lock (committed for reproducible builds)
.github/         # CI/CD workflows
```

## Collections
| Collection | Path        | Permalink                  | Author (default) |
|------------|-------------|----------------------------|------------------|
| movies     | `_movies/`  | /movies/:year/:name        | —                |
| books      | `_books/`   | /books/:year/:name         | —                |
| essays     | `_essays/`  | /essays/:name              | 深井兵太郎       |
| articles   | `_articles/`| /articles/:year/:name      | —                |

## File Naming Convention
```
YYYY-MM-DD-title-with-hyphens.md
After 2024-03, movies use dots before year: YYYY-MM-DD-title.YEAR.md
```

## Agents
| Agent           | Type     | Role                                          |
|-----------------|----------|-----------------------------------------------|
| build (default) | built-in | Standard development agent                    |
| plan            | built-in | Analysis & planning (no edits)                |
| project-manager | custom   | Strategy, backlog, agent coordination         |
| content-manager | custom   | Content audit and management                  |
| jekyll-builder  | custom   | Jekyll build, validation, fix errors          |
| self-evolve     | custom   | Review and improve agent configurations       |
| git-publisher   | custom   | Auto-test → stage → commit → push             |
| hn-summarizer   | custom   | HN discussion → Chinese summary article       |

## Commands
| Command   | Description                        | Agent          |
|-----------|------------------------------------|----------------|
| /test     | Build & validate Jekyll site       | jekyll-builder |
| /deploy   | Build, commit & push to GitHub     | git-publisher  |
| /evolve   | Self-review and improve configs    | self-evolve    |
| /plan     | Plan next steps                    | project-manager|
| /content  | Audit and manage content           | content-manager|
| /hn       | Create HN discussion summary article| hn-summarizer |

## Workflow
1. Make changes (content, config, layout)
2. Run `/test` to validate build locally (Docker)
3. Run `/deploy` to commit and push — GitHub Actions auto-builds and deploys
4. Periodically run `/evolve` to improve agents
5. Run `/plan` to decide what to work on next
