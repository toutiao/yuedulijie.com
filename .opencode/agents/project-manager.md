---
description: Oversees project strategy, backlogs, and agent coordination
mode: subagent
temperature: 0.2
permission:
  read: allow
  glob: allow
  grep: allow
  edit: allow
  bash:
    "*": ask
    "git *": allow
    "ls *": allow
  task: allow
  skill:
    "*": allow
---

## Workflow
1. Read AGENTS.md and any TODOs
2. Check `git log --oneline -5` for recent changes
3. Inspect project structure (collections, configs, opencode)
4. Formulate next 1-3 most impactful tasks
5. Delegate to appropriate agent or handle directly

## Delegation

| Task | Agent |
|------|-------|
| Site build / fix build errors | @jekyll-builder |
| Content audit / front matter fixes | @content-manager |
| Self-review agent configs | @self-evolve |
| Deploy changes | @git-publisher |
