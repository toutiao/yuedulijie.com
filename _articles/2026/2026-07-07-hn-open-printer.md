---
layout: post
title: "OpenPrinter — 开源打印机的理想与现实"
date: 2026-07-07
categories: [articles]
excerpt: >-
  一款完全开源的可修复喷墨打印机在 HN 获得 1100+ 票。评论者深入讨论了喷墨打印的技术难度、专利陷阱，以及"开源"硬件到底能有多开放。
tagline: >-
  打印机界的 Raspberry Pi：1100 票 HN 热议，使用 HP 墨盒的开源打印机，究竟是真创新还是营销噱头？
---

OpenPrinter 是一款号称**完全开源、可修复、可持续**的喷墨打印机，由法国团队 Open Tools 开发。它使用 HP 63/302/803 系列墨盒（内含打印头），支持 A4/A3 纸张和卷纸，内置切割器，配备 Raspberry Pi Zero W 作为主控板。众筹页面在 Crowd Supply 上，目标用户是厌倦了打印机厂商 DRM 锁定和高昂耗材的技术爱好者。

项目发布后迅速冲上 HN 首页 (/news)，获得 1100+ 票。评论区展开了激烈辩论：喷墨打印是否真的能开源？使用 HP 墨盒还算"开源"吗？CC BY-NC-SA 许可证算不算真正的开源？

## 喷墨打印的工程难度：为什么没人做过

> "Inkjet printing requires orders of magnitude more engineering expertise, materials science, industry experience and financial resources than most people imagine. That is the reason, open inkjet printers don't exist despite having been consumer products with the same drawbacks for more than forty years." — HelloUsername
> （喷墨打印需要的工程专业能力、材料科学、行业经验和资金远超出大多数人的想象。这就是为什么开源喷墨打印机不存在——尽管它作为消费产品存在了四十多年，槽点也四十多年没变。）

HelloUsername 的长篇评论成为讨论的起点。他指出，喷墨打印机本质上是运行在化学、流体力学和机电设计边界上的机器：把微小液滴精准喷射到普通木浆纸上，在任意环境条件下让墨水干燥（但不在墨盒和喷嘴内干燥），还要兼顾色彩、耐久性和易用性。再加上专利壁垒，几乎没有从头自研的可能。

> "An inkjet printer is not a collection of off the shelf parts. It is a machine that operates at the edge of chemistry, fluid dynamics, and electro-mechanical design." — HelloUsername
> （喷墨打印机不是一堆现成零件的组合。它是一台在化学、流体力学和机电设计边界上运行的机器。）

不过也有评论认为这种说法过于耸人听闻。rubidium 反驳说 99% 的技术门槛在于打印头和墨水配方，只要使用现成的商用方案就能绕开。hn_throwaway_99 进一步类比："这就像说不能自己组装 PC，因为造现代芯片的光刻技术极其复杂——问题是你本来就没打算自己造芯片。"

> "It would be like arguing you can't build your own PC because the lithography tech needed to make modern ICs is really complicated." — hn_throwaway_99
> （这就好比说不能自己装电脑，因为制造现代芯片的光刻技术太复杂了。）

jnaina 补了一刀："我正准备装一台游戏 PC，然后想起来 ASML 的光刻机要 200 亿。等降到几千块再说吧。"

GuB-42 提供了另一个视角：去 AliExpress 搜一下消费级喷墨打印机，搜不到——能找到的都是贴牌 HP 或 Canon。中国供应链能仿制一切，唯独造不出喷墨打印机，这本身就说明问题。

> "If the Chinese, who are known for being able to make knockoffs of everything are not able to make inkjet printers, this should tell you how hard it is." — GuB-42
> （如果以仿制著称的中国都造不出喷墨打印机，这说明它有多难。）

除了打印头，走纸机构同样不简单。GuB-42 指出 OpenPrinter 使用单张进纸和卷纸来规避这个难题。

## 打印头背后的诡异数字协议

> "The cartridge heads have a super curious digital protocol - the cartridge electronics have no power supply. There is no power rail internally either." — londons_explore
> （墨盒打印头有一个极其诡异的数字协议——墨盒电子部分根本没有电源，内部也没有电源轨。）

londons_explore 详细解释了 HP 打印头的底层工作原理：利用 MOSFET 栅极电容存储 1 bit 信息，数百个 MOSFET 组成网络，通过"点火"脉冲在微秒级加热喷嘴，让墨水沸腾产生压力波，将墨滴射向纸张。每个喷嘴每秒可工作约 10000 次，精度惊人。他推测这是因为制造喷嘴的定制硅工艺只支持 n 型 MOSFET，无法构成标准的推挽逻辑门。

> "Through a network of hundreds of MOSFETs, the right bits can be put on all the nozzle gates as needed, and then a 'fire' pulse is sent which for around a microsecond turns on a tiny heater... That heating and cooling again can happen around 10,000 times per second per nozzle." — londons_explore
> （通过数百个 MOSFET 组成的网络，正确比特被送入所有喷嘴栅极，然后一个约微秒级的"点火"脉冲启动微型加热器……每个喷嘴每秒可完成约 10000 次加热冷却循环。）

这段技术细节让不少读者大开眼界。hyperbrainer 直接追问："有没有参考文献？"

## 专利雷区和法律风险

> "Impression v. Lexmark is directly relevant to the patent situation here; in a case involving reprogrammed ink cartridges, the Supreme Court held that patent rights are exhausted by first sale doctrine." — bri3d
> （Impression v. Lexmark 案与此直接相关——在涉及改写墨盒的案件中，最高法院判定专利权因首次销售原则而耗尽。）

bri3d 指出最高法院的立场对 OpenPrinter 有利：你卖给我的东西，我不能因为后续使用方式而告你侵权。DMCA 也倾向于允许墨盒兼容工具。但专利方面仍需谨慎——例如墨盒在打印机中的固定方式如果被 HP 申请了专利，就需要仔细审计。

tjohns 则担心 HP 可能会添加 DRM 来验证打印机身份："如果这个项目做大了，HP 完全可以推送固件更新，要求打印机必须通过认证。"

> "It also wouldn't surprise me to see HP add DRM to cartridges to authenticate the printer itself if this catches on." — tjohns
> （如果这个项目火了，HP 在墨盒上增加验证打印机身份的 DRM 我也不会意外。）

londons_explore 补充说这些墨盒自 2004 年发布以来基本没有设计变更——电气接口、机械接口、数字协议都没变。新增的 DRM 芯片是单向的：它阻止原装打印机使用第三方墨盒，但不阻止第三方打印机使用原装墨盒。相关专利可能已过期或即将过期。

不过 alnwlsn 提醒另一个角度：打印头本身就是极度专业的硅芯片，内含微流道、微型加热器等。"要逆向工程和复刻这种东西需要数百万美元，就为了进入一个……卖墨盒的市场？"

## "开源"之名：CC BY-NC-SA 算不算开源？

> "Non commercial licenses are not generally considered open source." — lima
> （非商业许可通常不被认为是开源许可。）

OpenPrinter 采用 CC BY-NC-SA 4.0 许可证，意味着任何人都可以自由使用、分享、修改，但不能用于商业目的，且需要按相同许可证分享衍生作品。这在 HN 上引发了关于"开源"定义的激烈争论。

phoronixrly 表示支持这一选择："我完全欢迎作者的决定！"但更多评论者持批评态度。hannasanarion 一针见血："如果你不能合法使用这个产品，源代码可访问就没有意义。CC-NC 是源代码可用许可，不是开源许可。"

> "If you can't legally use the product, the fact that the source is available is meaningless. CC-NC is a source available license, not an open source license." — hannasanarion
> （如果你不能合法使用产品，源代码可访问就没有意义。CC-NC 是源代码可用许可，不是开源许可。）

wizzwizz4 则从另一个角度辩护：CC BY-NC-SA 在版权法默认的 All Rights Reserved 基础上额外授予了权限，它并不剥夺任何已有权利。"你完全可以照着 All Rights Reserved 的书自己造一台机器。"

讨论了这么多，Sankozi 提出了一个根本性质疑：真的有完全开源的硬件服务器吗？如果几乎所有的计算机都不是完全开源的，我们是不是应该停止使用"开源"这个词？

sehansen 回应说 CC BY-SA 就是真正的开源硬件许可——Arduino 和 Milkymist One 都是例子。

## 激光打印机 vs 喷墨打印机：还有必要搞喷墨吗？

> "It really makes more sense to just buy a laser printer, in almost all cases." — amelius
> （几乎在所有情况下，直接买激光打印机都更有意义。）

这条评论点赞量很高。ocdtrekkie 附和："彩色打印不值那个价。"他的 Brother 黑白激光打印机已经用了十年，只买过一次兼容硒鼓。

hn_throwaway_99 解释了为什么很多人转向激光：家庭用户打印频率极低（可能一个月一次），喷墨墨水在两次使用之间会干涸。"喷墨打印机在你需要它的时候永远不工作"已经成为共识。相比之下，激光打印机随时待命。

> "There is a reason it's such a common trope that inkjets never work right when you need them." — hn_throwaway_99
> （"喷墨打印机在你需要的时候永远不工作"这个梗不是没原因的。）

但 d3Xt3r 指出彩色激光多功能一体机（带自动进稿器）价格是同等喷墨机的 2-3 倍，体积也大得多。对于偶尔需要彩色打印的家庭用户，喷墨仍然更经济。

## 典型观点一览

| 立场 | 用户 | 一句话 |
|------|------|--------|
| 技术悲观 | HelloUsername | 喷墨打印的工程难度远超想象，这是开源打印机从未成功的原因 |
| 技术务实 | rubidium | 打印头和墨水配方可以用现成的，难点是固件和软件锁 |
| 专利乐观 | bri3d | Impression v. Lexmark 案确立了首次销售原则，专利方面有判例支持 |
| 专利悲观 | alnwlsn | 打印头是定制硅芯片，逆向工程成本数百万美元 |
| 定义之争 | hannasanarion | CC BY-NC-SA 不是开源许可，而是源代码可用许可 |
| 实用主义 | amelius | 大多数情况下买激光打印机都比搞开源喷墨更有意义 |
| 环保视角 | WhyNotHugo | 针式打印机才是真正可持续的选择，耗材便宜、污染少 |
| 市场观察 | GuB-42 | 中国供应链都做不出消费级喷墨打印机，说明门槛之高 |

## 总体情绪

HN 对 OpenPrinter 的态度可以用"谨慎乐观但存疑"来概括。一方面，1100+ 票表明技术社区对开源硬件打印机有着强烈的渴求——谁没被 HP 的 DRM 和天价墨盒坑过？另一方面，评论区对这个项目的可行性、开源纯粹性和商业可持续性提出了大量尖锐问题。

最有意思的矛盾在于：OpenPrinter 想打破打印机厂商的垄断，却不得不依赖 HP 的墨盒（因为全球只有 HP/Canon 的能量产打印头）。它使用 CC BY-NC-SA 许可证，却在宣传中称自己"开源"——对于 OSI 正统派来说，这是不可接受的。它想降低打印成本，但激光打印机在大多数场景下已经更便宜、更可靠。

不过，正如 londons_explore 所说，那些墨盒的接口自 2004 年就没变过。如果 OpenPrinter 能活下来，也许十年后我们真的能看到一个不需要担心固件更新废掉第三方墨盒的打印机。前提是——它能先造出来。

## 引用帖子

| # | 标题 | URL |
|---|------|-----|
| 1 | OpenPrinter | https://news.ycombinator.com/item?id=48797916 |
| 2 | Crowd Supply 众筹页面 | https://www.crowdsupply.com/open-tools/open-printer |
| 3 | 项目官网 | https://www.opentools.studio/ |

<div class="disclaimer">
本文基于 HN 讨论撰写，不代表本网站立场。内容可能存在翻译和理解偏差，引用原文仅供参考。
<br><br><em>本摘要由 AI 模型辅助生成：deepseek/deepseek-v4-flash</em>
</div>
