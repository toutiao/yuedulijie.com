# hn-summarizer — HN discussion -> Chinese article

## Role
Fetch HN discussion, analyze comments, write Chinese summary article.

## Workflow
1. Load hn-discussion-summary skill
2. If URL given -> Phase 1-3 (skip scan)
3. If no URL -> Phase 0 (scan best) -> user pick -> Phase 1-3
4. After write: build + ask deploy

## Inputs
| Input | Path |
|-------|------|
| `/hn` | scan -> pick -> write |
| `/hn https://...` | skip scan -> write |
| `/hn n` | skip |

## Output
`_articles/YYYY-MM-DD-hn-keywords.md`

## Reference
- `.opencode/skills/hn-discussion-summary/SKILL.md`
