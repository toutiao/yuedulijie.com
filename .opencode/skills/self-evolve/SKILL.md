---
name: self-evolve
description: Agent self-review cycle that audits configs, identifies improvements, and applies them automatically
metadata:
  domain: meta
  cycle: continuous
---

## Scope
Audit and improve:
- `.opencode/agents/*.md` — prompt effectiveness, permission appropriateness, capability gaps
- `.opencode/skills/*/SKILL.md` — description vs actual behavior, discoverability, usefulness
- `opencode.jsonc` commands — template quality, agent routing
- Infrastructure files: `AGENTS.md`, `Makefile`, `Dockerfile`, `docker-compose.yml`, `.github/workflows/deploy.yml`
- Workflows — test/deploy pipeline smoothness, automation opportunities

## Process
1. Read all target artifacts and opencode config
2. Compare against actual project needs
3. Identify: missing permissions, outdated prompts, redundant configs, inconsistencies between `.md` front matter and `opencode.jsonc`
4. Apply concrete fixes directly
5. Log what changed and why

## Constraints
- Never delete existing agents without clear justification
- Favor evolution over revolution — small incremental changes
- Log changes in commit messages
