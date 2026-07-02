---
layout: post
title: "人造细胞首次实现分裂 — HN 讨论摘要"
date: 2026-07-02
categories: [articles]
excerpt: "科学家将非生命分子组装成一个能生长、复制 DNA 并分裂的合成细胞。但它在多大程度上「像生命」？避开同行评审直接联系媒体的做法引发了 HN 社区的激烈辩论。"
tagline: "从零开始造一个细胞——人类终于做到了。但 Cell 期刊的评审把它拒了，理由竟然是“这不算是生物学”。"
---

## 原文概要

2026 年 7 月 1 日，明尼苏达大学的合成生物学家 Kate Adamala 团队在 Quanta Magazine 上公布了一项里程碑式的研究：他们用纯粹的非生命分子——DNA、蛋白质、脂质等实验室合成的构件——组装出了一个能生长、复制 DNA 并分裂的合成细胞，命名为 SpudCell。

此前合成生物学界的最大瓶颈是细胞分裂。研究人员已经掌握了如何让合成细胞进食和复制 DNA，但分裂需要复杂的细胞骨架重组，人工系统一直做不到。Adamala 的解决方案是彻底抛弃细胞骨架：她在一篇论文中发现，通过在细胞膜上附着特定的蛋白标签，可以吸引其他蛋白在膜上聚集，物理性地弯曲膜结构，迫使细胞分裂。

这个细胞不是自给自足的——它需要持续输送食物和核糖体，没有防御机制，也没有有效的废物处理系统。但它证明了从非生命材料构建出具备生命基本功能的系统是可能的。同行评价包括"惊人的技术成就""合成生物学领域的分水岭事件"。Adamala 和合作者还宣布成立了一个非营利组织 Biotic，用于公开共享研究工具和方案。

这篇论文尚未经过同行评审。据 Science 报道，论文曾被 Cell 期刊拒绝，理由是一名审稿人认为"合成生物学不是真正的生物学"。Adamala 随后将 190 页的手稿在 embargo 下提前发送给了记者，至今未上传到 bioRxiv。

来源：HN 热门榜 (/best)

## 讨论焦点

### 1. 技术突破：绕开细胞骨架的分裂机制

有用户完整引用了 Quanta 文章中的关键段落，指出 Adamala 如何从文献中找到灵感：

> "This was where the field had been stuck for some time. Researchers before Adamala had figured out different ways to feed and grow synthetic cells and to replicate their DNA. But cell division is a different beast… So Adamala decided to ditch the cytoskeleton." — JumpCrisscross

但也有用户提醒不要过度高估这项进展：

> "without criticising the work (its very cool and a very important first step) they haven't figured out division yet, which is kind of important." — dnautics

这意味着尽管 SpudCell 能分裂，但机制与天然细胞的精确控制还有差距。

### 2. "这是生命吗？"——定义之争

多位用户指出，SpudCell 距离真正意义上的"生命"还很远。它不能自主合成核糖体，无法代谢产能，需要持续的人工补给。一位用户提到：

> "Lots of missing steps before it is 'created life'. Which the researchers admit in the very start." — IAmBroom

Jack Szostak（Adamala 的博士导师）对 Quanta 表示，不能自主生成核糖体"限制了它的生长和持续繁殖潜力"。Adamala 自己也把 SpudCell 比作"莱特飞行器"，而现代细胞则是"波音 787"。

### 3. 同行评审之争：绕过传统的非传统路线

争议最大的是 Adamala 的发表策略。Science 的报道提到，Cell 的一名审稿人认为 SpudCell 的工作"不是真正的生物学"，论文被拒。Adamala 随后在 embargo 下将 190 页的手稿发给记者，甚至在上传 bioRxiv 之前。有用户转述了同行的看法：

> "Some have also grumbled about Adamala's efforts to draw attention to the work, which she says was rejected by Cell after one reviewer said SpudCells were not real biology. She then sent the 190-page manuscript to journalists, under embargo, even before she had uploaded it to the preprint server bioRxiv." — merksittich

一位用户评价：

> "That's being kind; it's a complete overreaction, simply put." — bouchard

但也有用户为此辩护：

> "It's a workaround against something that likely should not have happened. Problems require creative (aka unusual) solutions." — vintagedave

### 4. 学术评审制度的系统性积弊

这场争议迅速滑向了对学术评审制度本身的讨论。多位用户分享了亲身经历：

> "My paper demonstrating a side channel attack on RSA via hyperthreading was rejected from the crypto preprint archive on the basis that it was 'not cryptography'." — cperciva

（这后来成为 CVE-2005-0109。）

另一位用户分享了更极端的经历：

> "I've had papers sit in peer review for two years, get rejected, then when they are finally published the other editors of the journal that rejected them came crawling in asking for the next paper." — noosphr

还有人揭露了制度性的激励扭曲：

> "While one or more of the reviewers are actively trying to replicate the work so they can beat you to submission after rejecting you." — klustregrif

对评审制度的批评甚至延伸到对"同行评审是否比完全没有评审更好"的质疑：

> "Why? The process is quite obviously net negative; we'd get better results with no process at all." — thaumasiotes

### 5. 科学传播的守门人困境

更深层的问题是：谁有权决定科学成果何时面向公众？支持绕过评审的一方认为：

> "If you have something so truly revolutionary that everyone can see with their own two eyes how awesome it is you don't have to rely on a middleman to bless it." — im3w1l

而主张维持传统的一方则警告：

> "The general public is utterly incompetent at judging science. Homeopathy is the tip of the iceberg of ignorance." — Retric

Retric 进一步用软件工程中的代码评审做类比，认为评审的核心价值不在于评审者比作者更懂，而在于"一双新的眼睛"。还有用户一针见血地指出，其实问题的核心从来不是"该不该有守门人"，而是"你信任谁来当这个守门人"：

> "Who do you believe should be the gatekeeper here? Why can't the scientist and the news outlets be trusted to make the decision about whether to publish or not themselves?" — derektank

## 典型观点一览

| 立场 | 用户 | 一句话 |
|------|------|--------|
| 技术乐观 | JumpCrisscross | 绕开细胞骨架的分裂机制是真正的创新点 |
| 审慎评价 | dnautics | 工作很酷，但说"彻底解决了分裂"还为时过早 |
| 同情研究者 | vintagedave | 非常规问题需要非常规解决方案 |
| 批评发表策略 | bouchard | 直接发给记者是过度反应 |
| 反思评审制度 | noosphr | 评审两年被拒，拒稿的期刊后来却来要下一篇 |
| 揭露制度扭曲 | klustregrif | 审稿人拖稿是为了自己抢先发表 |
| 质疑评审价值 | thaumasiotes | 评审制度的净效应是负的 |
| 守门人信仰 | Retric | 公众没有能力判断科学质量，守门人必不可少 |
| 开放科学 | derektank | 科学家和媒体自己判断就够了，不需要中间人 |

## 总体情绪

讨论氛围总体上积极但克制。多数用户认可这项工作的技术分量——特别是"绕开细胞骨架"的巧思——但对"是否算生命"普遍持保留态度。围绕发表策略的分歧最明显：一部分人认为绕过不合理的审稿是正当的反抗，另一部分人则认为跳过同行评审直接接触媒体是危险先例。延伸到对学术评审制度本身的讨论时，情绪变得较为激烈，不少用户分享了令人沮丧的个人经历。

## 引用帖子

| # | 标题 | URL |
|---|------|-----|
| 1 | For first time, a cell built from scratch grows and divides | https://news.ycombinator.com/item?id=48747304 |
| 2 | Quanta Magazine 原文 | https://www.quantamagazine.org/for-the-first-time-a-cell-built-from-scratch-grows-and-divides-20260701/ |
| 3 | Science 报道 | https://www.science.org/content/article/lab-created-spudcell-marks-major-step-toward-building-life-scratch |
| 4 | Biotic 项目页 | https://biotic.org/research/spudcell/ |

<div class="disclaimer">
  本文基于 Hacker News 上的公开讨论整理而成，不代表本网站观点。文中涉及尚未经过同行评审的研究成果，读者应注意甄别。
</div>
