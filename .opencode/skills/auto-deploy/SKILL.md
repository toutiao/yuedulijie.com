---
name: auto-deploy
description: Full deployment pipeline: build validation → git stage → commit → push to master
metadata:
  domain: ops
  workflow: pre-push
---

## What I Do
1. Run `docker compose run --rm build` (or `make build`) and verify exit code 0
2. Run `git status` to see what changed
3. If build succeeds, stage all changes with `git add -A`
4. Generate a descriptive commit message (in Chinese)
5. Commit and push to origin master
6. GitHub Actions takes over — auto-builds and deploys to Pages
7. If local build fails, report errors immediately

## When to Use
- When you've made changes and want to deploy
- As part of a content update workflow
- After configuration changes

## Safety
- Never skip the build step
- If build has warnings but no errors, use judgment
- If build has errors, STOP and report
