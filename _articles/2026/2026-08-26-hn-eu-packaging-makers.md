---
layout: post
title: >-
  欧盟新包装法规扼杀小制造商 — HN 讨论摘要
date: 2026-08-26
categories: [articles]
excerpt: >-
  半公斤包装的环境税该按"分"算，管它的官僚成本却要按"千欧"算。一位希腊工程师一年卖 10 块 25 欧的电路板，光合规就要先缴 1150 欧。
tagline: >-
  卖 10 块 25 欧的板子，先交 1150 欧的合规税。
---

## 原文概要

一个 1600 多分的帖子本周刷上 HN 热门榜：开源硬件市场 Lectronz 的创始人 Alain Pannetrat 发文控诉，欧盟新的《包装和包装废弃物法规》（PPWR，2026 年 8 月 12 日起生效）正在扼杀 maker 和小微创业者。Lectronz 专门服务开源硬件和 DIY 电子卖家——不是工厂，也不是有融资的初创，而是躲在备用房间、车库和小工坊里的工程师和独立设计师。

文章用一位希腊工程师的例子算了一笔账。他设计了 25 欧的开源传感器板，第一年卖出 5 块到德国、2 块到法国、2 块到奥地利、1 块到比利时，每单只产生约 50 克包装。按新规，他瞬间成了四个国家的"包装废弃物生产者"，必须在每个国家单独注册、报备、缴管理费。法国一年 110 欧注册费加 190–300 欧授权代表费；比利时 50–100 欧加 250–450 欧；德国免费注册但要 10 欧入会加约 190 欧代表费；奥地利 250 欧加 100 欧。四国合计，乐观情况下一年就要 1150 欧。

作者点破了这个荒诞："半公斤包装对应的环境贡献应该用分来计算，而核算它的官僚成本要用千欧来计算。"更离谱的是，欧盟本意是统一规则，PPWR 却保留了碎片化的国别体系——想覆盖全部 27 个成员国，这位工程师从一开始就得每年卖几千块板子。

在作者看来，这是"温柔的创新扼杀"。Lectronz 上过去一年一半卖家订单不到 10 单，许多 maker 只做 10 块板子分给社区，不求赚钱。而平台的现实同样残酷：抽成 5%、前五单免费，辛苦多年后整个平台的营收"约等于一份普通薪水"。作者给出的药方是：设立全欧统一的 `de minimis` 门槛、建一个欧盟 EPR 一站式门户（模仿增值税的 OSS）、让市场平台代表卖家集体申报。他还提到欧盟委员会已提议把"目的地国授权代表"要求暂缓到 2035 年，但尚未通过。

## 讨论焦点

### 灰色现实：反正没人查，干脆不注册

评论区第一波现实主义者认为，法规最终只会被 maker 们集体无视：

> "I imagine what will happen in practice is that the makers will simply ignore the law and hope not to get prosecuted or audited?" — tdeck

> （我想实际发生的是：maker 们干脆无视法律，赌自己不会被起诉或审计。）

荷兰创业者 anonzzzies 用 35 年从业经验背书：

> "Yeah, I always ignore them, first in my own country (NL) and after that in EU. Even if they fine (which they don't for small companies/persons), they will not spend money/efforts to cash the fine anyway, especially across borders. I had a few useless fines in the 35 years of my company, never will pay them." — anonzzzies

> （没错，我从来都是无视它们，先在自己国家荷兰，然后整个欧盟。就算他们罚款——小公司或个人他们根本不罚——跨境的罚款他们也不会花钱去追。开公司 35 年我收过几张没用的罚单，一次都没付过。）

matt-p 泼了盆冷水：人人无视只会让选择性执法成为常态，那才是更严重的问题。

### 真实代价：为了躲 5000 欧罚单，干脆不发货

也有 maker 表示自己已经被吓住，直接改掉了行为：

> "This is actively preventing me from sending packages to other countries as a maker. No matter how small the risk is, I don't want to risk a 5000 euro fine for sending a small amount of packages to other EU countries." — Robin_f

> （作为 maker，这正在实打实地阻止我向其他国家发货。不管风险多小，我都不想为了往别的欧盟国家寄几包东西去冒 5000 欧的罚款。）

dgellow 的回应更直接——"整个法规落地是一团乱麻，领导层该为此下台"。

### 历史先例：增值税当年也这么乱，后来一个系统解决

多位评论者指出，欧盟不是第一次踩这个坑，增值税当年几乎一模一样：

> "The EU did the same with VAT previously, where you'd have to register separate businesses in different countries, once you got large enough (which wasn't very large). Now there's a central system to keep track of what goes where and you can sell internally in the EU with no issues. Something similar needs to happen here, where business report and pay to a central EU system, that then transfers the funds to each country." — mrweasel

> （欧盟当年对增值税也干过同样的事：一旦你的体量够大——其实也大不到哪去——就得到不同国家分别注册公司。现在有了中央系统跟踪货物去向，你在欧盟内部卖东西毫无障碍。这里也需要类似的方案。）

jeltz 直言当年那些抱怨 VAT MOSS 的人是"蠢蛋"，这套东西实现起来很简单。

### 反方：这法规是冲着 Temu 和 SHEIN 去的

也有评论者指出，作者可能只看到了自己的利益。alephnerd 认为 EPR 和 `de minimis` 收紧是一体两面，目标根本不是小 maker：

> "The de minimis crackdown and EPR are both being rolled out because Chinese conglomerates like Pinduoduo (Temu) and SHEIN took undue advantage of that while ignoring European regulators on issues such as environmental regulations on packaging, dark patterns, breaching the Digital Services Act, and gacha/addictive engagement mechanisms." — alephnerd

> （`de minimis` 收紧和 EPR 都是因为拼多多（Temu）、SHEIN 这类中国巨头滥用了免税额度，同时无视欧盟监管——包括包装环保法规、暗黑模式、违反《数字服务法》、以及抽卡式的成瘾机制。）

他的结语扎心：欧洲 HN 用户"从来都欢迎欧盟监管，直到它伤到自己的小众利益或钱包"。

### "设计如此"：富人本来就不让你进场

一部分评论者把矛头指向了制度设计本身：

> "This is by design. It's the same all over the world. The wealthy are not going to just let you compete" — greenraven

> （这是设计好的。全世界都一样。有钱人不会让你就这么进场竞争。）

cobbzilla 进一步把逻辑说透：用"善意"的法规绞杀小生意，比直接推翻自由市场容易得多——最终只剩下大公司的裙带寡头。

### 美国也差不多：FCC 认证劝退小硬件商

不少美国读者把话题引到了自家：the__alchemist 认为 PPWR 只是"美国 FCC 规则的翻版"——不是有意的辐射源也得合规，小生意要么不合规要么做不下去。WarmWash 晒出数字：

> "As a hardware guy it totally kills me, to get a fun or needed small time product off the ground and legally onto the market can require ~$250k of lab certifications." — WarmWash

> （作为硬件从业者，这真的会杀了我。要让一个好玩或刚需的小产品合法上市，可能需要约 25 万美元的实验室认证费用。）

## 典型观点一览

| 立场 | 用户 | 一句话 |
|------|------|--------|
| 无视派 | tdeck | 反正没人查，maker 会集体无视法规 |
| 止损派 | Robin_f | 为躲 5000 欧罚款，干脆不发跨境件 |
| 有解派 | mrweasel | 增值税当年也乱过，一个中央系统就搞定 |
| 反方 | alephnerd | 这是冲着滥用 de minimis 的 Temu/SHEIN 去的 |
| 阴谋论 | greenraven | 设计如此，有钱人不会让你进场竞争 |
| 美国对照 | WarmWash | 美国 FCC 认证照样劝退小硬件商 |

## 总体情绪

评论区整体一边倒地同情作者，但理由五花八门。最实用主义的一派相信"灰色绕过"——规则太贵就不守，反正没人查、没人追罚款；最悲观的一派认为这是系统性绞杀，与环保无关，与"谁有资格做生意"有关。中间还夹着一批被点醒的读者：他们要的不是废除 EPR，而是欧盟把当初解决增值税问题的那套中央系统照搬过来。

真正的分歧在反方。alephnerd 把账算到了 Temu 和 SHEIN 头上，认为作者抱怨的前提恰恰是那些中国巨头先钻了空子。但即便反对者也承认，用 1150 欧的合规成本去管 50 克包装，这种失衡本身就在逼 maker 做出最合理的选择——不卖欧盟了。半公斤包装的环境贡献该按分算，管它的官僚成本却按千欧算，这道算术题的答案，其实一开始就写好了。

## 引用帖子

| # | 标题 | URL |
|---|------|-----|
| 1 | How Europe is killing makers and micro-entrepreneurs | https://news.ycombinator.com/item?id=49419237 |

## 免责声明

<div class="disclaimer">
本摘要基于 HN 帖子 "How Europe is killing makers and micro-entrepreneurs" 的讨论整理而成，不代表本网站立场。引文内容版权归原作者所有。
<br><br>
<em>本摘要由 AI 模型辅助生成：deepseek/deepseek-v4-flash</em>
</div>
