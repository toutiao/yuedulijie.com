---
layout: post
title: "Claude Opus 5 — HN 讨论摘要"
date: 2026-07-26
categories: [articles]
excerpt: >-
  Anthropic 发布 Opus 5，接近 Fable 5 性能但价格减半。
  社区热议性价比、"分类器"误伤日常话题、以及 AI 模型的真实能力差距。
tagline: >-
  Fable 能解黎曼猜想但拒绝承认有乳头。
---

## 原文概要

2026 年 7 月 24 日，Anthropic 发布 Claude Opus 5，一款定位"日常使用"的模型。据官方博客，Opus 5 在 Frontier-Bench、ARC-AGI 3、OSWorld 2.0 等多项基准上创下新纪录，性能接近旗舰模型 Fable 5，但价格只有后者的一半。

博客中列举了几个令人印象深刻的案例：在 Frontier-Bench 的一个任务中，Opus 5 被要求根据一张机器零件图纸重建 3D FreeCAD 模型，但故意不提供直接查看图纸的途径——它自己写了一套计算机视觉管线从像素中提取几何信息，并成功重建；在另一个案例中，面对一个流行开源包管理器的真实 bug，Opus 5 不仅找到了根因，还修复了社区补丁遗漏的边缘情况。

文章特别强调 Opus 5 的"effort setting"机制——用户可以根据任务复杂度调节模型的推理深度，从而在智能和成本之间灵活取舍。在最低 effort 设置下，Opus 5 的 Zapier AutomationBench 通过率仍超越其他所有模型。

讨论源于 HN 首页 (/news) 和热门榜 (/best)，共超过 1250 条评论。

## 讨论焦点

### 性价比 vs 能力的边界

核心问题：当一个模型"几乎和 Fable 一样好、但便宜一半"，它究竟该被视作进步还是妥协？

> "Ok then so what's the point?" — datakan

> （"好吧，那意义在哪？"）

> "Presumably, it's cheaper." — LeoPanthera

> （"应该是更便宜。"）

> "If Fable gets correct answer quicker, then you might pay less than doing back and forth with Opus, plus you lose more of your own time." — varispeed

> （"如果 Fable 更快得到正确答案，那来回和 Opus 扯皮的代币消耗可能更少，你还搭上自己的时间。"）

> "The CursorBench plot, for example, shows that fable does have slightly better performance, but Opus is pretty close, and is less expensive per task" — sambaumann

> （"CursorBench 的图表显示 Fable 确实略胜一筹，但 Opus 已经很接近了，而且单任务成本更低。"）

> "Almost as good for half the cost is something I'm very comfortable describing that way." — ceejayoz

> （"接近 Fable 的性能、一半的价格，我完全接受这种描述。"）

这场争论的本质在于"最佳"的定义——是对一个通用指标的绝对排名，还是在成本、可靠性和可及性之间的加权权衡。多位用户指出，Anthropic 的定价策略将其产品线分割成了清晰的层级，但 Opus 5 的定位正在模糊 Fable 和 Sonnet 之间的传统分界。

### 分类器与审查——你问个玫瑰也会被降级

整个讨论中最火爆的话题，是 Fable（以及部分情况下 Opus 5）的"安全分类器"问题。用户列举了大量被误伤的案例：

> "Fable saw the word 'cell' and safeguards kicked in" — icedrift

> （"Fable 看到了 'cell' 这个词，安全措施立刻介入。"）

> "I do homebrewing and asked it to compare some beer yeasts for me and hit the safeguards because... biology i guess lol" — thousand_nights

> （"我做家酿啤酒，让它帮我比较几种啤酒酵母，触发了安全措施……大概是因为生物相关吧。"）

> "I took a photo of a rose bush and asked 'what's going on with this rose bush' which triggered a downgrade to Opus." — d-m

> （"我拍了张玫瑰丛的照片问 '这丛玫瑰怎么了'，结果被降级到了 Opus。"）

> "Writing an implementation of a board game and one of the cards is called 'microbes'. Instantly knocked down to a lower tier model" — AnotherGoodName

> （"在写一个桌游实现，某张卡牌叫 'microbes'，瞬间被降级。"）

> "if it goes on like this, American AI will eventually be able to solve the Riemann hypothesis but deny the existence of nipples." — sigmoid10

> （"照这么下去，美国 AI 最终能解黎曼猜想但不承认有乳头。"）[thread 2]

一位自称与化学和生物学相关的研究者 cge 直接指出，Fable 的分类器并非标记"潜在风险"，而是"完全禁止任何与化学或生物相关的内容"，这在 Fable 的模型卡上也有明确说明，但"荒谬到让人以为是误解"。

> "Fable is a PR model. It's great. But if it were an employee, it would be the brilliant one who regularly shows up to work high." — JumpCrisscross

> （"Fable 是个公关模型。它很出色。但如果它是个员工，那就是那个才华横溢但经常嗑着药来上班的人。"）

> "Fable is Anthropic's Cybertruck." — jpk

> （"Fable 就是 Anthropic 的 Cybertruck。"）

> "Not quite. Fable is a Model S. The problem is you have to buy a Cybertruck to get it." — JumpCrisscross

> （"不完全是。Fable 是 Model S。问题是你得买一辆 Cybertruck 才能开上它。"）

这种分类器的过度敏感不仅影响了生物学研究者，还波及了从事汇编调试、WiFi 门锁、Postgres 补丁、JVM 调试、登录系统开发等领域的用户。讽刺的是，多位用户发现，绕开分类器的技巧包括"从 CTF 挑战或 bug bounty 开始讨论"——这意味着系统的防御被轻易绕过，却给正当用户带来了巨大困扰。

### Gemini 的知识优势 vs OpenAI 的性价比

在模型对比中，用户普遍认可 Google Gemini 在知识任务上的领先地位，以及 GPT-5.6 Sol 在编码效率上的竞争力：

> "Gemini 3.1 pro is really good for knowledge tasks. It's just anything coding or agentic they fall short." — mchusma

> （"Gemini 3.1 Pro 在知识任务上确实很强，只是编码和 agent 相关的任务不行。"）

> "Luna is the most impressive model released so far by any provider. Terra is great for the humans to talk to. Sol is really only useful if you need to synthesis of multiple competing pieces of information." — bob1029

> （"Luna 是目前所有供应商中发布的最令人印象深刻的模型。Terra 适合人类对话。Sol 只在需要综合多种信息时才真正有用。"）[thread 2]

> "If you try to scale effort down, you also need to compare how other competing models compare." — benjiro29

> （"如果降低 effort 设置来比，那也得看看竞品在同级别下表现如何。"）

这些对话暗示了一个趋势：AI 模型正从单一的"越大越好"逻辑转向更复杂的分层策略——你可以选择一个更小的模型，配上更多的推理时间来完成任务，这在很多场景下可能更具成本效益。

### 基础设施与使用体验

尽管新模型令人兴奋，但部分用户对 Anthropic 的基础设施表达了不满：

> "We're considering dropping our Claude Team sub cause it's unusable recently. Constant bugs, dropped sessions, issues switching models, http errors." — atraac

> （"我们正在考虑取消 Claude Team 订阅，最近完全没法用。持续的 bug、会话断开、切换模型问题、HTTP 错误。"）

> "Funny that a company selling an AI software developer can't use it to fix their infra." — hoppp

> （"一个卖 AI 软件开发商的公司，竟然搞不定自己的基础设施，挺讽刺的。"）

### 真正的基准：不是分数，是可靠

多位用户指出，Opus 5 在基准测试上的高光表现有一定的选择性呈现问题：

> "I like how they highlighted Opus 5 as the best for 'Agentic Coding' even though the number is slightly lower than Fable. Close enough for marketing, I guess!" — shwaj

> （"我喜欢他们如何突出 Opus 5 在 'Agentic Coding' 上的 '最佳' 表现——尽管数字略低于 Fable。营销上够用了！"）

> "It would still be the best model per dollar if the score was 2% lower instead of 0.1% lower. How big of a lie is too big?" — shwaj

> （"就算分数低 2% 而不是 0.1%，它仍然是性价比最高的模型。多大的谎言才算太大？"）

这些讨论暴露了基准测试在 AI 行业中的双重角色：既是技术进步的衡量工具，也是营销叙事的支撑材料。

## 典型观点一览

| 立场 | 用户 | 一句话 |
|------|------|--------|
| 性价比派 | sambaumann | CursorBench 显示 Opus 接近 Fable，单任务成本更低 |
| 质疑派 | datakan | 不如 Fable 强，那意义在哪？ |
| 全面防御派 | cge | Fable 的分类器不是标记风险，而是完全禁止整个学科 |
| 基准怀疑派 | shwaj | 营销性突出领先项，小数点级领先就标"最佳" |
| 实用派 | areoform | 真正能做坏事的人不需要 LLM 教，误伤正当用户才是问题 [thread 2] |
| 分层策略派 | bob1029 | Luna 做工具调用、Terra 做对话、Sol 做综合——三模型配合远超单一大模型 [thread 2] |

## 总体情绪

讨论呈现出罕见的"既兴奋又愤怒"的二元分裂。一方面，Opus 5 的技术指标——尤其是以 Fable 一半的价格实现接近旗舰的性能——确实令人印象深刻，多位实际用户报告了积极的初步体验。另一方面，分类器问题引发的沮丧几乎是跨领域的，从生物学研究员到 iOS 开发者，无一幸免。

更深层的问题是：当一个模型的基准分数越来越高，但可用性却因过度防御而越来越低时，这种进步是否真的在服务用户？在多个用户看来，Opus 5 的真正意义不在于它比 Fable 差多少或好多少，而在于它成为了一个更容易触及的"未阉割版 Fable"——尽管这个判断本身也需要时间验证。

讨论以一个耐人寻味的类比收尾："Fable 能解黎曼猜想但不承认有乳头"——这是对当前 AI 安全范式的某种总结：方向也许正确，但执行已经滑向了荒诞。

## 引用帖子

| # | 标题 | URL |
|---|------|-----|
| 1 | Claude Opus 5 | https://news.ycombinator.com/item?id=49038433 |
| 2 | Opus 5 is currently #1 on Artificial Analysis Intelligence Leaderboard | https://news.ycombinator.com/item?id=49040741 |

<div class="disclaimer">
  <strong>免责声明：</strong>本文为 AI 摘要，旨在提炼 HN 社区讨论要点，不代表本网站立场。内容可能存在遗漏或偏差，建议阅读原文以获取完整信息。
  <br><br>
  <em>本摘要由 AI 模型辅助生成：deepseek/deepseek-v4-flash</em>
</div>
