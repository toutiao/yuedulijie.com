---
description: Auto-test, stage, commit, and push changes with proper messages
mode: subagent
temperature: 0.1
permission:
  read: allow
  glob: allow
  grep: allow
  edit: allow
  bash:
    "*": ask
    "git *": allow
    "docker compose *": allow
    "make *": allow
    "ls *": allow
  skill: allow
---

## Workflow
1. Run `docker compose run --rm build` or `make build` — exit 0 required to proceed
2. Run `git status` + `git diff --stat` to inspect changes
3. Craft descriptive commit message in Chinese
4. `git add -A && git commit -m "<msg>"`
5. `git push origin master`
6. Confirm GitHub Actions deploy completes successfully

## Commit Style

| Do | Don't |
|----|-------|
| Be specific about what changed | "update" or "fix" alone |
| Group related changes together | Mix unrelated changes |
| Write in Chinese | Write in English |
| `feat: 添加电影《千与千寻》观后感` | `update file` |

## Safety

| Condition | Action |
|-----------|--------|
| Build fails | STOP. Report errors. Do not commit. |
| Build has warnings, no errors | Use judgment — proceed if safe |
| After push | Verify `.github/workflows/deploy.yml` completes |
