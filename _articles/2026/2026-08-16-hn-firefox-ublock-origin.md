---
layout: post
title: >-
  Firefox 成为最后一个支持 uBlock Origin 的主流浏览器 — HN 讨论摘要
date: 2026-08-16
categories: [articles]
excerpt: >-
  Chrome 的 Manifest V3 迁移后，完整版 uBlock Origin 只剩 Firefox 还能跑。HN 1654 分热帖：Brave 是出路还是 Chromium 皮、uBO Lite 只是藏广告不是挡广告、以及 Firefox "勉强能用"之争。
tagline: >-
  Chrome 十年广告进化，Firefox 靠"不改造"赢回一局。
---

## 原文概要

8 月 13 日，PCWorld 发布新闻（作者 Viktor Eriksson 与 Joel Lee）：Firefox 现在是最后一个仍支持完整版 uBlock Origin 的主流浏览器。背景是 Google 推动的 Manifest V3 迁移——Chrome 移除了旧版扩展依赖的 `webRequest` 拦截能力，完整版 uBlock Origin 在 Chrome 上失去效力，只能退而求其次用功能受限的 uBlock Origin Lite。微软的 Edge 也即将跟进，像 Chrome 一样锁定旧版广告拦截器。这样一来，Firefox 因为保留了旧扩展体系的兼容，成了唯一能让 uBlock Origin 完整版正常运行的主流浏览器。

帖子在 HN 首页 (/news) 冲上 1654 分、约 608 条评论。评论区没有停留在"哪个浏览器更好"的表层，而是把这场迁移拆解成几层问题：Lite 版到底损失了什么、Brave 能不能接棒、Firefox 是不是真的"能用"、以及新一代用户还关不关心广告拦截这件事。

## 讨论焦点

### 20 年后的回环：Firefox 靠广告拦截赢回一局

多位用户注意到一种历史轮回——Firefox 当年正是靠广告拦截崛起，如今又靠它成为"最后一块阵地"：

> "Firefox, after 20 years, once again has an advantage over the other browsers." — timetraveller26

> （Firefox 在 20 年后再次拥有了对其他浏览器的优势。）

> "It's funny. Over 20 years ago, I got people to switch to Firefox because of the AdBlock extension. In case people don't know, Firefox was the first major browser to even have extensions." — BeetleB

> （有意思的是，20 多年前我就是靠 AdBlock 扩展拉人换到 Firefox 的。好多人不知道，Firefox 是第一个有扩展的主流浏览器。）

这个回环让讨论带上了怀旧底色：当年 Firefox 用扩展系统挑战 IE 的垄断，如今 Chromium 系逐步砍掉扩展能力，倒逼用户重新看向 Firefox。讽刺的是，这次"优势"不是靠新功能赢来的，而是靠"没有跟上行业步伐"。

### uBO 与 uBO Lite：挡广告 vs 藏广告

Chrome 用户还能用的只有 Manifest V3 的 uBlock Origin Lite。多位用户用实测说明，两者差别并不只是"轻量一点"：

> "The Lite version is basically 'hiding' ads rather than blocking. The MV2 version stops the requests themselves from being made which save your bandwidth and battery. The light version lacks those benefits" — culi

> （Lite 版基本是"藏"广告而不是"挡"广告。MV2 版本直接把请求拦下来，省带宽省电。轻量版没有这些好处。）

> "That's manifest V3 working as intended." — kevin_thibedeau

> （这就是 Manifest V3 设计出来要的效果。）

Andrex 用一句反讽把这套机制点破——广告商、网站、用户各取所需，唯独没人真正吃亏：

> "Advertisers get to pretend their ads are being seen. Websites get paid. Users don't see ads. Sounds like a win-win-win?" — Andrex

> （广告商假装广告被看到了。网站拿到了钱。用户看不见广告。听上去是三赢？）

讨论的核心不是"Lite 能不能用"，而是"Lite 的设计目标就是让广告商继续数虚假的曝光量"——请求没被拦下，用户照常被追踪，只是视觉上"眼不见为净"。

### Brave 是出路，还是又一个 Chromium 皮？

Brave 因为内置广告拦截且保留 Manifest V2 的 opt-out，成了不少人的首选替代。但反对声同样激烈，第一条攻击就是它的出身：

> "Isn't Brave just another Chromium variant? Chromium is detestable. In whatever form it takes." — odidiejdiwjd

> （Brave 不就是又一个 Chromium 变种吗？无论披什么皮，Chromium 都令人厌恶。）

更深的顾虑指向创始人与资金结构。AstralSerenity 直接摆出投资人名单：

> "Peter Theil was an angel investor in Brave. That alone is all the reason privacy-minded users need to avoid it." — AstralSerenity

> （Peter Thiel 是 Brave 的天使投资人。就这一条，就够注重隐私的用户避开它了。）

fragmede 则用反讽回应这种"出身论"：

> "Because Peter Thiel gave them some money, there's some secret backdoor code that's sending all your information to Palantir?" — fragmede

> （因为 Peter Thiel 给了点钱，就存在秘密后门代码，把你所有信息发给 Palantir？）

最重的一击来自历史旧账。al_borland 提到 Brave 2020 年被曝在地址栏的加密货币交易所链接末尾追加返佣代码：

> "I'm not sure why anyone would trust a browser that does this kind of thing. Some could claim it's a harmless way to make some extra cash, but it's very similar to what Honey was caught doing." — al_borland

> （我不懂怎么会有人信任这么干的浏览器。有人会说这是赚点外快的无害手段，但这跟 Honey 被抓到做的事非常像。）

iLoveOncall 的用词更不客气：

> "Brave is malware, I don't understand how anyone on HN can use it, baffles me every time. They've literally been caught MITMing web pages for their own financial gains." — iLoveOncall

> （Brave 就是恶意软件，我不懂 HN 上怎么会有人用它，每次看都困惑。他们真被抓到过为了给自己赚钱去中间人攻击网页。）

### "勉强能用"之争：Firefox 到底坏不坏

另一条主线围绕 Firefox 的日常体验。odidiejdiwjd 的批评最有代表性——光靠理念留不住用户：

> "Firefox will never convince people to leave chrome on philosophy alone. I detest Chrome with a passion and refuse to touch it with a ten-foot pole, but cannot in good faith recommend Firefox to anyone in today's world. 'It kinda works' is about as far a compliment you can give it." — odidiejdiwjd

> （光靠理念，Firefox 永远说服不了人们离开 Chrome。我对 Chrome 深恶痛绝，碰都不会碰一下，但我没法凭良心向任何人推荐今天的 Firefox。"勉强能用"就是你能给它的最高评价了。）

反对派立刻用个人体验反驳。cadamsdotcom 的数据很硬：

> "I have used Firefox exclusively every day on macOS for the past year, several hours a day, and have not one single time had to open another browser." — cadamsdotcom

> （过去一年我每天在 macOS 上用 Firefox，一天好几个小时，从来没有一次需要打开另一个浏览器。）

jjav 的履历更夸张：

> "So yes, I did encounter one site that didn't work in Firefox in the last ~20 years. One." — jjav

> （所以是的，过去大约 20 年里我确实遇到过一个在 Firefox 上打不开的网站。就一个。）

两边吵到最后开始互相怀疑动机。sensanaty 抛出"水军论"：

> "I genuinely wouldn't be surprised if it was Google astroturfing every single thread relating to FF." — sensanaty

> （如果每个关于 Firefox 的帖子都是 Google 雇水军发的，我一点都不会惊讶。）

Capricorn2481 则从营销心理学给出一个更冷静的观察：

> "Firefox users would say 'Firefox is better than Chrome.' Chrome users would say 'Chrome is good.'" — Capricorn2481

> （Firefox 用户会说"Firefox 比 Chrome 好"。Chrome 用户会说"Chrome 不错"。）

### 新一代：不再浏览网页的人

不少评论把话题拉远，质疑"广告拦截"本身是否还重要——因为新一代用户压根不逛网页了。matheusmoreira 还在坚持装 uBO：

> "I install uBlock Origin on every browser I come across. Everybody notices. The internet just feels better, somehow. People can't quite explain what changed, but they know." — matheusmoreira

> （我在每个遇到的浏览器上都装 uBlock Origin。每个人都注意到变化。互联网就是莫名感觉更好了。大家说不清哪里变了，但他们知道。）

globular-toast 的回应带着沮丧：

> "And now you'll no longer be able to wake people up and show them the real world." — globular-toast

> （而现在你再也没法叫醒人们，让他们看看真实世界了。）

drewfax 点出了更残酷的世代断层：

> "New generations don't 'browse' web anymore. They 'consume' YouTube, Instagram, Android TV and other walled gardens. These generation don't even know they could change contents being displayed on their device to their wish. For them it's just whatever the app shows. They don't understand Web, extensions, DNS etc. I don't have hope for new generations. We're are the old men now yelling at AI and App Stores." — drewfax

> （新世代已经不再"浏览"网页了。他们"消费"YouTube、Instagram、Android TV 这些围墙花园。这些人甚至不知道设备上显示的内容可以按自己的意愿改动。对他们来说，App 显示什么就是什么。他们不懂网页、扩展、DNS 这些概念。我对新世代不抱希望。我们如今是朝着 AI 和应用商店吼叫的老头子。）

### Mozilla 的钱，与"为什么不内置"

最后一条支线指向 Mozilla 自身的矛盾：账上有钱，却既不肯把广告拦截内置，也没把 Firefox 推到足够好用。matheusmoreira 的不满非常直白：

> "Sad indeed. What trully pisses me off though is the fact Mozilla has like hundreds of millions of dollars in the bank, possibly a billion dollars, and yet they continue to neglect Firefox." — matheusmoreira

> （确实可悲。真正让我恼火的是，Mozilla 银行里有几亿美元，可能有十亿，却还在继续忽视 Firefox。）

swed420 认为，与其费劲审查 uBlock 的每次更新，不如直接内置广告拦截——但动机上他并不乐观：

> "They could save themselves the trouble if Firefox simply baked in its own ad-blocking, but since Google basically owns them, we all know that will never happen. Ladybird browser is going to be awesome." — swed420

> （如果 Firefox 直接把广告拦截内置进去，他们能省掉这些麻烦，但既然 Google 基本掌控着他们，我们都知道那永远不会发生。Ladybird 浏览器会非常棒。）

有意思的是，评论里也有人反驳：内置会引来"网站不支持你的浏览器"的横幅战争，而 Mozilla 目前靠 Google 的搜索分成生存，内置广告拦截等于直接断自己财路。

## 典型观点一览

| 立场 | 用户 | 一句话 |
|------|------|--------|
| 历史乐观派 | timetraveller26 | 20 年后 Firefox 再次手握广告拦截优势 |
| 现实派 | ImJamal | uBO Lite 在 Chrome 上够用，换浏览器没动力 |
| 拦截差异派 | culi | Lite 是藏广告，MV2 才是真拦截，省带宽省电 |
| 反 Brave 派 | AstralSerenity | Thiel 投过钱，隐私用户就该避开 |
| 反 Brave 派 | iLoveOncall | 有 MITM 前科，Brave 就是恶意软件 |
| 挺 Brave 派 | vovavili | 内置拦截 + MV2 opt-out，跨平台都好用 |
| Firefox 拥护派 | cadamsdotcom | 一年没用过别的浏览器，渲染全正常 |
| Firefox 批评派 | odidiejdiwjd | 越来越多网站拒绝 Firefox，只能算"勉强能用" |
| 水军论 | sensanaty | 每个关于 FF 的帖子都有 Google 水军 |

## 总体情绪

整场讨论在"怀旧"与"无力感"之间来回摆动。怀旧的一端，是用户反复提起 20 年前用 AdBlock 拉人换 Firefox 的往事，如今历史重演，只是这次的对手从 IE 换成了整个行业对广告分成的依赖；无力的一端，是"新一代用户根本不逛网页""90% 的人用不上完整版 uBO""Lite 只是把广告藏起来"这类现实，让人觉得广告拦截这件事正在被时间悄悄解决。

而 Mozilla 这条支线让情绪更复杂：一个靠对手资金活着、既有理想又不肯伤及利益的非营利组织，成了广告拦截的最后一块阵地——这既是夸奖，也是讽刺。广告拦截从来不是技术问题，而是浏览器厂商愿不愿意得罪广告主的问题；如今只剩 Firefox 还站在用户这边，而这个立场本身，恰恰是它最脆弱的地方。

## 引用帖子

| # | 标题 | URL |
|---|------|-----|
| 1 | Firefox is now the last major browser that still supports uBlock Origin | https://news.ycombinator.com/item?id=49303202 |
| 2 | Microsoft Edge is about to lock out older ad blockers, just like Chrome did | https://news.ycombinator.com/item?id=49220392 |
| 3 | uBlock Origin Lite now available for Safari | https://news.ycombinator.com/item?id=44795825 |

## 免责声明

<div class="disclaimer">
本摘要基于 HN 帖子 "Firefox is now the last major browser that still supports uBlock Origin" 的讨论整理而成，不代表本网站立场。引文内容版权归原作者所有。
<br><br>
<em>本摘要由 AI 模型辅助生成：deepseek/deepseek-v4-flash</em>
</div>
