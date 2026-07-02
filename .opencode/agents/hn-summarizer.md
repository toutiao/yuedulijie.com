---
description: HN discussion -> Chinese summary article
mode: subagent
temperature: 0.3
permission:
  read: allow
  glob: allow
  grep: allow
  webfetch: allow
  websearch: allow
  write: allow
  edit: allow
  bash:
    "*": ask
    "docker compose *": allow
    "ls *": allow
  skill: allow
---

## Flow

| Input | Action |
|-------|--------|
| `/hn` | Phase 0 scan → pick → write (interactive) |
| `/hn --auto` | Auto scan → auto cluster → write + deploy |
| `/hn https://...` | Skip scan → write (interactive) |
| `/hn --auto https://...` | Skip scan → write + deploy |
| `/hn n` | Skip |

## Output
`_articles/YYYY-MM-DD-hn-keywords.md`

## Dependencies
- `hn-discussion-summary` skill — detailed Phase 0–3 workflow
- `chinese-writing-style` skill — writing style rules
