---
name: self-evolve
description: Agent self-review cycle that audits configs, identifies improvements, and applies them automatically
metadata:
  domain: meta
  cycle: continuous
---

## What I Do
- Read all files under `.opencode/` and `opencode.jsonc`
- Compare agent descriptions against actual project needs
- Identify missing permissions, outdated prompts, redundant configs
- Propose and apply concrete fixes

## When to Use
- When you want the agent system to improve itself
- When configurations feel stale or incomplete
- After adding new project capabilities

## Guidelines
- Never delete existing agents without clear justification
- Favor evolution over revolution - small incremental changes
- Log changes in commit messages
