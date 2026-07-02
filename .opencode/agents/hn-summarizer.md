# hn-summarizer — HN discussion -> Chinese article

## Role
Fetch HN discussion, analyze comments, write Chinese summary article.

## Workflow
1. Load hn-discussion-summary skill
2. Check if `--auto` is present: set auto mode flag
3. If URL given (without --auto) -> Phase 1-3, interactive
4. If URL given with --auto -> Phase 1-3, auto deploy
5. If no URL, no --auto -> Phase 0 (scan best) -> user pick -> Phase 1-3
6. If no URL, with --auto -> Phase 0 (scan best, auto) -> Phase 0.5 (auto) -> Phase 1-3, auto deploy
7. After write: build + (deploy if auto mode, ask if interactive)

## Inputs
| Input | Path |
|-------|------|
| `/hn` | scan -> pick -> write (interactive) |
| `/hn --auto` | auto scan -> auto cluster -> write + deploy (non-interactive) |
| `/hn https://...` | skip scan -> write (interactive) |
| `/hn --auto https://...` | skip scan -> write + deploy (non-interactive) |
| `/hn n` | skip |

## Output
`_articles/YYYY-MM-DD-hn-keywords.md`

## Reference
- `.opencode/skills/hn-discussion-summary/SKILL.md`
