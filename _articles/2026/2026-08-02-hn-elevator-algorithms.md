---
layout: post
title: "电梯调度算法：更智能反而更慢？ — HN 讨论摘要"
date: 2026-08-02
categories: [articles]
excerpt: >-
  电梯的 Kiosk 目的地调度反而比传统上下按钮更慢——丢掉了每 5 秒一次的重调度灵活性，信息更多却更差。
tagline: >-
  等电梯最久的那次，决定了你对电梯的全部印象——p90 才是真相。
---

## 原文概要

7 月 31 日，john.fun 发布了交互式科普文章 "Elevators"，用动画模拟拆解电梯调度算法，2 天内在 HN 首页拿下 1582 分。

文章从最简单的算法讲起：SCAN（1961 年专利）让电梯从大厅一路到顶层再折返，沿途接人；LOOK 则只到最高请求楼层就掉头，这是多数人熟悉的逻辑。多电梯时，中央调度器把每个请求分配给最近的轿厢——但这只是起点。

真正的重头戏是奥的斯（Otis）的 RSR（Relative System Response，相对系统响应）算法：每台电梯得到一个评分，公式为"到达接客点的预计时间 + 载重惩罚 + 同向防聚集惩罚 − 方向匹配奖励 − 附近空闲奖励 − 低载奖励"，系统每 5 秒重新优化一次。一个已被 A 电梯接管的乘客，可以因为 A 遇到延误被改派给 B 电梯。

文章最有价值的结论是个反直觉结果：装了楼层 Kiosk 的目的地调度（Destination Dispatch）系统，在多数情况下比传统的上下按钮**更慢**。Kiosk 强制乘客进入指定电梯，而传统按钮让系统可以每 5 秒灵活重排——"状态在 30 秒后就可能完全变了，系统却无法适应"。只有 8 台以上电梯的超高楼里，Kiosk 才可能胜出。文章还附带了可交互的全参数模拟器，作者在结尾劝读者："电梯听到了你，它只是要想的事情很多。"

## 讨论焦点

### 目的地调度：反直觉的失败

文章最出圈的观点是 Kiosk 反而更慢，评论区里真实用户的吐槽印证了这一点。

> "Besides struggling to find the car I've been assigned to, sometimes you really have to hustle across the lobby to catch it. Then you also run into visitors that assume it's a normal car and can hit a floor button when the get in, only to realize they've walked into a car without buttons." — teepo

> （除了要努力找到被分配的电梯，有时你还得在大厅里一路小跑去赶它。然后你还会撞上把轿厢当普通电梯的访客——他们进来就按楼层按钮，才发现这台轿厢里根本没有按钮。）

> "I work in a building with Destination Dispatch elevators so I'm used to them. I have the opposite problem where I'll get into a normal elevator and just stand there without pushing anything." — why_at

> （我在一栋用目的地调度的楼里上班，习惯了以后反而出了相反的问题——走进普通电梯，就站着发呆不按任何按钮。）

quietsegfault 补充了 Kiosk 模式更容易引发"无效停靠"：不熟悉的访客以为按一次就代表所有人，全挤进电梯却没人按楼层，结果满员的电梯到中间层还停下来接人，谁也上不去。

### "智能电梯"的生意经

jmyeet 把话题从算法引向了商业逻辑，认为"智能电梯"很多时候是"找问题的解决方案"。

> "There's a deeper issue here though and that is solutions looking for a problem. Nobody is making money from up and down buttons. They are fromn selling smart elevator solutions. And you see this everywhere in life. It basically devolves into rent-seeking behavior. Salespeople wine and dine a couple of people responsible for making decisions and then make bank on selling something nobody wants or needs as well as the constant maintenance and updates." — jmyeet

> （这里有个更深层的问题：这是"寻找问题的解决方案"。没人能从上下按钮上赚到钱，他们赚的是卖智能电梯方案的钱。这在生活里随处可见，基本退化成寻租行为。销售请决策者吃饭喝酒，然后靠卖没人真正需要的东西——以及后续的维护和升级——大赚一笔。）

他举了自己前雇主的例子：装了"智能"电梯系统后，下班想下楼时电梯经常跳过他的楼层——因为另一台已被分配——而到楼里那台早已满载。他直言："真正管用的是直达电梯和空中大堂，我还没见过哪台智能电梯实现得好。"

### 上下按钮：最困难的人机交互

olex 贡献了一个现象级话题：总有人同时按上下两个按钮。

> "Almost always I find someone will press both, because 'then the elevator comes faster'. Completely ignoring the fact that they end up going the wrong way first half the time, and adding an unnecessary halt for everyone already in there. How hard can it be to understand?.." — olex

> （几乎总能碰到有人把两个都按了，理由是"这样电梯来得更快"。完全忽略他们一半概率会先坐反方向，还给里面所有人加了一次多余的停靠。理解这个有这么难吗？……）

summermusic 给出了地域观察：

> "I haven't ever seen anyone do this in the United States, but I saw it in China and Italy." — summermusic

> （我在美国从没见过有人这么做，但在中国和意大利见过。）

the_af 则吐槽家人："My wife always randomly hits the up or down button, then gets upset if I explain why she should only pick the one she really wants. She forgets the next time. I think some people never really understand how elevators work."（我老婆总随手按上下键，我一解释"只按你要的方向"，她还不高兴，下次照样忘。有些人可能真的永远理解不了电梯的工作原理。）

### 满载难题：算法算不出"挤不进去"

文章提到 RSR 把载重纳入评分，读者们立刻想到了真实的满载惨案——会议酒店周一早晨。

> "I've been to a couple of larger conferences where on the Monday morning after, the hotel elevator was just hammered. Everyone wanted to go down, and the elevator would dutifully stop on every single floor no matter how full it was. If you were mobility disabled on the 2nd floor, you were basically fucked if you had a flight to catch." — StableAlkyne

> （我去过几个大型会议，周一早上酒店的电梯被挤爆了。所有人都要下楼，而电梯不管多满都尽职地在每一层停。如果你行动不便住在二楼又赶飞机，那基本就完蛋了。）

Rebelgecko 补充了一个冷知识：

> "Some elevators have sensors that'll bypass pickups after a certain point. Super helpful for furry conventions" — Rebelgecko

> （有些电梯装了传感器，超过一定载重就跳过沿途请求。对 furry 大会特别有用。）

### 电梯算法与磁盘寻道

不少读者一眼看出电梯调度和经典计算机问题的亲缘关系。

> "Disk drive read/write algorithms have a lot in common with elevator algorithms. At least they did in the days of physical heads moving across a platter." — SoftTalker

> （磁盘读写算法和电梯算法有大量共通之处。至少在磁头还在盘面上物理移动的年代是这样。）

dbcurtis 从工程集成视角补充了另一个反差：站在大厅等电梯觉得度秒如年，但从调度端看，电梯几乎从不闲着——"它是忙成一团的，正常时段里轿厢很少有闲置的时候。"他还留下一个经典段子："If an elevator mechanic says: 'I'll meet you first thing in the morning.' He means something like 4:00AM."（如果电梯维修工说"明早第一时间见你"，他的意思是凌晨四点左右——他们要赶在人们上班前干完活。）

### 火灾里别坐电梯

cyberax 的科普把话题从调度拉向安全，解释了一个反直觉事实。

> "Modern elevators have regen braking, so they can recover most of the energy spent on going down. ... Edit: that's also why you shouldn't use elevators in a fire. If the brakes in the elevator machine room fail, the cab won't crash down. It will go _up_, possibly dragging you into the fire. Many firefighters died because of that." — cyberax

> （现代电梯有能量回馈制动，能回收大部分下行消耗的能量。……这也是为什么火灾时不能坐电梯。如果机房里的制动器失灵，轿厢不会坠落，反而会往上走，可能把你直接带进火里。很多消防员就是因此牺牲的。）

配重的存在意味着空载轿厢下行更耗能，而火灾中失效的制动器会让轿厢被配重拽着上行——这正是"火灾走楼梯"这条铁律背后的物理。

### 电梯调度游戏：绕不开的 SimTower

评论区还炸出了整整一代电梯模拟游戏。brandonpelfrey 推荐了网页游戏 Elevator Saga：

> "For folks that have never seen elevator scheduling the game: https://play.elevatorsaga.com/ Enjoy this rabbit hole :D" — brandonpelfrey

> （没玩过电梯调度游戏的朋友：https://play.elevatorsaga.com/ 祝你们在这个兔子洞里玩得开心。）

CobrastanJorji 抛出怀旧杀招："This is great, but to me, the definitive elevator scheduling game was SimTower."（这确实很棒，但对我来说，定义级的电梯调度游戏还是 SimTower。）somat 说年少时玩不懂 SimTower，多年后才知道"它其实就是把电梯模拟器加厚了一点"的产物；wlesieutre 则挖出典故——Maxis 员工亲口承认《模拟大厦》就是围绕"从一个日本人那里买的真实电梯模拟程序"构建的。

bentcorner 的评论更是让所有玩过的人会心一笑：

> "I would always get a chuckle out of seeing some poor soul waiting 3 hours to go down a few floors after work, only because I failed to add stairs to the lobby." — bentcorner

> （每次看到某个倒霉鬼下班后苦等三个小时就为了下几层楼，我都能笑出声——只因为我在大厅忘了修楼梯。）

## 典型观点一览

| 立场 | 用户 | 一句话 |
|------|------|--------|
| 反智能电梯 | jmyeet | "没人能从上下按钮赚钱，寻租而已。" |
| 亲历吐槽 | teepo | "访客进 Kiosk 轿厢才发现没按钮。" |
| 习惯错位 | why_at | "进普通电梯反而忘记按按钮。" |
| 满载血泪 | StableAlkyne | "满员电梯还层层停，残疾人赶飞机完蛋。" |
| 算法亲缘 | SoftTalker | "磁盘寻道和电梯调度一个套路。" |
| 安全科普 | cyberax | "制动失灵轿厢会往上冲进火里。" |
| 怀旧游戏 | CobrastanJorji | "定义级电梯游戏还得是 SimTower。" |

## 总体情绪

评论区对文章的反直觉结论普遍认同——"目的地调度更慢"这个结果既意外又符合直觉，因为它点破了调度问题的本质：信息的增加，抵不上灵活性的损失。工程师们从磁盘调度、负载均衡一路联想到自家写字楼的吐槽，游戏玩家则顺着 SimTower 和 Elevator Saga 追忆了一整代"把排队做成游戏"的作品。

这场讨论最动人的地方在于它把两群人连在了一起：写算法的人和每天按电梯按钮的人，站在同一部电梯的两侧。文章结尾那句话被反复引用，或许是最好的总结——电梯听到了你，它只是要想的事情很多。

## 引用帖子

| # | 标题 | URL |
|---|------|-----|
| 1 | Show HN: Elevators | https://news.ycombinator.com/item?id=49124218 |

## 免责声明

<div class="disclaimer">
本摘要基于 HN 帖子 "Show HN: Elevators" 的讨论整理而成，不代表本网站立场。引文内容版权归原作者所有。
<br><br>
<em>本摘要由 AI 模型辅助生成：deepseek/deepseek-v4-flash</em>
</div>
