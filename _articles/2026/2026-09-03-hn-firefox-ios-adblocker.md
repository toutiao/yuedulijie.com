---
layout: post
title: >-
  别把 Firefox 和洗澡水一起倒掉 — HN 讨论摘要
date: 2026-09-03
categories: [articles]
excerpt: >-
  为 Firefox 辩护的短文拿下 938 分：一边是"全平台 3% 的份额算不上误差"的辩护，一边是"RAM 吃到吐、阅读模式时灵时不灵"的吐槽。同一天 Mozilla 宣布 iOS 广告拦截器，却因为渐进式推送，让多数用户觉得自己被"煤气灯"了。
tagline: >-
  广告拦截器上了新闻头条，却没上你的手机。
---

## 原文概要

8 月 31 日，博客 Newsonaut 发了篇短文《Hang on to your Firefox!》，9 月 1 日登上 HN 热门榜（/best），拿下 938 分、约 478 条评论。作者从一句德国谚语切入——"别把婴儿和洗澡水一起倒掉"，德语地区 1512 年就有类似说法，人要学会在丢掉小烦恼时别把要紧的东西也扔了。

他引的例子是：一位高产博主因为"Firefox 入驻了 X"就弃用 Firefox 改用 Vivaldi。作者觉得这说不通——Vivaldi 同样在 X 上，背后还有 Meta 的 Threads、Facebook、Instagram 和谷歌的 YouTube。他真正的论点是：Firefox 是浏览器引擎多元化的"最后希望"。没有它，全世界就只剩 Chrome 及其派生品（包括 Vivaldi），Safari 之所以还在，只是因为它被 iPhone 强设为默认。

作者推测 Firefox 上 X 是为了拉新用户——按 StatCounter 的口径，Firefox 的全球份额小且在持续下滑，"而你需要拼命帮他们"。文末还附了 Mozilla 今年 3 月一篇网权文章的链接，标题叫《Competition, Innovation, and the Future of the Web》。

同一天稍早，Mozilla 官方博客宣布了 iOS 版 Firefox 的原生广告拦截器 "Ad Blocker for Firefox on iOS"（HN 571 分、约 172 条评论）。功能是实验性的，靠渐进式推送逐步放量，默认关闭；官方 FAQ 明确说搜索页广告不会被拦，也不影响 Firefox 自己在新标签页里的赞助内容。两个帖子都在吵 Firefox：一个喊"留住它"，一个问"为什么我的手机上还没有它"。本篇为 cluster 模式，主帖为辩护短文（thread 1），iOS 广告拦截公告为相关帖（thread 2）。

## 讨论焦点

### 还有人在乎吗：垄断共识与 "3% 不算误差"

楼里最早被点起来的问题很丧气：普通用户真的在乎浏览器是不是被垄断吗？最冷的回答来自 palata：

> "People just don't care. They are happy with monopolies and surveillance capitalism. Once in a while someone talks about digital sovereignty, but much like climate change, nothing will be done (successfully) about it. That's how it is, I've come to terms with it." — palata

> （"人们就是不在乎。他们安于垄断和监控资本主义。偶尔有人谈起数字主权，但就像气候变化一样，到头来什么（有效地）都不会做。事情就是这样，我已经认了。"）

nickthegreek 立刻用数据反驳——用 Firefox 的人，比你想象的要多：

> "Well I would say that the firefox userbase is 3%+ across all platforms (over 7% on desktop) and that is larger than a rounding error." — nickthegreek

> （"我觉得 Firefox 用户群在全平台有 3% 以上（桌面端超过 7%），这可比'四舍五入的误差'大多了。"）

还有人顺着 palata 的话补了刀：对多数普通人来说，"不关心这些"恰恰是别人平台的卖点：

> "Actually I believe for most normal people it is a feature of other platforms that they don't have to appear to be associated with weirdos who use terms like 'surveillance capitalism'." — jeffbee

> （"其实对多数普通人来说，这正是其他平台的卖点——用那些平台，就不必显得跟满口'surveillance capitalism'的怪人是一伙的。"）

nickthegreek 在后面还有一句更实操的建议：与其在论坛上吵，不如给不懂技术的朋友装好 Firefox 和 uBO，"be the change you want to see"（想看到什么样的世界，就先成为那样的改变）。

### 想留也难：RAM、GC 与一台 13 年老 ThinkPad

真正的劝退理由往往不在理想层面，而在体感。theamk 的抱怨最典型——想留，但留得难受：

> "I am using firefox, but it is pretty hard to keep using it. I don't want the whole world to converge on one browser engine, but I also want things to work, and Firefox does not make it easy. Firefox on my laptop has a propensity for eating lots of RAM, and constant CPU usage, even if nothing is going on. Task manager is useless. Profiler just shows 'GC collecting'." — theamk

> （"我在用 Firefox，但坚持用下去挺难的。我不希望整个世界收敛到同一个浏览器引擎上，可我也想让东西能正常工作，而 Firefox 在这方面并不省心。我的笔记本上 Firefox 很能吃内存，哪怕什么都不干也持续占 CPU。任务管理器看不出名堂，性能剖析里只有一行'GC collecting'（垃圾回收中）。"）

glaucon 给出了完全相反的样本，提醒准备换浏览器的读者"体感因人而异"：

> "I don't know why but I have a different experience. My daily driver is a 13 year old Thinkpad with 16Gb memory, I use Firefox all the time, I routinely have 50+ tabs open, I really have no complaints. I also use Firefox on Android, I have less experience of using other browsers on mobile but what I've got is fine for me. I'm not questioning your experience but I would like others, who might be considering using Firefox, to know that different people have different experiences." — glaucon

> （"不知道为什么，我的体验不一样。我的主力机是一台 13 年的 ThinkPad、16GB 内存，一直用 Firefox，常开 50 多个标签页，真没什么可抱怨的。我也在 Android 上用 Firefox，别的手机浏览器用得少，手头这个对我来说够用。我不是质疑你的体验，只是想让正在考虑换浏览器的人知道，不同人的体验差别很大。"）

### 囤标签的人：书签 UI 才是原罪

内存话题很快歪成"你为什么攒几百个标签"的坦白大会。cosmic_cheese 的解释代表了一大批人——不是懒，是书签难用：

> "I'm around middle age and keep tons of tabs open simply because I have a number of projects/tasks or soon-to-be projects/tasks going at any given point and managing associated websites is easier with tabs than it is with bookmarks. In other words, bookmark management UI/UX is inadequate and tab hoarding is the band-aid. There's also a higher chance that things will slip through the cracks and be forgotten if I bookmark them, whereas with tabs they're staring me in the face any time I'm using my computer." — cosmic_cheese

> （"我人到中年还攒着一堆标签，只是因为我手头总有好几个进行中或即将开始的项目，用标签管理相关网站比书签容易。换句话说，书签的管理 UI/UX 不够用，囤标签只是贴上去的创可贴。而且收藏进书签的东西更容易被漏掉、被忘掉；开着标签，每次开电脑它们就杵在你眼前。"）

yencabulator 在此基础上抛出一个热论：书签和开着的标签根本是同一种东西，浏览器把它们分开管理是设计错误：

> "My hot take: there are two kinds of bookmarks. 1. shortcuts to get to common sites and 2. stuff i need to get back to. And it's a UX mistake to keep #2 separate from open tabs; they are the same thing." — yencabulator

> （"我的暴论：书签有两种。一是常用网站的快捷方式，二是'我还要回去看的东西'。把第二种和打开的标签分开管理，是 UX 上的错误——它俩本来就是一回事。"）

### 衰退怪谁：Google、ToS 还是"租不如买"

为什么 Firefox 会跌到今天这个份额，是这帖里最分裂的争论。有人把责任归给那个最大的对手：soperj 说 Firefox 不是输在技术，是输在正面撞上了全球最大广告主 + 全球最大搜索引擎的组合拳：

> "They were competing with the biggest advertiser in the world who put an ad about their own browser on the front page of the biggest search engine in the world. Not sure it was entirely their own doing." — soperj

> （"他们的对手是全球最大的广告主，而这广告主还把自己的浏览器广告放到了全球最大搜索引擎的首页上。我不确定这完全是 Firefox 自己的问题。"）

也有一派认为"用户被 ToS 气走"只是自我安慰——那批在乎条款的人本来就是少数：

> "It's not 'us' that matters, assuming that means very on-the-pulse power user types. We're a tiny fraction of users. Over 99% of users have probably never even spared a thought for the ToS." — broodbucket

> （"关键在于从来不是'我们'——如果'我们'指那些非常紧跟潮流的重度用户的话。我们只是极小一部分人。超过 99% 的用户大概从没为条款费过一丝心。"）

TimTheTinker 则给出一个有点残酷的心理学解释：人们不会爱上租来的房子，可房东照样赢：

> "Part of it is the psychology of owning vs renting. No one loves a rented house, but the landlord still wins." — TimTheTinker

> （"一部分原因是'拥有'和'租用'的心理差异。没人会爱上一栋租来的房子，但房东照样赢。"）

### 引擎孤岛：Ladybird、Servo 和"不会再有的新引擎"

支持 Firefox 最硬的理由是引擎多样性，可悲观者直接指出：这艘孤岛正在下沉，而且不太可能再有新的岛。senfiaj 的理由是现实门槛太高：

> "Yeah, and when you think about the insane complexity of Web standards, and the fact that even Microsoft failed to create a browser with an independent engine, we are very unlikely to see a new browser engine." — senfiaj

> （"没错，想想 Web 标准那离谱的复杂度，再看看连微软都没能做出一个独立引擎的浏览器，我们几乎不可能再见到新的浏览器引擎了。"）

有人提起正在推进的独立引擎项目 Ladybird 和 Servo，立刻被泼了冷水。cyberax 对 Ladybird 的代码质量不抱希望：

> "The last time I checked the source code, it was filled with horrible unsafe C++. They also re-implement everything whether it is needed or not." — cyberax

> （"我上次看它的源码，里面全是可怕的不安全 C++。他们还不管需不需要，什么都自己重新造一遍。"）

而 strenholme 的态度更简单：等出了正式版再说：

> "I will believe it when I see it. Still no public release." — strenholme

> （"眼见为实。连公开版本都还没有。"）

### iOS 广告拦截：宣布了，但你的手机上还没有 [thread 2]

如果说 thread 1 在讨论"要不要留住 Firefox"，thread 2 的现场则有点尴尬：Mozilla 用一场发布会宣布了一个多数用户根本用不上的功能。WD-42 等的就是它：

> "It's been days (weeks?) and I'm still waiting for the option to appear for me. These 'experiments' are super annoying when you are on what I'm assuming is the long tail of a rollout but the marketing/blog posts speak of the feature like it's already launched. If there's someone at Mozilla reading this: turn it on already! I want to get off Orion, it's so buggy, but the internet is unusable without an ad blocker." — WD-42

> （"都过去好几天（几周？）了，我还在等这个选项出现在我面前。这种'实验'真的很烦人——你被丢在推送的长尾里，而营销文和博客却说得像功能已经上线了似的。如果有 Mozilla 的人在看：赶紧给我开！我想逃离 Orion，它 bug 太多，可没有广告拦截器这网就没法用。"）

yboris 用了更重的词：gaslighting（煤气灯效应）——你把锅端出来说开饭了，结果只有不到四成客人分到了盘子：

> "Deeply frustrating - I felt like Mozilla was gaslighting me -- I spent 3 minutes double-checking that even after updating Firefox minutes ago the option is still not visible to me. Making an announcement when fewer than 40% of your customers will see the feature fees like (unintentional) gaslighting." — yboris

> （"极其沮丧——我觉得 Mozilla 在跟我玩煤气灯：我花了三分钟反复确认，明明几分钟前刚更新过，这个选项就是不出现。在只有不到 40% 的客户能看到功能时就发公告，感觉就像（无意的）煤气灯。"）

更讽刺的是 KORraN：他两周前明明用上过，几天后选项自己消失了——不是没排到他，是给了又收回去：

> "Even worse, two weeks back when the first news appeared (https://news.ycombinator.com/item?id=49319633), I had access to the ad blocker for about a week (and turned it on), but after a few days the option disappeared..." — KORraN

> （"更糟的是，两周前消息刚出来时，我一度能用这个广告拦截器（还打开了），可没几天选项就消失了……"）

### 广告里的禁区：YouTube 与 Google 的钱 [thread 2]

这条广告拦截器有一条明确的红线：YouTube 广告。cedws 在楼里问"能不能拦 YouTube 广告"，有人直接点破原因——那不是技术问题，是钱的问题：

> "Google will stop paying them if they tried that." — quaintdev

> （"他们要敢那么干，Google 就不给他们钱了。"）

lern_too_spel 随即指出一个微妙的对照：Firefox 在 Android 上靠 uBlock Origin 拦了 YouTube 广告好几年，Google 的钱照样付——因为那是用户的扩展装的，不是 Mozilla 官方卖点：

> "Firefox with uBlock Origin has blocked YouTube ads just fine on Android for years, and Google kept paying. uBlock Origin doesn't actually get installed by default on Firefox Mobile, but I'd wager that it effectively does." — lern_too_spel

> （"Firefox 配 uBlock Origin 在 Android 上稳稳拦了 YouTube 广告好几年，Google 照样付钱。uBlock Origin 其实不是 Firefox Mobile 默认安装的，但我敢打赌它'事实上等于'默认装了。"）

搜索广告同样在禁区里。有人问官方 FAQ 里"搜索页广告仍会出现"是技术原因还是商业原因，yapyap 的回答只有一个词：

> "commercial" — yapyap

> （"商业原因。"）

Shank 还补了桌面端的观察——Mozilla 连自家和 Google 的广告都未必想拦，别指望 iOS 版会拦得更狠：

> "No, uBOL blocks more ads and isn't affected by Firefox's insistence to not block Google Ads or their own." — Shank

> （"不，uBOL 拦得更多，而且不受 Firefox 那条'不拦 Google 广告和自家广告'的坚持影响。"）

### 遥测门槛：为"实验室功能"交出你的数据 [thread 2]

另一个劝退点是遥测要求。NikxDa 本来想夸 Mozilla 终于干对了一件事，结果被门槛劝退：

> "I was going to give credit to the direction Mozilla was taking here after their... questionable decisions in the past few year(s). Only to see that this is neither generally available, nor can you use it without enabling telemetry. I don't know who makes these decisions inside Mozilla, but I just don't get it." — NikxDa

> （"在 Mozilla 过去几年那些……可疑的决策之后，我本来想为这个方向点个赞。结果发现它既没有全面开放，不开遥测还用不了。我不知道 Mozilla 内部是谁拍板的，反正我理解不了。"）

mossTechnician 带来了一个更正：从 Firefox 148 起，遥测和这项"远程改进"已经解耦，关遥测也能收：

> "However, as of Firefox version 148, you can opt into receiving remote improvements, even if you have opted out of sharing your telemetry or participating in our experimental studies." — mossTechnician

> （"不过，从 Firefox 版本 148 开始，即使你选择不分享遥测数据、不参与实验研究，也可以选择接收远程改进。"）

顺着这条线，还有用户翻出更早的旧账：Firefox 版本 148 之前，这类功能确实要求分享"技术和交互数据"；有人在 2025 年 2 月 Mozilla 允许"为盈利出售个人数据"的条款变动上打转。为功能解锁数据，还是为数据放弃功能——两条路都不怎么让人舒服。

## 典型观点一览

| 立场 | 用户 | 一句话 |
|------|------|--------|
| 辩护派 | nickthegreek | 全平台 3%、桌面 7%，不是"误差" |
| 认命派 | palata | 没人真在乎，数字主权和气候问题一样不了了之 |
| 实用派 | theamk | 想留它，可 RAM 和 GC 让我留不住 |
| 体感派 | glaucon | 13 年老 ThinkPad 开 50 多个标签也没问题 |
| 归因派 | soperj | 对手是全球最大搜索引擎首页上的广告 |
| 现实派 | broodbucket | 99% 的用户从没想过 ToS |
| 心理派 | TimTheTinker | 没人会爱租来的房子，但房东照样赢 |
| 悲观派 | senfiaj | 微软都造不出新引擎，别指望新孤岛 |
| 审慎派 | strenholme | Ladybird 出了正式版再说 |
| 催促派 | yboris | 只有不到 40% 用户能用就开发布会，像煤气灯 |
| 财政派 | quaintdev | 敢拦 YouTube 广告，Google 就不付钱了 |
| 数据派 | NikxDa | 开个实验室功能还要开遥测，理解不了 |

## 总体情绪

两个帖子拼出了同一种拧巴：想要 Firefox 活下去的人，和快要被 Firefox 逼走的人，其实是同一批人。thread 1 里，情怀派负责给 3% 的市场份额找意义，实用派负责把"GC collecting"和飘忽的阅读模式拍在桌上；thread 2 里，想用官方广告拦截器的用户发现自己连"被推送"的资格都没排到。理想与体验之间的裂缝，比 Chrome 与 Firefox 的份额差还宽。

最锋利的地方在于那条看不见的边界：Mozilla 一年从 Google 拿走数亿美元合作费，于是搜索广告不能拦、YouTube 广告不能拦、自家赞助内容更不能拦——广告拦截器能做到的，恰好是金主允许的那部分。骂 Firefox 的人多半还在用它，夸 Firefox 的人也未必拦得到广告。两边吵到最后，反而把作者那句"别把婴儿和洗澡水一起倒掉"吵成了字面意思：水越来越脏，婴儿越来越瘦，而倒水的人总以为自己在做对的事。

## 引用帖子

| # | 标题 | URL |
|---|------|-----|
| 1 | Hang on to Your Firefox (HN) | https://news.ycombinator.com/item?id=49527748 |
| 2 | 原文：Hang on to your Firefox! | https://www.newsonaut.com/articles/hang-on-to-your-firefox |
| 3 | Introducing Ad Blocker for Firefox on iOS (HN) | https://news.ycombinator.com/item?id=49521973 |
| 4 | 原文：Reduce clutter and distractions with Ad Blocker for Firefox on iOS | https://blog.mozilla.org/en/firefox/ad-blocker-on-ios/ |

<div class="disclaimer">
  <strong>免责声明：</strong>本文为 AI 摘要，旨在提炼 HN 社区讨论要点，不代表本网站立场。内容可能存在遗漏或偏差，建议阅读原文以获取完整信息。
  <br><br>
  <em>本摘要由 AI 模型辅助生成：deepseek/deepseek-v4-flash</em>
</div>
