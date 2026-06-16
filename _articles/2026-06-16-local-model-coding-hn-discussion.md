---
layout: post
title: "本地模型替代 Claude — HN 讨论提炼"
date: 2026-06-16
categories: [articles]
---

## 原文概要

HN 用户发帖问: 有没有人用本地模型完全替代了 Claude/GPT 做日常编码? 351 条评论中大量用户分享了实际配置. 主流方案: Qwen 3.6 系列 + Pi/opencode 工具链.

来源: HN 热门榜 (/best)

---

## 讨论焦点

### 1. 主流本地配置

> "I replaced a $100/m subscription to claude in favor of running pi harness pointed at unsloth studio, using Qwen3.6-35B-A3B-MTP-GGUF and Gemma 4 31B."
> — horsawlarway
> （用 pi + unsloth + Qwen3.6 系列替代了每月 $100 的 Claude.）

> "Llama.cpp + Qwen3.6-35b (MTP) + OpenCode is quite capable and runs on a single RTX 3090 and is faster than most cloud models. Quality is like running edge models from 8-12 months ago."
> — pierotofy
> （单张 RTX 3090 跑 Qwen3.6 系列 + OpenCode, 质量约等于 8-12 月前的边缘模型, 但速度快于云端.）

> "I use pi with an RTX Pro 6000 Blackwell to run Gemma 4 31b for all my agentic coding."
> — jodoherty

### 2. 硬件成本

> "I'm using 4x RTX 5070's and first-gen AMD threadripper to run Qwen3.6 27B (MTP) Q6_K with llama.cpp. Around 50-60 toks/sec."
> — jborak

> "Qwen3.6-35B-A3B on a Strix Halo 128GB. I have way too much VRAM for such a model but Qwen never released the 122B version of Qwen3.6."
> — stymaar

### 3. 对话质量 vs 速度

> "It is NOT as smart as CC or Codex but its enough to get most of my work done. I didn't set out to replace Claude, I set out to save money."
> — bluejay2387
> （不如 Codex/Claude 聪明, 但足够完成大部分工作. 我不是想替代, 只是想省钱.）

> "The problem with this question is that it encompasses a huge spectrum of capabilities and expectations. If you can only run an 8B model and expect it to be good at vibe coding, you'll be disappointed."
> — sosodev
> （这问题太宽泛. 只能跑 8B 模型还指望 vibe coding 的好效果会失望的.）

### 4. 隐私考量

> "I care about data privacy and LLMs being free. I'm using the Pi coding harness but containerized and sandboxed, to make sure it's running completely offline."
> — Greenpants

> "For client projects where privacy and security is important, but no enterprise contract: Open code against Infomaniak hosted OSS models."
> — ozten

---

## 典型观点

| 立场 | 用户 | 一句话 |
|------|------|--------|
| 🔵 可替代 | horsawlarway | Qwen3.6 + pi 已完全替代 $100/m 的 Claude |
| 🔵 省钱 | bluejay2387 | 不如云模型聪明, 但省了每月一百刀 |
| 🟡 硬件门槛 | sosodev | 跑 8B 模型期望 vibe coding 基本没戏 |
| 🟡 质量差距 | pierotofy | 本地模型质量约等于 8-12 月前的云模型 |
| ⚪ 隐私优先 | Greenpants | 容器化 + 沙箱, 完全离线运行 |
| ⚪ 主流组合 | 多数 | Qwen3.6 + Pi/OpenCode + llama.cpp 是默认方案 |

<div class="disclaimer">
**免责声明**: 本文是对 HN 讨论的编译与提炼. 所有观点来自 HN 评论者, 不代表本人立场.
</div>
