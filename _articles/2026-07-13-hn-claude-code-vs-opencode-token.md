---
layout: post
title: "Claude Code vs OpenCode — Token 开销对比"
date: 2026-07-13
categories: [articles]
excerpt: >-
  Claude Code 首次请求发送约 33k tokens，OpenCode 仅 7k。但多步骤任务中，前者因批量工具调用反而总成本更低。
tagline: >-
  Anthropic 的编码助手一顿早饭吃掉 33k tokens，够 OpenCode 吃四顿。等等，账单谁付？
---

Systima 团队在 Claude Code 和 OpenCode 之间架设了日志代理，逐字节记录两个编码助手向模型端点发送的内容。他们将两个工具都锁定在 `claude-sonnet-4-5` 上，在空工作区测试固定开销，然后逐步添加 AGENTS.md 文件、MCP 服务器和真实任务。

结果很清楚：Claude Code 的首次请求约 33k tokens，OpenCode 约 7k。差距的核心来自工具定义——Claude Code 暴露了 27 个工具（包括 `CronCreate`、`Monitor`、`Task` 系列等后台编排套件），合计约 24k tokens；OpenCode 仅 10 个工具，约 4.8k tokens。系统提示本身（去工具后）前者 6.5k，后者 2k。

但多步骤任务反转了直觉。在 "写→运行→测试→修复" 循环中，Claude Code 将两次文件写入和两次脚本执行批量合并到一次往返，仅 3 次请求；OpenCode 一次只调用一个工具，用了 9 次。累计输入量分别为 ~121k 和 ~132k tokens。基线乘以请求次数，大基线的激进批处理反而追平了劣势。

## 讨论焦点

### 方法论质疑

> "So not only is this article AI-written, but the testing was entirely done by AI, too? I can't see any other reason to use such an old model." — MallocVoidstar
> （这文章不但是 AI 写的，测试也是 AI 做的？我想不出为什么用这么老的模型。）

> "Why is your own gateway screwing with your testing?" — MallocVoidstar
> （你自己的网关为什么要干扰测试？）

MallocVoidstar 指出文章使用 `claude-sonnet-4-5` 而非最新模型，以及本地 LLM 网关（Meridian）影响了实验结果。作者 systima 回应：成本考量——通过 Claude Max 订阅而非按量 API 运行，且锁定稳定版本确保对比干净；网关是团队所有 agent 流量的认证路由，非为基准测试构建。但评论者仍认为网关的 6.2k tokens 信封和独立思考策略绕过了工具的官方设置，使部分数据不可比。

### Anthropic 的激励之争

> "Anthropic wants to produce the best coding agent possible and doesn't care (is even incentivized) about high costs." — slopinthebag
> （Anthropic 想做最好的编码 agent，不在乎甚至乐于看到高成本。）

> "Given they're incentivized to increase token use, what guarantees that higher token use improves the effectiveness of the agent and isn't just artificial padding?" — goda90
> （既然他们有动力增加 token 用量，怎么保证高 token 消耗真的提升了 agent 效果，而不是人为注水？）

这是全讨论最激烈的线索。一派认为 Anthropic 从订阅 tier 和 API 消费中获利，没有动力优化 token 效率；另一派指出 GPU 资源稀缺使任何有良知的公司都会追求效率。有评论者提供数据：API 和企业占 Anthropic 收入的 75–85%，个人订阅仅 5%，因此企业级消费定价才真正驱动行为。还有人举出自身经历——被涨到 $100/月 tier——作为间接证据。

### Pi 的光谱另一端

> "pi sends 1k (or less)" — drtournier
> （pi 只发 1k tokens 甚至更少。）

Pi 被反复提及作为反例。它只有 4 个内置工具（读、写、编辑、bash），系统提示极简。评论者 drtournier 表示用 GPT 5.6 Sol（关 thinking）配合 Pi，$20 订阅能用几个小时。但也有声音认为 Pi 过度极简："like old 3D printing where fettling the printer to work is a central part of the hobby"。插件生态（pi-tool-guard、pi-smart-edit）可以弥补，但开箱体验远不如 Claude Code 或 OpenCode。

### 实际省钱技巧

> "I am forced to use claude code at work but a good solution is to just use --system-prompt \"\" and be done with it." — alex7o
> （工作被迫用 Claude Code，但传 `--system-prompt ""` 就解决了。）

多位用户分享了降低 token 开销的实际方法：`--system-prompt ""` 参数可清掉 Anthropic 注入的大量行为指令；渐进式工具暴露（progressive disclosure）只在项目级别启用必要工具；也有人编写自定义代理或用 mitmproxy 分析实际发送内容。还有用户推荐 OpenCode DCP（Dynamic Context Pruning）插件，但被指会破坏缓存。

## 典型观点一览

| 立场 | 用户 | 一句话 |
|------|------|--------|
| Anthropic 有意推高用量 | korrectional | Claude Code 用更多 token 只是因为 Anthropic 这样更赚钱。 |
| 订阅模式下反而不该多耗 token | paxys | 用户付固定月费，Anthropic 应想方设法省 token。 |
| 企业才是收入大头 | toddmorey | 个人订阅仅占 5%，企业按量计费才是真金白银。 |
| 实测发现差距可以缩小 | mh- | 我本地 `/context` 看到的系统提示只有 3.9k，不是 33k。 |
| 自己做 harness 才是终极解 | anonym29 / tmalsburg2 | 跳过所有商业工具，20 行代码就能跑起来。 |

## 总体情绪

讨论的底色是一种算账心态——用户开始拿着计算器审视每个 agent 的每一次 API 调用。Systima 文章的贡献不在于 33k vs 7k 这个数字本身，而在于它建立了可复现的测量框架：日志代理、逐组件分解、缓存效率分析。

评论区对 "Anthropic 是否故意注水" 没有定论，但一个更深层的共识浮出水面：当 agent 的固定开销超过用户实际工作负载时，整个 "agent" 范式的 ROI 就值得怀疑。也许最好的 token 优化不是更好的批处理，而是让模型在开口之前先想清楚自己是不是真的需要那把 27 工具的大锤。

## 引用帖子

| # | 标题 | URL |
|---|------|-----|
| 1 | Claude Code vs OpenCode Token Overhead | https://news.ycombinator.com/item?id=48883275 |

<div class="disclaimer">
  <strong>声明：</strong>本文基于 Systima 博客文章及 Hacker News 讨论生成。引文为网友个人观点，不代表本网站立场。内容由 AI 辅助翻译和整理，可能存在疏漏。
  <br><br><em>本摘要由 AI 模型辅助生成：deepseek/deepseek-v4-flash</em>
</div>
