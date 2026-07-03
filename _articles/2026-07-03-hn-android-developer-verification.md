---
layout: post
title: "Android Developer Verification — HN discussion digest"
date: 2026-07-03
categories: [articles]
excerpt: "F-Droid 将 Google 的 Android Developer Verification 称为"恶意软件"——一个拥有 root 权限、无法卸载、通过 Play Protect 传播的系统进程。HN 社区展开激烈辩论：这是合理的反垄断担忧，还是对安全措施的过度反应？"
tagline: "Google 在 40 亿台设备上预装了一个"恶意软件"——F-Droid 说这是字面意思。"
---

## 原文概要

F-Droid 发表了一篇措辞激烈的文章，将 Google 新推出的 Android Developer Verification（ADV）项目称为"恶意软件"。据文章描述，ADV 进程以系统服务身份运行，拥有完整 root 权限，无法被阻止、禁用或移除，且通过 Play Protect 传播和安装。该进程的唯一目标：阻止用户运行未经 Google 中央批准的开发者所编写的软件。

F-Droid 早在 2025 年 9 月就对 ADV 提出过警告。他们认为 Google 以"遏制恶意软件"为名，实际上是在建立一个封闭的围墙花园。更令人担忧的是，ADV 的服务条款中并未明确定义"恶意软件"——这意味着 Google 可以单方面决定什么是"恶意软件"。文章以广告屏蔽软件被 Play Store 封禁为例，暗示 Google 可能利用这一权力排除商业竞争对手。该讨论源自 HN 热门榜（/best），获得了 1586 分和 680+ 条评论。

## 讨论焦点

### 滑坡谬误还是合理担忧？

社区对 ADV 的最终走向存在根本分歧。有用户认为这是经典的滑坡谬误：

> "History shows that when a 'slope' appears... regulation steps in, technology evolves to solve the problem, or the culture shifts to reinterpret the thing. In almost every case, the feared 'bottom' of the slope was never reached because humans constantly built ramps or bridges along the way." — ranger_danger
> （历史表明，当"滑坡"出现时，监管会介入、技术会进化、文化会重新诠释。大多数情况下，人们担心的"谷底"从未到达，因为人类沿途不断修建了坡道或桥梁。）

但更多评论者对此持怀疑态度：

> "I don't know which timeline you live in, but in mine I've stopped counting how many slippery slopes ended up exactly where the critics said they would." — int_19h
> （我不知道你生活在哪个时间线，但在我这里，滑坡最终滑到了批评者预测的位置，我已经数不清有多少次了。）

> "Just look at the world around you, the slippery slope 'fallacy' stopped being a fallacy long ago." — loconut
> （看看你周围的世界，滑坡"谬误"早就不是谬误了。）

有用户指出，Google 在 Chrome 平台上已有先例：

> "There is precedent of Google making changes in light of 'security' that break ad blocking Chrome extensions. See Chrome extension manifest 3. So this concern cannot be dismissed with just 'slippery slope fallacy', it's a new vector of the same power grab strategy." — aerzen
> （Google 以"安全"为名做出的改变有先例可循——Chrome 扩展 Manifest V3 就破坏了广告屏蔽扩展。这个担忧不能简单地用"滑坡谬误"打发，这是同一权力攫取策略的新载体。）

### 围墙花园之争：Google vs Apple

大量评论将 Google 的新政策与 Apple 的生态系统进行比较：

> "Isn't Google going to do what Apple has been doing since forever? Or is Google somehow doing something worse?" — stingraycharles
> （Google 难道不是要做 Apple 一直以来的事情吗？还是 Google 的做法更糟糕？）

> "Apple's policies were established when you purchased the phone. Apps come through registered developers and their vetting. Google has changed the game on something you already own. I'm sure their lawyers have done their homework, but in some jurisdictions this is certainly actionable." — jb282
> （Apple 的政策在购买手机时就已确立。Google 改变的是你已经拥有的设备上的规则。我确信他们的律师做了功课，但在某些司法管辖区，这绝对是可诉的。）

一位评论者从商业角度给出了冷峻的分析：

> "Google had an open (but maybe not perfectly open) platform and is paying out billions in anti-competitive fines because of it. None of the other platform vendors with totally closed platforms are paying out anything. So with even a room temperature business IQ, it's pretty clear that closed platforms are the best way to do business, and court rulings in both the US and EU have affirmed this multiple times over the last decade." — WarmWash
> （Google 有一个开放的平台，因此支付了数十亿美元的反垄断罚款。而所有完全封闭的平台厂商没有支付任何罚款。所以只要有室温水平的商业智商，显然封闭平台是最好的商业模式，过去十年美国和欧盟的法院判决多次确认了这一点。）

### EU DMA 的争议

多位用户质疑 ADV 在欧盟数字市场法案（DMA）下的合法性：

> "I don't understand how this is legal in the EU under the DMA, does anyone know?" — stavros
> （我不明白这在欧盟 DMA 下如何合法，有人知道吗？）

> "I already contacted the DMA authorities and complained how this has an effect on German diabetes communities and they replied that I am not the first one who approaches them on this and they are already investigating it. Google is just trying how far they can push this." — pimeys
> （我已经联系了 DMA 监管机构，投诉这如何影响到德国的糖尿病社区。他们回复说我不是第一个找他们谈此事的，他们已经在调查了。Google 只是在试探他们的底线。）

也有用户提交了正式的 DMA 投诉：

> "FWIW, I submitted an EU DMA complaint (Art 27 report) against Alphabet for unfair gatekeeping against third-party distributions like GrapheneOS via Play Integrity." — AlexAltea
> （我提交了一份 EU DMA 投诉，针对 Alphabet 通过 Play Integrity 对 GrapheneOS 等第三方发行版的不公平把关行为。）

不过也有评论者对 DMA 路径持悲观态度：

> "Since Apple's App Store is DMA compliant, the EU won't do anything against this far less restrictive change from Google." — kodebach
> （既然 Apple 的 App Store 被认定为符合 DMA，欧盟就不会对 Google 这个限制性远低于 Apple 的变更采取任何行动。）

### 替代方案与系统绑定困境

讨论延伸到使用 GrapheneOS 等替代方案的可能性，但遇到了现实问题：

> "Problem is that all banks require a national centralized controlled service for login (BankID in Norway). And it is this service that I cannot get to work running GrapheneOS." — kalx
> （问题在于所有银行都需要国家统一控制的登录服务——挪威的 BankID。而正是这项服务在 GrapheneOS 上无法使用。）

一位用户对这一系统性风险发出了深刻警告：

> "But just the thought of the potential to be completely locked out of everything from banks to online payments, logins to the public health system, tax filings (and basically all public sector services) just at the whim of Google or Apple's automated algorithms misunderstanding some random account activity, is a thought that should make everyone afraid." — edb_123
> （仅仅想到这样一个可能性——因为 Google 或 Apple 的自动化算法误解了某个随机的账户活动，你就可能被完全锁定，无法使用银行、在线支付、公共医疗系统登录、税务申报和几乎所有公共服务——这个想法就应该让所有人感到恐惧。）

他提出了包括正当程序、问责机制、多次警告、有效的投诉程序等一套最低权利保障要求。

## 典型观点一览

| 立场 | 用户 | 一句话 |
|------|------|--------|
| ADV 是必要的安全保障 | ranger_danger | 滑坡谬误，历史表明人类会在半途修建"桥梁" |
| 滑坡已多次应验 | int_19h / loconut / aerzen | Manifest V3 就是先例，这不是谬误而是模式 |
| Apple 也在做同样的事 | stingraycharles | Google 不过是追赶 Apple 的围墙花园而已 |
| 规则变更的性质不同 | jb282 | Apple 的政策在购买时就确立，Google 改变了已成事实的规则 |
| AD V 违反 EU DMA | pimeys / AlexAltea | 已向 DMA 机构投诉，对方正在调查 |
| 封闭平台才是商业最优解 | WarmWash | 开放平台被罚数十亿，封闭平台分文未付 |
| 替代方案不现实 | kalx | GrapheneOS 无法使用挪威 BankID 等关键服务 |
| 系统性风险不可接受 | edb_123 | 数字生活完全依赖两家公司的算法，缺乏正当程序保障 |

## 总体情绪

HN 社区对 ADV 的反对声音占据压倒性多数，但反对的理由和程度各不相同。一部分评论者从技术角度分析，认为 ADV 确实可能提高安全基线，尽管方式粗暴。另一部分人从反垄断和消费者权利角度出发，认为这是 Google 在 EU 罚款压力下的战略转向——既然开放平台被罚，不如干脆学习 Apple 的封闭模式。最尖锐的批评来自那些已经依赖 GrapheneOS 等替代方案的用户——他们发现即使切换到开源系统，也无法摆脱对 Google/Apple 基础设施的现实依赖，尤其是在北欧国家银行系统深度绑定平台厂商的情况下。

整体而言，讨论走向了一个更广泛的命题：当智能手机成为公民生活的必需基础设施，平台厂商的权力边界应该在哪里？

## 引用帖子

| # | 标题 | URL |
|---|------|-----|
| 1 | What We Talk About When We Talk About Malware | https://f-droid.org/2026/07/01/adv-malware.html |

<div class="disclaimer">
本摘要基于 Hacker News 讨论帖（ID: 48755965）编写，引文版权归原作者所有。摘要由 AI 模型辅助生成：deepseek/deepseek-v4-flash。
</div>
