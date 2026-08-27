---
layout: post
title: >-
  Apple M6 与 M5 Ultra 发布 — HN 讨论摘要
date: 2026-08-27
categories: [articles]
excerpt: >-
  苹果 2nm 的 M6 首次进入 Mac mini，四晶粒的 M5 Ultra 把统一内存推到 512GB。评论区却算起了另一笔账：顶配要 2.5 万美元，而这钱存银行的利息够永远付订阅费。
tagline: >-
  本地 AI 的天花板，和它的价格一起涨。
---

## 原文概要

8 月 25 日，苹果一口气发布了两颗芯片、三款新品，话题刷上 HN 热门榜。主角是 M6 和 M5 Ultra：M6 是苹果首颗 2nm 芯片，12 核 CPU（2 个 super 核、4 个性能核、6 个能效核）、12 核 GPU（每核带 Neural Accelerator）、双 16 核神经网络引擎，最高 32GB 统一内存、170GB/s 带宽——比 M5 高 10%、比 M1 高 2.5 倍，官方称单核性能为"全球最快"。M5 Ultra 则是 M 系列首颗四晶粒芯片，用 UltraFusion 把两颗双晶粒 M5 Max 拼在一起，最高 36 核 CPU、80 核 GPU、512GB 统一内存，带宽冲到 1.2TB/s——比 M3 Ultra 高 50%，AI 峰值算力是其 4.5 倍。

三款新品对应关系很清楚：新 Mac mini 用 M6 和 M5 Pro，M6 版起价 899 美元（教育价 799），M5 Pro 版 1,699 美元起；新 Mac Studio 用 M5 Max 和 M5 Ultra，分别 2,499 美元和 5,499 美元起，顶配可到 512GB 内存，10 月底才供货。两款机器都首次支持 Wi-Fi 7、蓝牙 6 和 Thunderbolt 5，后者还支持把多台 Mac 串起来做分布式 AI 推理——官方称四台 Mac Studio 集群推理比单台快 3 倍。所有新品 9 月 22 日开卖。

苹果把这次发布的叙事押在了"本地 AI"上：M5 Ultra 能整机跑数百亿参数的 LLM，M6 的官方宣传语甚至拿《Mixtape》这款游戏来秀帧率。但 HN 评论区几乎没有被这份叙事带走，大家更关心三件事：这代芯片到底能不能打、这些内存和价格值不值、以及苹果在 AI 这场仗里到底该站哪个位置。

## 讨论焦点

### "苹果不需要参加 AI 军备竞赛"

第一条被反复引用的评论，直接否定了"苹果在 AI 上落后"的流行叙事：

> "Apple never needed to participate in the AI race to zero. Because they were already at the finish line years ago building their own chips that can run large >100B parameter AI models locally." — rvz

> （苹果根本不需要参加这场"卷到零"的 AI 竞赛，因为他们多年前造自己的芯片时，就已经站在了终点线——可以本地跑超 100B 参数的大模型。）

llm_nerd 对这种叙事表示了不耐烦，同时澄清了苹果在 AI 上的真实投入：

> "It's bizarre how often this 'Apple sat on the sidelines and let the AI people fight...so smart!' narrative appears on HN. Apple hasn't gone down the path of spending hundreds of billions on nvidia GPU data centres, but they absolutely tried really hard to matter in AI." — llm_nerd

> （很奇怪 HN 上老是出现"苹果坐在场边看 AI 打架……真聪明！"这种叙事。苹果没走花几百亿美元建英伟达 GPU 数据中心的路，但他们绝对非常努力想在 AI 上有一席之地。）

### 2.5 万美元的机器，还是存银行买 token

M5 Ultra 顶配近 2.5 万美元的价格，引发了一场"买硬件还是买订阅"的账目之争。intrasight 用房子打了个比方：

> "So is downpayment on a house. I would buy the house and just pay for tokens as needed. The house will get more valuable and that wealth would buy a lot of tokens in the future - which will probably get cheaper." — intrasight

> （这价格等于一套房子的首付。我会买房子，按需买 token。房子会升值，这些钱以后能买更多 token——而且 token 大概还会更便宜。）

paxys 算得更细：

> "Or more simply – $25K (+ tax) put in a savings account will earn about enough interest to pay for a $100/month AI subscription indefinitely. And at the end of it you still have the $25K." — paxys

> （或者更简单——把 2.5 万美元（加税）存进储蓄账户，利息差不多够永远付每月 100 美元的 AI 订阅。到头来你还有这 2.5 万。）

反方 bilbo0s 点出了这套账的适用范围：

> "Unless you need privacy for your inference this instant, paying for credits can get 80 to 90 percent of people everything they need." — bilbo0s

> （除非你此刻就需要推理隐私，否则花钱买额度能让 80% 到 90% 的人得到他们需要的一切。）

bigyabai 则从体验上泼冷水——本地推理未必更快：

> "Not if it's 5-10x slower than a remote inference server. Mac prefill latency is exhausting." — bigyabai

> （如果比远程推理服务器慢 5 到 10 倍就不是。Mac 的 prefill 延迟让人抓狂。）

### 内存升级的天价

1.2TB/s 的带宽看着吓人，LeBit 却先算了一笔对比：

> "1.2TB/s is 2/3 the speed of an nVidia 5090. But you get a generic computer and much more RAM. And you lose a couple of organs." — LeBit

> （1.2TB/s 只有 RTX 5090 的 2/3。但你能得到一台通用电脑和更多内存。只是得搭上一两个器官的价格。）

mhast 用实测数据给"本地跑模型"的热情降温：

> "My old 3090 is typically significantly faster (almost 2x token/s) than my M4 Max 128GB machine, as long as the model fits in the 24GB of VRAM." — mhast

> （只要模型塞得进 24GB 显存，我那块老 3090 通常比我 M4 Max 128GB 快得多——token/s 几乎翻倍。）

内存容量的价格更离谱。SXX 列出了内存升级费：96GB 升到 256GB 要 4,000 美元（英国 5,460 美元），合每 GB 25 美元。mrtksn 把顶配账单凑了个整：

> "Apple Studio with maxed out M5 Ultra, 256GB RAM and 16TB storage is 18,299$. The 512GB RAM version apparently is coming in October... The fully maxed out Apple Studio then will be 24699$." — mrtksn

> （顶配 M5 Ultra、256GB 内存、16TB 存储的 Mac Studio 要 18,299 美元。512GB 版十月才来……完全顶配的 Mac Studio 将会是 24,699 美元。）

### Linux 支持之痛

凡是聊到 Mac 跑本地模型，Linux 用户的声音总会准时出现。teekert 抛出了那个经典问题：

> "Is there anything comparable that runs Linux, doesn't necessarily look as good, but is perhaps (a lot) cheaper/fixable? Or is this really pretty optimal?" — teekert

> （有没有能跑 Linux、不必好看、但便宜得多且可维修的同类产品？还是说这已经接近最优解了？）

bel8 指出了最扎心的一点：

> "The real downside for me is not having Linux support. It would take Apple one or two engineers to make Linux life much easier on macs. But Linux is outside their walled garden so it's ignored." — bel8

> （对我来说真正的缺点是没有 Linux 支持。苹果只要一两个工程师就能让 Mac 上的 Linux 好过很多。但 Linux 在他们的围墙花园之外，所以被无视了。）

现状也印证了这一点——jlokier 直接说：Asahi Linux 目前只支持到 M2。

### "苹果不再创新"之争

一部分评论把话题拉远，争论苹果是否早已失去创新力。jjice 给出了典型的"跟进者"论调：

> "Apple doesn't innovate anymore, but they're generally pretty good at adapting once other people have." — jjice

> （苹果不再创新了，但他们通常很擅长在别人创新之后再跟进。）

maherbeg 当即反驳，列了一串苹果开创的品类：

> "I think this is a bit of a crazy statement. Everyone expects Apple to somehow build a category leading product every year... * the iPhone * the iPad * apple watch * airpods * unified memory laptops and computers. Those are all products that either created a category or changed that industry." — maherbeg

> （我觉得这说法有点疯狂。大家都指望苹果每年搞出一个品类之王……iPhone、iPad、Apple Watch、AirPods、统一内存笔记本——这些都是开创品类或改变行业的。）

### 欧洲定价与 Dvorak 的 3000 美元定律

Mac Studio 帖子里，欧洲用户先被价格劝退。

> "I am in Europe, and the Mac Studio M5 Ultra GPU 64 cores with 96GB RAM is up to 6.649,00 €. Ouch." — meerita [thread 2]

> （我在欧洲，Mac Studio M5 Ultra 64 核 GPU + 96GB 内存要 6,649 欧。哎哟。）

alfanick 提醒这未必公平：美国价不含增值税，欧洲价通常含。mikestew 则搬出了科技记者 John Dvorak 的经典预言：

> "John Dvorak said many, many decades ago (80s/90s) that the computer you want will always cost $3000. That statement has been more/less true for some time periods than others, but with some wiggle room I've found it to be accurate enough." — mikestew [thread 2]

> （John Dvorak 几十年前（80/90 年代）说过，你想要的电脑永远会花你 3000 美元。这句话某些时期比另一些时期更接近现实，但大致没错。）

nine_k 用 1984 年的 IBM PC AT 给今天的价格做了个参照——当时约 5,795 到 6,000 美元，折合今天的 18,600 到 19,300 美元。

### RAM 供应：苹果被市场打脸

Mac Studio 评论区另一个焦点，是苹果在内存危机面前的表现。varispeed 说得直接：

> "It's more bizarre that Apple got caught with pants down. Focused on CPUs and ignored RAM. Seems like miscalculation. If they had their own fab for RAM, they could completely corner the market today." — varispeed [thread 2]

> （更奇怪的是苹果被逮了个正着。只顾 CPU 忽略了内存，像是失算。如果苹果有自己的内存厂，今天就能完全垄断市场。）

xdertz 纠正了技术细节：苹果也没有自己的 CPU 厂，瓶颈在内存制造本身，苹果能做的不多。gizajob 则调侃道：

> "Bizarre there isn't a 1TB RAM option hidden away for the excessively frivolous or VC funded." — gizajob [thread 2]

> （奇怪的是没有藏着个 1TB 内存选项，专门卖给那些过于挥霍的人或拿了 VC 钱的。）

### "永久机"之辩

多位用户提到想买一台 Studio 当"forever machine"，立刻有人泼冷水。JohnBooty：

> "If running LLMs locally matters, it's hard to imagine a 'forever machine' existing in anything less than 5-10 years, probably more. This stuff is just evolving so rapidly. Buying a 'forever machine' today might be like buying a 'forever GPU' in 2003." — JohnBooty [thread 2]

> （如果本地跑 LLM 对你很重要，那很难想象 5 到 10 年内会出现什么"永久机"，可能更久。这玩意儿进化太快了。今天买"永久机"，大概就像 2003 年买"永久 GPU"。）

jubilanti 的劝解更实在：

> "Then you'll always be waiting, there's always something new the industry tries to tempt you with." — jubilanti [thread 2]

> （那你永远都在等，行业总会拿新东西诱惑你。）

### 告别低价的 Mac mini

Mac mini 帖子的情绪最"痛"——低价 mini 的时代似乎过去了。Ambroos 说：

> "It's a bit of an emotional goodbye to the super cheap Mac Minis we got to enjoy for a while... Not that they're a bad deal now, but at European prices of over €1000 for M6/16GB/256GB it's a psychological barrier that's been broken." — Ambroos [thread 3]

> （对那段超便宜 Mac mini 的日子，有点情感上的告别。不是说现在不值，但欧洲 M6/16GB/256GB 超过 1000 欧，心理门槛已经破了。）

petu 用两年前的官方价做了对照：

> "Mac Mini M4 launched less than 2 years ago at $600 (US, $500 with edu discount; as low as $400 on general discounts). Now same config with M6 is $900." — petu [thread 3]

> （Mac mini M4 不到两年前发布，起价 600 美元（教育价 500，促销能到 400）。现在同样配置的 M6 要 900。）

对涨价原因的讨论同样热闹，simonh 一句话点破：

> "You thought they'd bump the base RAM in the middle of the biggest RAM crisis in history?" — simonh [thread 3]

> （你居然指望他们在史上最大内存危机期间提升基础内存？）

linguae 晒出了自己的"预言"：

> "I paid $499 for my M4 back in April with the academic discount since I predicted the next generation base model would cost more. Sadly my prediction was correct: $599 to $899 is steep." — linguae [thread 3]

> （我四月用教育折扣 499 美元买下 M4，因为我预测下一代基础款会更贵。可惜预言成真：从 599 到 899 太狠了。）

### 廉价计算时代结束？

Mac mini 的涨价引发了对整个行业的悲观预测。jdoe1337halo：

> "Era of cheap compute is over I'm afraid." — jdoe1337halo [thread 3]

> （恐怕廉价计算的时代结束了。）

timpera 把这个话题推向了更宏观的担忧：

> "What will happen once people are priced out of buying computers? I find this worrying." — timpera [thread 3]

> （一旦人们买不起电脑会发生什么？我觉得这很令人担忧。）

iamacyborg 的回应是黑色幽默：

> "I'm sure some kind capitalist will be happy to rent them a thin client linked to a computer in the cloud." — iamacyborg [thread 3]

> （肯定会有某个善良的资本家乐意把瘦客户端租给他们，后面连着一台云里的电脑。）

### 拿《赛博朋克 2077》当卖点，苹果终于认真做游戏了？

Mac mini 的发布稿里，苹果拿《Cyberpunk 2077: Ultimate Edition》的光追性能当卖点，评论区立刻嗅到了熟悉的味道。abricq：

> "Interesting that Apple quotes performances when playing Cyberpunk 2077! Maybe they will want to care more about gaming?" — abricq [thread 3]

> （有意思，苹果居然拿跑《赛博朋克 2077》来宣传性能！也许他们终于要在意游戏了？）

mcphage 直接给这个期待泼了冷水：

> "They include game metrics in their marketing often, because they know their customers care about gaming. But no—for whatever reason, it never translates into Apple caring about gaming. I don't get it, but that's the way it has been for a long time." — mcphage [thread 3]

> （他们经常在营销里放游戏数据，因为他们知道用户在意游戏。但不——不管什么原因，这从来不会变成苹果真正在乎游戏。我不懂，但一直如此。）

wlesieutre 的段子最传神：

> "With the 'game mode' and 'game porting toolkit' in recent history, I think there's one person at Apple who cares about gaming and every couple of years he escapes from the basement where they keep him locked up and manages to sneak something into the release branch." — wlesieutre [thread 3]

> （从近年的"游戏模式"和"游戏移植工具包"看，我觉得苹果内部有一个人在乎游戏，每隔几年他就从被关着的地下室逃出来，偷偷往发布分支里塞点东西。）

### 内存带宽：M6 被 M5 Pro 甩开

Mac mini 帖子里还有人仔细比了芯片规格，发现 M6 的带宽并不理想。rcarmo：

> "The big difference you're not looking at is the memory bandwidth. The M5 Pro has nearly twice the one of the M6: 170GB/s ... 307GB/s ... That is also the factor you want to take into account for AI inference, of course." — rcarmo [thread 3]

> （你没注意到的最大区别是内存带宽。M5 Pro 几乎是 M6 的两倍：170GB/s 对 307GB/s。AI 推理当然也要考虑这个。）

想跑本地模型，Mac Studio 帖里的 kamranjon 顺手算过一笔账：M5 Pro 版 Mac mini 配 64GB 内存要 2,899 美元——比基础 M6 版贵出一大截。[thread 2]

## 典型观点一览

| 立场 | 用户 | 一句话 |
|------|------|--------|
| 本地 AI 拥趸 | rvz | 苹果早就在终点线，不需要参加 AI 军备竞赛 |
| 冷静派 | llm_nerd | 苹果没建 GPU 数据中心，但绝对拼过 AI |
| 买 token 派 | intrasight | 2.5 万买机不如买房，按需买 token 更划算 |
| 买机派 | bilbo0s | 需要推理隐私，就该掏钱买机器 |
| 硬件派 | mhast | 塞得进显存，老 3090 比 M4 Max 快一倍 |
| Linux 派 | bel8 | 苹果一两个工程师就能救 Linux，但选择无视 |
| 价格史论 | mikestew | Dvorak 的"电脑永远 3000 美元"大致成立 |
| RAM 失算 | varispeed | 苹果只顾 CPU 忽略内存，被市场打脸 |
| 告别低价 | Ambroos | 超便宜 Mac mini 的日子结束了 |
| 悲观派 | timpera | 人们买不起电脑时，会发生什么 |

## 总体情绪

这场讨论有两条主线。一条是技术叙事之争：苹果把发布会押在"本地 AI"上，评论区有人叫好——统一内存 + 2nm 自研芯片确实是别家没有的组合拳；但也有人提醒，1.2TB/s 带宽只有 RTX 5090 的 2/3，老 3090 在模型塞得下时照样吊打顶配 Mac。另一条是价格账本之争：顶配 2.5 万美元、内存每 GB 25 美元、欧洲再加 20% 增值税，让"本地推理"从技术优势变成了财务决策。

最尖锐的对比藏在细节里。苹果发布会上讲的是 512GB 内存跑千亿参数模型，评论区算的是这 512GB 要 2.5 万美元，而这笔钱存银行利息就够永远付订阅费。苹果把 AI 的下一个战场定在了本地，而 HN 在问：本地，到底值不值这个价。

## 引用帖子

| # | 标题 | URL |
|---|------|-----|
| 1 | Apple introduces M6 and M5 Ultra | https://news.ycombinator.com/item?id=49433292 |
| 2 | Apple introduces new Mac Studio with M5 Max and M5 Ultra | https://news.ycombinator.com/item?id=49433316 |
| 3 | Apple unveils a more powerful Mac mini featuring the all-new M6 and M5 Pro | https://news.ycombinator.com/item?id=49433450 |

## 免责声明

<div class="disclaimer">
本摘要基于 HN 帖子 "Apple introduces M6 and M5 Ultra"、"Apple introduces new Mac Studio with M5 Max and M5 Ultra" 与 "Apple unveils a more powerful Mac mini featuring the all-new M6 and M5 Pro" 的讨论整理而成，不代表本网站立场。引文内容版权归原作者所有。
<br><br>
<em>本摘要由 AI 模型辅助生成：deepseek/deepseek-v4-flash</em>
</div>
