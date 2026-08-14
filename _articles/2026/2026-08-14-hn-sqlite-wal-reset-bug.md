---
layout: post
title: "SQLite 十六年的 WAL-Reset 老 bug 被 Tailscale 揪出 — HN 讨论摘要"
date: 2026-08-14
categories: [articles]
excerpt: >-
  六个月 19 次数据库损坏，真相是 SQLite 里一个藏了十六年的竞态 bug——而触发它，恰恰是"正确地"用 SQLite。HN 1176 分热帖，评论区从"该不该用 SQLite"吵到"单点故障"与 AI 测数据库。
tagline: >-
  SQLite 埋了十六年的雷，被 Tailscale 一脚踩中：手动 checkpoint 太激进，谁都跑不掉。
---

## 原文概要

8 月 12 日，Tailscale 官方博客发表文章 "How we tracked down a 16-year-old SQLite bug"（我们如何追踪一个十六年的 SQLite bug），两天内登上 HN 热门榜，拿下 1176 分、227 条评论。文章从去年底那段"摇摇欲坠"的稳定性说起：当时的在线率非常不稳，而几乎所有故障都指向同一个深处——SQLite。

Tailscale 的控制平面按 shard 划分，每个 shard 持有自己的 SQLite 数据库，由一个 Go 进程独占访问。这正是 SQLite 官方推荐的单写者用法——"boring technology"（无聊技术）的忠实信徒。备份管线每几分钟对整个数据库做一次快照，完整上传到 S3，这套体系自 2023 年初起一直平稳运行。

转折发生在去年 8 月：读取 S3 备份的数据管线报错，`PRAGMA integrity_check` 确认数据库损坏。此后六个月里，损坏一共出现 19 次。每次修复都要停掉整条 shard 的控制平面进程，早期一次停机超过一小时；停机期间设备上线拿不到对端列表，就无法建立新的 WireGuard 连接。更糟的是没有共同触发条件——不绑定某个 shard、客户、功能、时段或负载，也没法合成复现，只能靠被动遥测等它再现。中间还有一个 10 月到 12 月的安静期，随后它作为"圣诞节礼物"又回来了。

真正的突破口有两个。其一是 Tailscale 自建的事务日志管线：把每条修改数据库的 SQL 流式记录到独立日志，回放即可绕开损坏点恢复。结果在两次事故里日志无法干净回放——一个事务已提交的数据，后面的事务居然看不见，"写入凭空消失了"。其二是 SQLite 开发者为排查 checkpoint 问题开发的新工具 `tmstmpvfs` shim：在虚拟文件系统层外加一层包装，记录所有数据库变更。这两个线索最终指向一个罕见的竞态：写入发生在 checkpoint 的特定时点，checkpoint 误以为某些页面已从 WAL 拷回主库、实际没有，数据永久丢失。

SQLite 开发者把它命名为 "WAL-Reset bug"，估计至少存在 16 年，稀罕到不得不在测试环境加代码主动触发。修复在 3.52.0 发布，但升级又踩了第二个坑：13 个数据库误报损坏，根源是"过期表达式索引"——Tailscale 把高精度时间戳存成文本、再用生成列转浮点，而 3.52.0 的一个优化悄悄改了文本转浮点的舍入行为。SQLite 随即撤回 3.52.0，改发只含该修复的 3.51.3；Tailscale 则把时间戳降到整数秒。随后他们给驱动打了补丁，当 checkpoint 与写入重叠时记录告警，两个月后名为 "SQLitePartyMode" 的告警终于响起——证明竞态确实在生产中出现。此后四个月，零事故。

文章的落点是一句自省："running boring technology in a non-standard way is a risk"（用非标准方式运行无聊技术，是一种风险）。Tailscale 手动接管 checkpoint、且跑得极其激进，正是这趟"非常规路径"把他们送上了 SQLite 的雷区。

## 讨论焦点

### 公司资助开源的新样本

simonw 抓到了文章里最耐人寻味的一个细节——Tailscale 出钱让 SQLite 开发者开发了那个调试工具：

> "Interesting example of a company funding open source - in this case paying for the development of a new and very specific debugging tool." — simonw

> （公司资助开源的有趣样本——这次是出钱开发一个全新且高度专用的调试工具。）

saghm 顺着把这件事放大了：不只是为当下的问题付费，还愿意为"以后更好避免"付费：

> "They were willing to pay to get help solving the problem, and then pay again to make sure that the problem is easier to avoid in the future! That kind of long-term thinking seems pretty rare nowadays..." — saghm

> （他们愿意花钱请人帮忙解决问题，还愿意再花一次钱，让这类问题以后更容易避免。这种长期思维如今相当罕见了……）

x0x0 给这种模式正了名：数据库圈早就这么干了。

> "It's common for databases. This is Percona's business model. They employ core pg/mysql developers and you can buy a support package from them." — x0x0

> （在数据库领域这很常见，Percona 就是这个商业模式：雇核心的 pg/mysql 开发者，再卖支持服务包。）

最有娱乐性的反方来自 SchemaLoad，一句话把"自己修"和"AI 重写"的两种世界观摆上了台面：

> "They could have just spent $300,000 in tokens to AI slop rewrite SQLite in Rust." — SchemaLoad

> （他们本可以花 30 万美元的 token，让 AI 用 Rust 把 SQLite 重写成一坨垃圾。）

edoceo 的回应则戳中了要害：

> "That would be lame. Instead they spent less and improved the world for everyone who used SQLite (which is really a lot of people)" — edoceo

> （那太逊了。他们花得更少，却让所有用 SQLite 的人都受益——那可真是一大群人。）

### "lite" 之名的战争

文章大获好评的同时，一个经典问题被重新点燃：SQLite 到底适不适合这种规模？pseudohadamard 率先发难：

> "SQLite has a 'lite' in the name for a reason, but it's often pushed into places where it's being asked to do things it was never really designed for." — pseudohadamard

> （SQLite 名字里带 "lite" 不是没道理的，但它常被推去做一些设计之初从没打算做的事。）

zbentley 立刻为 SQLite 正名——这个 bug 和 "lite" 没关系，它属于数据库的共性领域：

> "This particular bug doesn't seem to arise from SQLite's 'lite' nature. It's a TOCTOU inside the DB when applying WAL segments in a checkpoint, which is a pattern used in extremely similar ways by Postgres and MySQL." — zbentley

> （这个 bug 似乎与 SQLite 的 "lite" 属性无关。它是 checkpoint 应用 WAL 段时数据库内部的一个 TOCTOU，而 Postgres 和 MySQL 也用了极其相似的机制。）

geocar 则直接否定了 "lite" 这个说法，还给 SQLite 贴了更高的标签：

> "I would not think of SQLite as 'lite' anything. It's SQL In The Executable. It has a better security and data-durability track record than both Postgres and MySQL..." — geocar

> （我不会把 SQLite 想成任何意义上的 "lite"。它是"可执行文件里的 SQL"。它的安全性和数据持久性记录比 Postgres 和 MySQL 都好……）

jlokier 补了个冷知识，现场拆了 "lite" 的词源：

> "It's actually SQL 'ite' as in rocks, minerals and fossils. Their version control system is called 'Fossil'." — jlokier

> （它其实是 SQL "ite"，就像岩石、矿物、化石里的那个 "ite"。他们的版本控制系统就叫 "Fossil"。）

petcat 给出了最冷峻的总结——文章本身反而是最好的反证：

> "Well this whole article is about a company discovering a catastrophic corruption bug even though they were using it as designed. I think the lesson is that if you're ever actually worried about concurrency then just don't use sqlite. We can see here that concurrency is hard and the bugs are old and deep." — petcat

> （这篇文章通篇讲的就是一家公司按设计用法使用，却踩中灾难性损坏 bug。我觉得教训是：如果你真的担心并发，那就别用 SQLite。我们看到并发很难，bug 又老又深。）

### 为什么偏偏是 Tailscale

文章里有句话回答了所有人的疑问：为什么千千万万 SQLite 用户里，偏偏是你？Ariarule 觉得这句太重要了：

> "Odd not to highlight the sentence where they answer the obvious question 'Why Tailscale in particular?' ... They also explained why we were more likely to hit the bug than other SQLite users: we take manual control of the checkpointing process, and we checkpoint very aggressively. Even a bug triggered by a rare condition was bound to hit us eventually." — Ariarule

> （他们明明回答了"为什么偏偏是 Tailscale"这个显而易见的问题，却没人突出这句话……他们说：我们手动接管 checkpoint 流程，而且跑得非常激进。哪怕是个极罕见条件下才触发的 bug，也迟早会被我们碰上。）

inigyou 把触发条件推演得更具体了：

> "The bug requires two checkpoints in very quick succession, which presumably isn't something sqlite would do on its own, as it would be a pointless waste of performance." — inigyou

> （这个 bug 需要两次 checkpoint 极速连续发生，SQLite 自己大概不会这么做，因为那纯粹是浪费性能。）

dboreham 则提醒大家放平心态：这种查不到根因的数据损坏，在数据库世界里才是常态。

> "Quick note that data corruption bugs that are impossible to reproduce are not uncommon (perhaps they're the norm)..." — dboreham

> （顺带一提，无法复现的数据损坏 bug 并不罕见——也许它们才是常态……）

### "单点故障" 之争

文章的另一个爆点是：每次损坏都要停掉整条 shard 的控制平面。riknos314 直言不讳：

> "Gotta love single points of failure..." — riknos314

> （单点故障，你懂的……）

tptacek 用著名的"贝尔曲线梗"给出了最强反驳——消灭单点故障的代价，往往是更高的故障率：

> "This is maybe one of the purest examples of the Bell Curve Meme in software engineering. The things you would do to the system Tailscale operates to eliminate all single points of failure would make the system less resilient, and increase failures." — tptacek

> （这可能是软件工程里贝尔曲线梗最纯粹的例证之一。为了让 Tailscale 的系统消灭所有单点故障而做的改造，反而会让系统更不健壮、故障更多。）

Spivak 把视角拉到了"运维者 vs 用户"的错位：

> "This is a great example of outages looking different from the perspective of the operator vs the user. Because there's many shards the blast radius of failure is contained to a small subset of users but for those users it's an outage." — Spivak

> （这是"故障在运维者和用户眼中完全不同"的绝佳例子。因为 shard 很多，故障影响面被限制在一小撮用户里，但对那部分用户而言它就是一次宕机。）

arjie 补充了一个让人安心的细节——控制平面挂了，数据平面还在：

> "You don't need the control plane most of the time. I had a zero downtime headscale upgrade because once the nodes negotiate through the control plane they can talk to each other all the time. The data plane is peer to peer." — arjie

> （大多数时候你根本不需要控制平面。我经历过一次零停机的 headscale 升级，因为节点一旦通过控制平面完成协商，它们之间就一直能互相通信。数据平面是点对点的。）

### 跑题：SSO 与魔法链接

评论区顺着"Tailscale 做对了什么"聊到了唯一的槽点——它只支持 SSO，不支持账号密码。LoganDark 抱怨道：

> "My only gripe is that they have some really weird SSO requirements like GitHub, etc. and then that provider becomes a permanent part of your identity." — LoganDark

> （我唯一的不满是他们有一些很奇怪的 SSO 要求，比如用 GitHub，然后那个提供商就成了你身份里永久的一部分。）

semiquaver 站在厂商角度解释了为什么这么设计：

> "Being an identity provider for anything important is the freaking worst. Exposes you to a million problems. You need human support for login problems and lost MFA tokens, and you are an attack magnet." — semiquaver

> （为任何重要的东西做身份提供商都是最糟的。会暴露出一百万个问题。登录问题和丢失 MFA 令牌都需要人工支持，而且你就是攻击磁铁。）

miki123211 顺势推起了魔法链接，l72 则立刻以真实用户身份反对：

> "Which is why you want magic links. Don't be the identity provider, have the email host be the identity provider (which it is anyway if you have a forgot password prompt)." — miki123211

> （所以你需要魔法链接。别做身份提供商，让邮件服务商当（反正有"忘记密码"提示时它本来就是）。）

> "As a user, I really don't care for magic links. The whole, start the log-in process, switch context, wait for email (sometimes up to a minute), click on it, have it open a new tab in a different window than where I started is just a pain." — l72

> （作为用户，我真的很不喜欢魔法链接。整个流程——开始登录、切换上下文、等邮件（有时要等一分钟）、点开、在另一个窗口的新标签页里打开——真是折磨。）

### AI 在帮 SQLite 找 bug

有读者顺着"SQLite 太稳了所以 bug 藏得深"往下想：让 AI 来挖不正好？d-us-vb 分享了 Richard Hipp 亲口讲的现状：

> "Richard Hipp's recent talk at Software Should Work explains that AI agents have been testing SQLite and they've gotten a deluge of new bug reports from the fuzz-like testing they can do. But they do not do this in house; hobbyists and other organizations do this in their own internal agent-driven fuzzing." — d-us-vb

> （Richard Hipp 最近在 Software Should Work 的演讲提到，AI agent 一直在测 SQLite，它们的类模糊测试带来了大量新 bug 报告。但他们自己不在内部这么干；是业余爱好者和别的组织在做自己的 agent 驱动模糊测试。）

jeffbee 则分享了用块设备故障注入层给数据库"上刑"的往事——FoundationDB 自称测试完善，却在一层故障注入下立刻暴露多个缺陷。

## 典型观点一览

| 立场 | 用户 | 一句话 |
|------|------|--------|
| 赞赏资助开源 | simonw | "出钱开发专属调试工具，这是资助开源的好样本。" |
| 赞赏长期投入 | saghm | "先花钱解决问题，再花钱让问题更好避免——这种长期思维很少见。" |
| 商业模型 | x0x0 | "Percona 就靠雇核心开发者卖支持包，数据库圈这很正常。" |
| 反讽重写派 | SchemaLoad | "不如花 30 万美元 token 让 AI 用 Rust 重写 SQLite。" |
| 站 SQLite | geocar | "SQLite 是'可执行文件里的 SQL'，记录比 Postgres 和 MySQL 都好。" |
| 质疑规模 | pseudohadamard | "名字带 'lite' 有原因，别让它干没设计过的事。" |
| 并发教训论 | petcat | "真担心并发就别用 SQLite，并发很难，bug 又老又深。" |
| 反对单点论 | tptacek | "消灭所有单点故障，反而会让系统更不健壮。" |
| 理解单点论 | riknos314 | "每次损坏都要停整条 shard，单点故障没跑了。" |
| 魔法链接派 | miki123211 | "别做身份提供商，让邮件服务商当。" |
| 讨厌魔法链接 | l72 | "登录流程绕来绕去等邮件，太折磨。" |

## 总体情绪

这场讨论其实是一场"责任归属"的辩论。一派认为问题出在 Tailscale 的非常规用法——手动接管 checkpoint 还跑得激进，等于主动提高踩雷概率；另一派认为 bug 埋了 16 年这件事本身就证明并发之难——即便"按设计使用"，深坑依然是深坑。有趣的是，两边都没有否定 SQLite 本身，反而把争论升华成了"无聊技术到底有多可靠"的信任投票。

贯穿全场的还有一个更暖的主线：几乎没人质疑 Tailscale 的处置方式——花钱请专家、开发开源调试工具、公开完整复盘。把十六年的雷排掉，受益的是所有 SQLite 用户，这或许比"躲开雷"本身更有价值。正如文章自己的落点：真正危险的从来不是 SQLite，而是"自以为走出了一条别人没走过的捷径"。SQLite 的雷埋了十六年，但让所有人安全的不是绕开它，而是有人愿意把它挖出来。

## 引用帖子

| # | 标题 | URL |
|---|------|-----|
| 1 | Tracking down the 16-year-old WAL-reset SQLite bug | https://news.ycombinator.com/item?id=49272832 |

## 免责声明

<div class="disclaimer">
本摘要基于 HN 帖子 "Tracking down the 16-year-old WAL-reset SQLite bug" 的讨论整理而成，不代表本网站立场。引文内容版权归原作者所有。
<br><br>
<em>本摘要由 AI 模型辅助生成：deepseek/deepseek-v4-flash</em>
</div>
