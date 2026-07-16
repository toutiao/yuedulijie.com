---
layout: post
title: "《侏罗纪公园》计算机硬件详解 — HN 讨论摘要"
date: 2026-07-16
categories: [articles]
excerpt: >-
  Fabien Sanglard 逐帧解析《侏罗纪公园》中出现的每一台计算机和软件，从 PowerBook 100 到 SGI Crimson，还原 1993 年的科技面貌。HN 社区围绕 SGI 的陨落、Mac/Unix 混搭的合理性、以及 Crichton 作品中的先见之明展开讨论。
tagline: >-
  $875,000 的 SGI 设备、$350,000 的苹果电脑——斯皮尔伯格为了真实，把片场变成了计算机博物馆。
---

> 原文：[Jurassic Park computers in excruciating detail](https://fabiensanglard.net/jurrasic_park_computers/index.html) — Fabien Sanglard
>
> 来源：HN 首页 (/news) | 866 分 | 229 条评论

## 原文概要

Fabien Sanglard 在重看《侏罗纪公园》（JP）第十遍之后，决定逐一考据片中出现的每一台计算机和软件。他从 Alan Grant 和 Ellie Sattler 拖车中的 **Apple PowerBook 100** 开始——这台 1991 年发布的笔记本配备 Motorola 68000 16 MHz 处理器、2–8 MB 内存、640 × 400 单色 LCD，运行 System 7.0.1。

控制室是硬件的集中展示区。Dennis Nedry 的桌面一片狼藉，堆着三台主机（两台 Mac、一台 SGI）、三台显示器、一台 PDA 和多组存储设备。Ray Arnold 的工位则整洁得多，配备 CCTV 屏幕、一台 Mac 和一台 SGI 工作站。背景中的巨型屏幕和闪烁红灯的超级计算机来自 **Thinking Machines CM-5**。

根据《The Making Of Jurassic Park》一书，片场所有设备都是真实的："观众对计算机的了解已经非常深入，我们不能造假。"SGI 提供了价值 **$875,000** 的设备，Apple 提供了 **$350,000**，加上其他软硬件约 **$500,000**——按 2026 年通胀调整，总计约 **400 万美元**。

Sanglard 还发现了多处细节：Nedry 的主力工作站 **SGI IRIS Crimson** 太庞大放不上桌，只能搁在地上；五组 **PLI Mini Arrays** 备份设备在片中出现了连续性错误（位置莫名其妙翻转）；以及 **Motorola Envoy**——一款可折叠带天线的 PDA，由 frogdesign 创始人 Hartmut Esslinger 在飞机上展示给斯皮尔伯格后出现在片中的。

## 讨论焦点

### SGI 的崛起与陨落

多位评论者指出，SGI 的衰落是 Clayton Christensen "创新者困境"的典型案例。

> "SGI was a textbook Innovator's Dilemma case with an expensive enterprise product that's hard to give up in the face of cheap, low-margin competition." — corysama
> （SGI 是创新者困境的教科书案例：昂贵的企业级产品难以在廉价低利润竞争面前放手。）

> "They had the tech advantages but the high margins of full work stations blinded them to the changing winds in the industry." — ColdStream
> （他们有技术优势，但整机的高利润率让他们对行业风向的变化视而不见。）

曾在 SGI 工作的 JSR_FDED 补充说：

> "I was at SGI, and their entire business was optimized to serving the needs of very sophisticated customers who were themselves pushing the envelope. Absolutely great customers to work with. But SGI's DNA couldn't adjust to the low margin high volume consumer space." — JSR_FDED
> （我曾在 SGI 工作。他们的整个业务都是为服务高端客户而优化的，这些客户自己就在推动技术边界。和他们合作非常愉快。但 SGI 的 DNA 无法适应低利润高销量的消费市场。）

SGI 曾为 Nintendo 设计 N64 的 GPU，但并未从中获得可观利润。3DFX 和 NVIDIA 最终以 $199 的 PC 扩展卡蚕食了 SGI 的市场。

### Mac + Unix 混搭：合理的配置还是电影道具的巧合？

控制室同时使用 Mac 和 SGI 引起了最多的讨论。评论者 yjftsjthsd-h 表示困惑：如果全是 SGI 或全是 Unix 工作站，他不会觉得奇怪，但 Mac 的出现让人费解。

> "Generally full marks on realism, but I have to ask: Is a combination of SGI and old school macs a sensible platform for running a park?" — yjftsjthsd-h
> （真实感满分，但我必须问：SGI 和老款 Mac 的组合是运营公园的合理方案吗？）

多位评论者指出，这在 90 年代是常见配置。Mac 用于行政办公（邮件、表格、演示），SGI 承担重型计算任务。

> "Macintosh and SGI (+AIX, various Unix) were in fact a common combination used as desktop and backend server respectively in many 1990's scientific labs including biology labs." — pishpash
> （Macintosh 和 SGI（以及 AIX、各种 Unix）在 90 年代的许多科学实验室中都是常见的组合，Mac 作为桌面、Unix 作为后端服务器，包括生物实验室。）

此外，经典 Mac OS 也有 X Window 服务器，可以作为 Unix 的廉价图形终端。

更有趣的是幕后原因：电影制片方本身就在使用 SGI 工作站渲染 CGI 恐龙，这些设备就在片场，道具组自然顺手拿来用。

### Crichton 的先见之明

多位评论者对 Michael Crichton 的前瞻性感到惊讶。

> "Crichton was frighteningly good as a prognosticator and futurist." — jambalaya8
> （Crichton 作为预言家和未来学家，准得吓人。）

> "It was kind of scary how prescient Jurassic Park was. Just swap genetics for AI and his warnings are incredibly applicable to modern times." — yoyohello13
> （侏罗纪公园的先见之明有点吓人。把遗传学换成 AI，他的警告对当代同样适用。）

评论者 MrToadMan 指出 Crichton 更早的作品《西部世界》（Westworld）同样具有预言性，并引用了其中的一句台词："这些是非常复杂的设备，几乎和生物体一样复杂。在某些情况下，它们是由其他计算机设计的。我们并不确切知道它们如何工作。"——这句话放在 AI 时代的今天，几乎无需修改。

### 关于"放过预算"的幽默与讽刺

> "Hammond spared no expense except when it came to Nedry, which was a critical mistake." — Mountain_Skies
> （Hammond 不放过任何预算，除了在 Nedry 身上——这是一个关键错误。）

> "According to Nedry." — actionfromafar
> （那是 Nedry 的一面之词。）

> "Movie-Nedry struck me as a certain kind of hacker trope (but whom I've also met in real life!) where part of their 'compensation' is access to unusual and high end computer hardware." — SyzygyRhythm
> （电影中的 Nedry 让我想到某种特定的黑客原型——我在现实中遇到过！——他们将高端硬件的使用权视为薪酬的一部分。）

在书中，Nedry 受到的待遇更值得同情。

> "Nedry got absolutely shafted by Hammond in the book. Nedry describing the difficulty in building a complex system with minimal requirements had me sympathizing, lol." — yoyohello13
> （书中的 Nedry 完全被 Hammond 坑了。当 Nedry 描述如何用最低限度的需求构建复杂系统时，我都开始同情他了。）

### Motorola Envoy 的来历

kalleboo 提供了一个有趣的幕后故事：frogdesign 创始人 Hartmut Esslinger 在飞机上偶遇斯皮尔伯格，向他展示了 Envoy 的原型机。电影中出现的那个是原始模型。作者 Sanglard 本人也在评论区回复说："谢谢，我会更新文章！"

> "IMO this is the social internet at its best. Pretty obscure question answered relatively quickly with answer and source." — ronbenton
> （这就是社交互联网最好的状态。一个相当冷门的问题，很快得到了答案和出处。）

这引发了关于 AI 对社交互联网影响的子话题：

> "AI immediately gives me the same answer. I can't tell if I like this easy access to detail or lament the growing irrelevance of 'social internet' for these kinds of things." — Waterluvian
> （AI 立即给出了同样的答案。我说不清是喜欢这种获取细节的便利，还是为"社交互联网"在这类事情上逐渐失去意义而惋惜。）

## 典型观点一览

| 立场 | 用户 | 一句话 |
|------|------|--------|
| 这一配置合理 | pishpash | Mac + SGI 在 90 年代科学实验室是常见组合 |
| 为了拍电影而已 | dmurray | 制片方本身在用 SGI 渲染恐龙，顺手拿来当道具 |
| SGI 的失败是必然 | ColdStream | 整机高利润率蒙蔽了他们对行业变化的判断 |
| Crichton 是预言家 | yoyohello13 | 把遗传学换成 AI，他的警告在今天同样成立 |
| Nedry 值得同情 | SyzygyRhythm | 用硬件补偿程序员是经典套路，只是这次没奏效 |
| 社交互联网的巅峰 | ronbenton | 冷门问题被快速回答并附上出处 |

## 总体情绪

HN 社区对这帖子的反应可以用"怀旧 + 技术考据狂喜"来概括。评论区充满了对 90 年代计算机生态的深度回忆——从 PowerBook 100 的无源矩阵屏幕到 SGI 的 IRIX 操作系统，从 Amiga 的 interlaced 视频到 OS/2 的多任务稳定性。几乎没有争议性争论，更多的是"我记得那台机器"式的集体怀旧。

但在幽默的表层下，几条更深层的线索浮出水面：Crichton 三十年前对技术失控的警告在 AI 时代显得格外贴切；SGI 从巅峰到消亡的故事成为今天科技巨头的前车之鉴；而"用昂贵硬件补偿程序员"的文化实践，在远程工作和云计算时代已经几乎绝迹。

正如一位评论者所说——"这部电影最科幻的部分不是恐龙，而是他们以为可以控制一切。"

## 引用帖子

| # | 标题 | URL |
|---|------|-----|
| 1 | Jurassic Park computers in excruciating detail | https://news.ycombinator.com/item?id=48915709 |

<div class="disclaimer">
  本摘要基于 Hacker News 讨论串（ID: 48915709）编写，引文版权归原作者所有。摘要内容旨在提供信息概览，不反映本网站立场。
  <br><br>
  <em>本摘要由 AI 模型辅助生成：deepseek/deepseek-v4-flash</em>
</div>
