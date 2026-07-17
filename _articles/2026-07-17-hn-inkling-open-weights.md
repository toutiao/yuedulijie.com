---
layout: post
title: "Inkling — Thinking Machines Lab 发布 975B 开源 MoE 模型"
date: 2026-07-17
categories: [articles]
excerpt: >-
  975B 参数、41B 激活、多模态、1M 上下文——Thinking Machines Lab 发布首个开源大模型 Inkling。HN 讨论焦点：美国版 DeepSeek 来了吗？开源模型公司怎么赚钱？
tagline: >-
  美国终于有自己的开源前沿模型了。但商业上怎么走，没人说得清。
---

## 原文概要

Thinking Machines Lab 于 7 月 15 日发布其首个开源权重模型 Inkling。这是一款 Mixture-of-Experts Transformer，总参数 975B，单次推理激活 41B，上下文窗口 1M tokens。预训练数据规模 45T tokens，涵盖文本、图像、音频和视频。

Inkling 定位不是"最强的开源模型"，而是一个"适合定制化的多模态基础模型"。与其一起发布的还有 Inkling-Small（276B 总参数、12B 激活）的预览。模型可通过 Tinker 平台进行微调。官方演示中最引人注目的一项：Inkling 自己编写微调任务、调用 Tinker API 完成训练、加载新权重——实现自我微调闭环。

在 Design Arena 的 Agentic Web Dev 排行榜上，Inkling 得分 1257，位于开源模型前列，紧追 Claude Opus 4.6 和 Kimi K2.6。HN 首页讨论此帖。

## 讨论焦点

### 美国版 DeepSeek 终于来了？

"美国需要自己的 DeepSeek 或 Z.ai——很多人（包括我）之所以支持中国的开源模型赢，是因为他们别无选择。Thinking Machines 可能就是答案。" — ls_stats

这条评论戳中了不少读者的痛点。长期以来，开源前沿模型领域几乎被中国公司（DeepSeek、GLM、Kimi）主导，美国玩家缺位。Inkling 的发布被一些人视为"美国队入局"的信号。

但随即有质疑：它够强吗？"它没有 GLM 5.2 在 agent 工作流上表现好，而且体型还更大。竞争会很残酷，因为切换成本极低。" — verdverm

> "It's not as good as GLM 5.2 for agentic workflows while also being bigger."
> （它在 agent 工作流上不如 GLM 5.2，体积还更大。）

另一方则认为，拿首秀产品与经过多轮迭代的 GLM 5.2 对比不公平："GLM 5.2 发布后经历了大量 post-training 和迭代才达到今天的状态。作为首秀，这已经非常强了，潜力很大。" — InsideOutSanta

### 开源模型的商业模式困境

Inkling 的发布引发了一个老问题：开源权重模型公司怎么赚钱？

"I don't really get the business plan for open weights model companies. Is the idea companies would pay them for serving?" — jjfoooo4

一种回答是 Tinker——微调即服务。Thinking Machines 的平台允许客户在 Tinker 上托管微调任务和最终模型。有评论引用 Joel on Software 的策略："给免费剃须刀，卖刀片。"

但质疑者认为这和 AWS 的逻辑不同——AWS 拥有物理硬件且不开源核心软件，而开源模型公司只是租用 GPU 再加一层薄 margin：

"In this scenario, they would be offering the open source model and then offering the same model hosted. There isn't really a moat here — it would be trivial for another company to take their same model and offer it for the same price or less." — Closi

> "there isn't really a moat here — it would be trivial for another company to take their same model and offer it for the same price or less."
> （这里没有护城河——另一家公司完全可以拿走同一个模型卖更低价格。）

### 微调平台能成为护城河吗？

Tinker 的核心价值主张：不是所有人都有能力或意愿自己部署微调基础设施。正如一位评论者指出：

"Open models when fine-tuned are capable at better than frontier performance at a fraction of the price for many domain specific tasks. If companies help make that easy to implement, there is value to capture." — mchusma

但有人不服："我能在我的 Mac 上跑 LoRA……虽然不能在 1T 参数的模型上跑。但如果我在训万亿参数模型，我会买能跑这个的设备。他们的秘方在哪里？" — sgt101

回应的观点是：买硬件、配置环境本身就是门槛。"你 LoRA 需要的硬件和你做推理需要的硬件不一样——要么欠配让微调跑不动，要么超配让利用率低。" — tfehring

> "Like, buy and set up the physical hardware? I cba with that."
> （自己去买硬件搭环境？我可懒得搞。）

### 中国开源模式的阴影

讨论不可避免地转向地缘政治。有评论直言中国的开源模型公司可能不是靠商业盈利存活的：

"There is a chance their business model is absorbing government funding." — andriy_koval

另一位评论者则分析了为什么美国难有类似 DeepSeek 的产物：

"To compete against America. If your country has something like DeepSeek you really can't afford to let it fall. And this is why there will never be a 'DeepSeek of the US.'" — raincole

> "this is why there will never be a 'DeepSeek of the US.'"
> （这就是为什么永远不会有"美国版 DeepSeek"。）

不过也有评论指出，地缘政治风险对双方都存在："考虑到总统是谁会带来多大的不确定性，我认为美国公司也需要'跟美国竞争'，以免底牌被抽走。" — gtirloni

## 典型观点一览

| 立场 | 用户 | 一句话 |
|------|------|--------|
| Inkling 是美国的 DeepSeek | ls_stats | 美国终于有自己的开源前沿模型了。 |
| 跟 GLM 5.2 比还不够强 | verdverm | 比人家大还比人家差，切换成本又低。 |
| 首秀模型值得期待 | InsideOutSanta | GLM 5.2 也是一步步迭代上来的。 |
| 开源模型没有商业模式 | jjfoooo4 | 开源了怎么赚钱？靠 hosting？ |
| Tinker 微调平台是护城河 | mchusma | 开源 + 微调 = 低成本定制价值。 |
| 护城河不存在 | Closi | 你用我的开源模型，别人也能用，价格更低。 |
| 中国公司靠政府资金存活 | andriy_koval | DeepSeek 的商业模式可能就靠政府拨款。 |
| 美国不会有 DeepSeek | raincole | 美国公司没有中国那种战略驱动力。 |

## 总体情绪

讨论分裂成两个平行世界。一边是"终于有美国开源模型了"的兴奋，另一边是"不赚钱的事谁会一直做"的质疑。前者的情绪是希望——Thinking Machines 至少证明美国在开源前沿领域没有完全缺席。后者的情绪是世故——他们指着一个又一个倒在开源商业化路上的先烈说，历史已经演过一遍了。

评论区没有多少人对 Inkling 的技术本身兴奋到尖叫——这在模型发布越来越频繁的 2026 年并不意外。真正让人停下来思考的是那个老问题：在这场 AI 军备竞赛里，开源到底是一种战略，还是一种理想？

## 引用帖子

| # | 标题 | URL |
|---|------|-----|
| 1 | Inkling: Our Open-Weights Model | https://news.ycombinator.com/item?id=48924912 |

## 免责声明

本文基于 HN 讨论帖整理而成，不构成任何投资建议或技术推荐。观点仅代表参与者个人立场。

<br><br><em>本摘要由 AI 模型辅助生成：deepseek/deepseek-v4-flash</em>
