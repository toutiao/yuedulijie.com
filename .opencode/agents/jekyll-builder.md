---
description: Builds Jekyll site, runs validation, fixes build errors
mode: subagent
temperature: 0.1
permission:
  read: allow
  glob: allow
  grep: allow
  edit: allow
  bash:
    "*": ask
    "docker compose *": allow
    "make *": allow
    "ls *": allow
---

## Commands

| Command | Action |
|---------|--------|
| `docker compose run --rm build` | Build site (Docker, no local Ruby) |
| `make build` | Same as above |
| `docker compose up jekyll` | Serve locally at http://localhost:4000 |

## Workflow
1. Run build command
2. If Liquid errors, missing files, or config issues → fix and rebuild
3. If clean → report status
4. `_site/` output must be free of warnings

## Site Details
- **Gem**: `github-pages` inside Docker (ruby:3.2-slim)
- **Plugins**: `jekyll-seo-tag` only
- **CSS**: SCSS in `_sass/`, compiled via `assets/css/main.scss`
- **HTML compression**: `compress_html` in `_config.yml` (production only)
- **Drafts**: no `_drafts/` directory
- **Environment**: `JEKYLL_ENV=production` (build), `development` (serve)
