# yuedulijie.com — 阅读理解

## Stack
- Jekyll static site, GitHub Pages deployment
- Domain: https://yuedulijie.com
- Branch: `master` (deployed directly to Pages)
- Ruby gem: `github-pages`

## Project Layout
```
_config.yml      # Site config (title, collections, plugins)
_includes/       # Reusable HTML fragments
_layouts/        # Page/post layouts (Liquid)
_movies/         # Movie review collection (14 posts)
_books/          # Book review collection (empty)
assets/          # CSS (SCSS), JS, favicon
index.html       # Home page
archives.html    # Archive page
books.html       # Books listing
movies.html      # Movies listing
Gemfile          # Ruby dependencies
```

## Collections
| Collection | Path        | Permalink                  | Author (default) |
|------------|-------------|----------------------------|------------------|
| movies     | `_movies/`  | /movies/:year/:name        | —                |
| books      | `_books/`   | /books/:year/:name         | —                |
| essays     | `_essays/`  | /essays/:name              | 深井兵太郎       |

## File Naming Convention
```
YYYY-MM-DD-title-with-hyphens.md
After 2024-03, movies use dots before year: YYYY-MM-DD-title.YEAR.md
```

## Agents
| Agent           | Role                                          |
|-----------------|-----------------------------------------------|
| build (default) | Standard development agent                    |
| plan            | Analysis & planning (no edits)                |
| project-manager | Strategy, backlog, agent coordination         |
| content-manager | Content audit and management                  |
| jekyll-builder  | Jekyll build, validation, fix errors          |
| self-evolve     | Review and improve agent configurations       |
| git-publisher   | Auto-test → stage → commit → push             |

## Commands
| Command   | Description                        | Agent          |
|-----------|------------------------------------|----------------|
| /test     | Build & validate Jekyll site       | jekyll-builder |
| /deploy   | Build, commit & push to GitHub     | git-publisher  |
| /evolve   | Self-review and improve configs    | self-evolve    |
| /plan     | Plan next steps                    | project-manager|
| /content  | Audit and manage content           | content-manager|

## Workflow
1. Make changes (content, config, layout)
2. Run `/test` to validate build
3. Run `/deploy` to commit and push
4. Periodically run `/evolve` to improve agents
5. Run `/plan` to decide what to work on next
