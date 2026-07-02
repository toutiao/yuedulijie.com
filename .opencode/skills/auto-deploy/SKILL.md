---
name: auto-deploy
description: Full deployment pipeline: build validation → git stage → commit → push to master
metadata:
  domain: ops
  workflow: pre-push
---

## Workflow
1. Run `docker compose run --rm build` (or `make build`) — verify exit code 0
2. Run `git status` to inspect changes
3. Stage all changes: `git add -A`
4. Generate descriptive commit message in Chinese
5. Commit: `git commit -m "<message>"`
6. Push: `git push origin master`
7. GitHub Actions auto-builds and deploys to Pages

## Failure Handling

| Condition | Action |
|-----------|--------|
| Build exit code != 0 | Report errors. STOP. Do not stage or commit. |
| Build has warnings, no errors | Use judgment — proceed if safe. |
| Build has errors | STOP and report. |
