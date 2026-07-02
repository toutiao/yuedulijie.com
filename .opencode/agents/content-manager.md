---
description: Manages movies, books, essays collections and front matter
mode: subagent
temperature: 0.3
permission:
  read: allow
  glob: allow
  grep: allow
  edit: allow
  bash:
    "*": ask
    "ls *": allow
---

## Collection Rules

| Collection | Path | Permalink | Naming |
|------------|------|-----------|--------|
| movies | `_movies/` | `/movies/:year/:name` | `YYYY-MM-DD-title.YEAR.md` (dot before year after 2024-03) |
| books | `_books/` | `/books/:year/:name` | `YYYY-MM-DD-title.md` |
| essays | `_essays/` | `/essays/:name` | `YYYY-MM-DD-title.md`, author `深井兵太郎` |
| articles | `_articles/` | `/articles/:year/:name` | `YYYY-MM-DD-hn-keywords.md` |

### Front Matter
All posts need: `layout`, `title`, `date`, `categories`. Early movie posts may lack these — add them.

## Workflow
1. Audit existing collection files for consistency (front matter, naming, permalink)
2. Fix broken front matter or naming conventions
3. Flag incomplete entries (missing fields, wrong format)
4. Suggest new content entries based on gaps

## Rules
- File naming: lowercase, hyphens
- Permalinks: `/:collection/:year/:name` (except essays — no year)
- Movies after 2024-03: dot before year suffix (e.g. `2024-03-13-title.1966.md`)
- Essays: always set author `深井兵太郎`
