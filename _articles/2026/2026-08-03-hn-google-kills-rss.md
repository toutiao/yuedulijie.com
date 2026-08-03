---
layout: post
title: "Google 如何扼杀 RSS — HN 讨论摘要"
date: 2026-08-03
categories: [articles]
excerpt: >-
  Google 靠 RSS 壮大，又亲手把它扼杀——从 Chrome 按钮到 Reader、FeedBurner、Google News 逐一砍掉，评论区从广告逻辑吵到企业文化，而 2026 年的 RSS 文艺复兴正在进行。
tagline: >-
  Google 教会世界订阅，再教会世界别订阅。
---

## 原文概要

8 月 1 日，非营利组织 Open RSS 的旧文 "How Google helped destroy adoption of RSS feeds"（2023 年首发）被重新顶上 HN 首页，一天内拿下 605 分、231 条评论。文章核心指控是：Google 对 RSS 长期执行"拥抱、扩展、再扼杀"（Embrace, Extend, and Extinguish）策略——先用免费开放的 RSS 协议积累信任，锁住用户后再砍掉支持。

文章按时间线罗列了罪证：Chromium 早期内置的 RSS 按钮无声消失；2007 年收购 FeedBurner，2012 年关停其 API，2022 年再砍掉大部分服务，留下失效的订阅链接；2005 年上线的 Google Reader 在 2013 年被关闭，官方理由是"使用量下滑"，但当时的工程师回忆"项目期间一直有人在想尽办法弄死它"；Google Alerts 的 RSS 支持在 2013 年被移除又因反弹恢复；Chrome RSS 扩展被下架一周后以"误删"名义恢复；Google News 在 2017 年 12 月彻底砍掉 RSS，且"专有的 Google News 链接一切照旧"。2021 年 Google 曾宣布要给 Chrome 带回 RSS，至今没有下文。

同一天，Andrew Shell 的个人博客 "I ♥ RSS" 也登上 HN，176 分、91 条评论。文章本身很简单——一个用 Dave Winer 的 FeedLand 搭建的"热爱 RSS 的人"目录——但它的标题里那颗 ♥ 在 HN 上渲染成了彩色，成了全场第一个"幸存"的 emoji，引发了一场 Unicode 考据；随后帖子标题被管理员改成了 "A directory of people who love RSS"。两篇帖子，一篇控诉 Google 杀死 RSS，一篇见证 RSS 社区的自发重建，在 2026 年的首页上隔空呼应。

## 讨论焦点

### 广告、中间人与"为什么要杀 RSS"

monksy 的第一个问题就切中要害。

> "What did Google benefit from killing rss? Seems like that would help engagement on the web in general." — monksy

> （Google 杀死 RSS 图什么？这按理说应该会提升整个网络的参与度才对。）

回复几乎一边倒：一切都是广告。

> "You couldnt put ads that easily in rss feeds." — tommek4077

> （RSS 里没那么容易塞广告。）

waqasx 给出了更结构的解释：

> "Subscribing to RSS creates a p2p web over http. It cuts out the middleman. Who is the biggest middleman of the internet?" — waqasx

> （订阅 RSS 相当于在 HTTP 上建立一张点对点的网络，它把中间商挤掉了。而谁是互联网最大的中间商？）

InsideOutSanta 把这层意思讲得更直白：

> "It's a decentralized solution in a world where google wants everything to go through google." — InsideOutSanta

> （在一个 Google 希望一切流量都流经自己的世界里，RSS 是一个去中心化方案。）

### Google Reader：从"伟大"到"有点邪恶"

几乎每个老用户都能说出关闭 Reader 那一天自己在干什么。rpdillon 把它定义为 Google 的道德分水岭：

> "Killing GReader was the inflection point for me, when Google tipped from \"Great!\" to \"Kinda evil\". It's been a slide ever since." — rpdillon

> （关闭 Google Reader 是我的转折点，Google 从"太棒了"转向"有点邪恶"，之后就是一路滑坡。）

mattsimpson 则写了一封分手信：

> "Nothing in this post was new news... seeing it written down in one place made me realize just the type of person, I mean company, that you are and what you really want, Google. For too long I've been holding on to the \"do no evil\" person, I mean company, that you once were. But now it's clear to me... you're a toxic friend. We've been drifting apart for years, but now it's official... we're breaking up." — mattsimpson

> （这篇文章没有一条新消息，但把它们写在一起，我终于看清了你——我是说，你们这家公司——的真实面目。这么多年我一直抱着"不作恶"的旧印象不放，现在彻底明白了……你是个有毒的朋友。我们渐行渐远好几年，现在正式官宣：分手。）

glenstein 补了一句总结：

> "It was the watershed moment that represented the break from \"don't be evil\", a cheeky slogan that was remarkably effective at conveying a sense of what they were about by talking about what they were trying not to be." — glenstein

> （这是"不作恶"被背叛的标志性时刻——这个俏皮口号的高明之处，恰恰在于用"我们不想成为什么"来表达"我们是什么"。）

### "我想念网站"

betenoire 一句话触动了整层楼。

> "Google Reader going away felt like the beginning of the end the internet as I knew it. I miss websites" — betenoire

> （Google Reader 关停那天，感觉是我认识的那个互联网走向终结的开始。我想念那些网站。）

tombert 从个人浏览史展开：

> "I don't hate the modern internet, but I feel like there's roughly now about ~10 sites that I visit frequently, whereas when I was a teenager there were lots more." — tombert

> （我并不讨厌现代互联网，只是我经常访问的网站现在大概只剩十来个，十几岁时可比这多得多。）

adamm255 指出，如今只剩两个入口把他带回真正的网站：

> "I realise the only place pushing me to an actual website these days are my RSS feeds (self hosted FreshRSS), and HN." — adamm255

> （如今还在把我引向真实网站的，只有我的 RSS 订阅（自托管 FreshRSS）和 HN。）

### 献祭给 Google+ 的 Reader

bakemawaytoys 戳破了当年的官方说辞：

> "Google's obviously fake excuse for killing their RSS reader (declining usage) was especially maddening at the time because they were pushing Google+ - which _nobody_ used." — bakemawaytoys

> （Google 用"使用量下滑"这种明显是编的理由杀掉 Reader 特别让人恼火，因为当时他们在力推一个没人用的 Google+。）

结局也充满讽刺，InsideOutSanta 说：

> "They killed a tool people loved to promote a tool people didn't want to adopt, and in the end both ended up dead." — InsideOutSanta

> （他们杀掉一个人们热爱的工具，去推广一个没人想用的工具，最后两个都死了。）

一位当年在 Google 工作的读者 timmg 至今没想通：

> "As someone who was a big fan of Reader and worked at Google at the time (not on G+): I never understood why they didn't try to put Reader _into_ G+." — timmg

> （作为一个当年在 Google 工作、又是 Reader 重度用户的员工（不涉及 G+ 部门）：我一直不明白他们为什么不想办法把 Reader 并入 Google+。）

dannyobrien 在新闻自由组织 Committee to Protect Journalists 工作的经历，让这个决定显得更荒诞：

> "At the time, I was working at the Committee to Protect Journalists with dissident bloggers working in Syria, Egypt, UAE, Turkey, etc. ... I remember distinctly as we worked on the agenda for the meeting with Google that Google Reader being shut down was the first complaint any of us mentioned. We laughed, but it was serious." — dannyobrien

> （当时我在保护记者委员会工作，同事里有叙利亚、埃及、阿联酋、土耳其等国的异见博客作者。我清楚记得，为去 Google 开会的议程做准备时，Google Reader 关停是所有人最先提起的抱怨。我们笑了，但这不是玩笑。）

### 谷歌文化：只发布，不养育

很多人把问题从单一产品上移到 Google 的组织文化。rcxdude 用 Stadia 佐证：

> "It seems like Google culturally can't deal with products that aren't overwhelming, gigantic successes, but they also really struggle to put in the effort to actually create those." — rcxdude

> （Google 的文化似乎既容不下那些没能大获成功的产品，又很难真正投入力气把它做成。）

ethbr1 的诊断更完整：

> "Google, culturally, seems very tone-deaf to market signals... flounders when opinionated, artistic product design with long-term vision is needed (Reader, YouTube, Stadia)... Nothing short of a Bezos-style API memo is going to change it... and Pichai doesn't seem like he's willing/able to rock the boat that much." — ethbr1

> （Google 的文化对市场信号相当迟钝……一旦需要那种有主见、有艺术感、有长期视野的产品设计（Reader、YouTube、Stadia），它就翻车……只有贝索斯式的那封"API 备忘录"才能改变它，而皮查伊看起来既不愿意也没能力去搅动这摊水。）

前 Googler titzer 说得最狠：

> "Google's problem is that, fundamentally, they hate end users... Google thinks anything below a billion users is not worth even pursuing. There was a mantra \"focus on the user and all else will follow\". The users who matter are advertisers." — titzer

> （Google 的问题在于，他们从根本上讨厌终端用户……低于十亿用户的业务，Google 根本不觉得值得做。他们有个信条叫"以用户为中心，一切随之而来"，可他们真正在意的用户是广告主。）

esafak 用八个字收束了这条线：

> "I think Google's culture is to blame; launches are lauded, nurturing is not." — esafak

> （这是 Google 文化的问题：发布被追捧，养育没人做。）

### Google Music：同一个剧本

评论区顺势盘点了一遍被 Google 砍掉的同类产品，Google Music（后改名 Google Play Music）是最常被提起的。deepsun 的痛点在"我太幸运"功能：

> "Same thing with Google Music, it was perfect. You could stream, or could buy and download mp3, or you could upload your library to it. And the best feature: \"I am feeling lucky\" -- play a random song you ever liked... But they killed it due to internal wars with YouTube Music that sucks. There's still nothing like Google Music." — deepsun

> （Google Music 也一样，它很完美。可以流媒体播放，可以买歌下 mp3，可以把本地曲库传上去。最棒的功能是"我太幸运了"——随机放一首你喜欢的歌……但他们因为和烂透的 YouTube Music 内斗把它砍了，至今没有替代品。）

titzer 由此得出一个彻底结论：

> "Why anyone trusts any streaming music service is absolutely beyond me. It will always get enshittified. I have 65GiB of mp3s I've accumulated from ripping CDs over the years." — titzer

> （任何人还相信流媒体音乐服务，我都完全无法理解。它早晚会被弄烂。我自己攒了 65GiB 从 CD 抓下来的 mp3。）

smeej 的损失则更具体：

> "I had uploaded so many indie local bands' CDs, none of which were ever on YouTube, so I lost more than half of my music library when they forced that change and there was nothing I could do about it, having long since gotten rid of the disks because I believed them that they would never delete my stuff. (Degoogled not long after that, actually. Fool me twice...)" — smeej

> （我传了大量独立乐队的地下 CD，YouTube 上根本没有，那次强制迁移让我丢了超过一半的曲库，却无能为力——因为相信他们"绝不会删你的东西"，我早就扔掉了实体碟。（那之后不久我就彻底弃用了 Google。被骗两次，就不能再信了……））

### 现在还在用 RSS 吗

也有读者质疑：绕开 Google，RSS 本来就活得好好的。konsalexee 说：

> "Just why bother relying on Google products for RSS? I use for the last many years NetNewsWire and have never had any problems reading the news I want to read." — konsalexee

> （何必依赖 Google 的产品做 RSS？我用 NetNewsWire 好多年了，读想读的新闻从没出过问题。）

al_borland 补充了这款开源阅读器的卖点——它甚至拒绝收费：

> "I use NetNewsWire. It's free, open-source, and explicitly says not to send money. First thing: don't send money. This app is written for love, not money. :)" — al_borland

> （我用 NetNewsWire。免费、开源，还明确说别打钱。第一句话就是：不要捐钱。这个软件为爱编写，不为钱。）

fsflover 则把矛头对准"把 RSS 外包给大厂"这个思路本身：

> "What prevents you from using RSS now? Outsourcing your RSS feed to a megacorp sounds like a horrible idea." — fsflover

> （现在还有什么阻止你用 RSS 吗？把 RSS 订阅外包给一家巨头，听起来就是个糟糕透顶的主意。）

至于站点为什么普遍不再提供 RSS，basilikum 和 fsflover 各执一词：

> "RSS is a free way to reach almost no one." — basilikum

> （RSS 是触达几乎为零的免费渠道。）

> "RSS is a free way to reach content genuinely created for users, not for profit." — fsflover

> （RSS 是触达真正为用户、而不是为利润而创作的内容的免费渠道。）

### RSS 能走进大众吗：播客之争

al_borland 提出一个反向观点——RSS 其实早就大众化了，只是没人意识到：

> "The mainstream ended up using social media to solve the problem RSS had already solved years earlier… it just had poor marketing. A lot of people do use RSS without realizing it, via podcasts." — al_borland

> （大众最终用社交媒体解决了 RSS 多年前就解决的问题……只是它营销太差。其实很多人都在无意识中使用 RSS——播客就是。）

ksec 补上了 Google 在其中扮演的角色：

> "A lot of people were using Google Reader without ever knowing what RSS was all about. And when Google reader was gone, they stopped using it, Facebook then taken the newsfeed over." — ksec

> （很多用户根本不知道 RSS 是什么，只是用着 Google Reader。Reader 没了，他们就不再用了，Facebook 顺势接过了新闻流。）

Grombobulous 坚持 RSS 天生走不出极客圈：

> "I just don't believe for a second that RSS had any chance of becoming mainstream outside of techie circles." — Grombobulous

> （我压根不信 RSS 在技术圈之外还有机会成为主流。）

zdunn 用播客反驳：

> "But RSS _did_ become mainstream; podcasts are a normal part of media now and non-techies seem to have no problem finding and consuming them. They don't have to know about RSS." — zdunn

> （可 RSS 确实已经主流了——播客现在就是媒体常态，非技术人群毫无障碍地收听。他们不需要知道 RSS 的存在。）

### 一颗彩色 ♥ 引发的 Unicode 考据 [thread 2]

"I ♥ RSS" 这个标题在 HN 上成了奇观——评论区平时会被过滤掉的 emoji，这次居然以彩色红心的形态渲染出来了。dijit 说：

> "this is the first emoji I see on HN at all, they're filtered out in comments." — dijit [thread 2]

> （这是我在 HN 上见到的第一个 emoji，评论里的都会被过滤掉。）

culi 揭开了谜底：

> "I think the reason its not stripped is because it's actually \"U+2665 : BLACK HEART SUIT {valentine}\" which predates the emojis." — culi [thread 2]

> （它没被过滤，是因为这其实是 U+2665"黑色红心花色"——比 emoji 出现得更早的字符。）

deathanatos 搬出了 Unicode 技术标准 UTS #51，解释这颗心"是 emoji 但默认不是 emoji 外观"，还顺手指出 macOS 渲染行为"不太守规矩"。

随后管理员把标题改成了 "A directory of people who love RSS"。guiambros 眼尖地发现了：

> "And... it's gone. I guess mods don't like emoji in titles. Can't blame them; it draws a bit more attention than normal." — guiambros [thread 2]

> （然后……它就没了。我猜管理员不喜欢标题里的 emoji。也怪不得他们，确实太显眼了。）

basilikum 的疑问则留给了未来：

> "I really need to finish the blog post for my emoji domain. What are mods gonna do when the emoji is literally in the domain?" — basilikum [thread 2]

> （我真得赶紧写完我那篇 emoji 域名的博客。当 emoji 直接出现在域名里，管理员还能怎么办？）

### RSS 还是 Atom：格式战争 [thread 2]

另一条战线在"RSS 这个名字"上。edhelas 提议拥抱后辈：

> "If you love RSS, embrace Atom 1.0 :) Its the final modern form of RSS." — edhelas [thread 2]

> （如果你爱 RSS，拥抱 Atom 1.0 吧。它是 RSS 的终极现代形态。）

chrismorgan 的态度最强硬：

> "I _hate_ RSS. It's a bad format that developed organically in all the worst ways, and it should have died _completely_ in favour of Atom by about twenty years ago." — chrismorgan [thread 2]

> （我恨 RSS。它是个以最糟糕方式自然生长出来的坏格式，本该在二十年前就彻底死在 Atom 手里。）

8organicbits 用市场份额泼了冷水：

> "The last statistic I saw put RSS at 77% of the web feed market share, higher than Atom. In the web feed market it isn't a protocol on the way out, its the dominant protocol." — 8organicbits [thread 2]

> （我看到的最近数据是 RSS 占 Web feed 市场份额 77%，高于 Atom。在 feed 市场它不是行将淘汰的协议，而是主导协议。）

dewey 建议别在命名上较劲：

> "Having structured feeds of any kind is already a niche and much appreciated when it happens. How to call them correctly technically based on some specs is not the hill to die on." — dewey [thread 2]

> （结构化 feed 本来就是个难得的小众存在。按某个规范把它们叫得多准确，不是值得拼命的战场。）

### 目录、FeedLand 与 RSS 文艺复兴 [thread 2]

这篇帖子的评论区更像一场自发聚会。正在建另一个 RSS 目录的 jjordan 现身说：

> "It stemmed from a frustration of outdated and broken RSS feed collections, and the long slow death of the orange RSS subscribe button across the web." — jjordan [thread 2]

> （这源于对陈旧失效的 RSS 目录的失望，以及那个橙色 RSS 订阅按钮在全网漫长而缓慢的消亡。）

8organicbits 介绍了 FeedLand 的社交化设计：

> "My favorite part of FeedLand is that you can see who subscribes to a blog and where else they subscribe. This makes RSS feel social, without the algorithmic tricks of traditional social media." — 8organicbits [thread 2]

> （FeedLand 我最喜欢的一点是能看到谁订阅了一个博客、还订阅了哪些别处。这让 RSS 有了社交感，却没有传统社交媒体的算法把戏。）

RSS 之父 Dave Winer 亲自下场回应，并总结这场复兴：

> "This is great. RSS is springing back to life. All it need was for people to reject the hype that came largely from big companies that wanted to and did takeover," — davewiner [thread 2]

> （这太棒了。RSS 正在复苏。它需要的只是人们拒绝那些来自大公司、想要也确实完成了接管的花言巧语。）

nicole_express 提供了数据感很强的侧写：

> "I'm always surprised how many people who read my blog do so over RSS. It's probably one of my biggest traffic sources." — nicole_express [thread 2]

> （我总是惊讶于有多少读者是通过 RSS 读我的博客，它可能是我最大的流量来源之一。）

### 回到写博客本身 [thread 2]

也有读者提醒大家别把目光停在协议上。mickeyp 说：

> "I love RSS but what I love more than RSS are people who blog about stuff: high concept stuff, day-to-day stuff and just what they did yesterday. I wish people would blog more like in the old days." — mickeyp [thread 2]

> （我爱 RSS，但比起 RSS，我更爱那些写博客的人：写宏大构思、写日常琐事、写昨天干了什么。我希望大家能像从前那样写博客。）

mathgladiator 的回复，则精准戳中了 2026 年的时代情绪：

> "Im going to be doing this again without an agenda. I am recovering from using AI to write thoughts because now I see and hear the patterns which are becoming obnoxious." — mathgladiator [thread 2]

> （我打算重新开始写，不带任何目的。我正在从"用 AI 写想法"中恢复——因为现在我能看到、听到那些令人厌烦的套路了。）

## 典型观点一览

| 立场 | 用户 | 一句话 |
|------|------|--------|
| 反谷歌 | titzer | "谷歌从根本上讨厌终端用户，只有广告主才算用户。" |
| 道德转折 | rpdillon | "关闭 Reader 让 Google 从'很棒'滑向'有点邪恶'。" |
| 文化归因 | esafak | "发布被追捧，养育没人做。" |
| 怀旧派 | betenoire | "Reader 没了，网络开始变味，我想念网站。" |
| 独立阅读派 | konsalexee | "NetNewsWire 用了多年，从没出过问题。" |
| RSS 主流派 | zdunn | "RSS 早就是主流了——播客就是。" |
| RSS 小众派 | Grombobulous | "RSS 在技术圈之外根本没机会成为主流。" |
| 格式务实派 | dewey | "纠结叫 RSS 还是 Atom，不值得拼命。" |
| 文艺复兴 | davewiner | "RSS 正在复苏，只要人们拒绝大厂的炒作。" |

## 总体情绪

这场讨论有一条清晰的情绪曲线：从对 Google 的愤怒，到对旧互联网的怀旧，再到"我们正在重建"的行动感。愤怒集中在"以用户为中心"和"不作恶"这两句口号的崩塌上；怀旧则是对那个"想写就写、想看就订"的分布式网络的集体记忆。真正意外的转折，来自第一篇帖子评论区里几乎没人讨论怎么救 RSS——因为大家都在用 NetNewsWire、FreshRSS、FeedLand，第二篇帖子更是现场直播了这场复苏。

两篇帖子在首页隔空相遇，恰好拼出 RSS 故事的全貌：它死于被大厂收编，也正在死于被大厂抛弃之后的自发重建。RSS 没有死，它只是退出了浏览器、退出了大众视野，搬进了自托管服务器、NetNewsWire 和 FeedLand 里。这场讨论真正的底色不是怀旧，而是一句被反复印证的话——开放标准最危险的时刻，就是它被一家大公司看上的时候。

## 引用帖子

| # | 标题 | URL |
|---|------|-----|
| 1 | How Google helped destroy adoption of RSS feeds (2023) | https://news.ycombinator.com/item?id=49136821 |
| 2 | A directory of people who love RSS | https://news.ycombinator.com/item?id=49136063 |

## 免责声明

<div class="disclaimer">
本摘要基于 HN 帖子 "How Google helped destroy adoption of RSS feeds" 与 "A directory of people who love RSS" 的讨论整理而成，不代表本网站立场。引文内容版权归原作者所有。
<br><br>
<em>本摘要由 AI 模型辅助生成：deepseek/deepseek-v4-flash</em>
</div>
