---
layout: post
title: "没人记得预防问题的功臣 — HN 讨论提炼"
date: 2026-06-13
categories: [articles]
excerpt: "救火的英雄人人夸，防火的功臣没人记得。扁鹊三兄弟的比喻在 HN 引发了一场关于组织激励的疲惫共识。"
tagline: "如果你的团队离了你就不转，那不是你厉害，是你们公司有病。"
---

## 原文概要

一篇 2001 年的 MIT Sloan 经典论文 (Repenning & Sterman), 讨论组织管理中的核心悖论:

> "Nobody ever gets credit for fixing problems that never happened."

预防问题的功劳看不见. 救火的英雄人人夸. 这种激励错位导致组织系统性地偏向救火而非防火.

论文本身来自 MIT Sloan Management Review. 24 年后在 HN 上以 745 分、255 条评论再次引爆讨论. 评论区延伸到组织行为、IT 管理、医疗体系、甚至中国古代哲学.

来源: HN 热门榜 (/best)

---

## 讨论焦点

### 1. 扁鹊三兄弟——中国古代版同一洞察

顶楼引用了一则中国典故, 获得了本场最高共鸣:

> "King Wen of Wei asked Bian Que: 'Of you three brothers, all physicians, who is the finest?'
> Bian Que replied: 'My eldest brother sees illness in the spirit, before it has taken shape, and removes it unseen; therefore his name is known only within our household. My second brother treats illness when it is but a hair's breadth from appearing; therefore his name does not travel beyond our village lane. As for me, I pierce the blood vessels, administer strong medicines, and cut open the flesh. Thus, by such visible acts, my name has spread among the lords.'"
> — markus_zhang
> （魏文王问扁鹊: 你们三兄弟谁医术最高? 扁鹊答: 大哥在病成形前就去除, 名声不出家门; 二哥在病刚露头时治疗, 名声不出巷子; 我扎针放血开刀, 名声传遍诸侯.）

一位读者将其意译为软件工程版:

> "My eldest brother prevents bugs before they ever arise, so his skills are only known to the dev team he's on. My second brother casually fixes bugs as soon as they appear, so his skills are known to the entire tech department. As for me, I rush around putting out fires everywhere, so everyone in the company knows of me."
> — sirlaser
> （大哥在 bug 出现前就预防, 技能只有团队知道; 二哥在 bug 刚出现就修, 全技术部知道; 我四处救火, 全公司都知道.）

### 2. 救火队拿预算, 防火队被裁员

一位用户的亲身经历揭示了这种激励错位的现实后果:

> "I've been in those companies where 'struggling departments' ended up getting all the praises and raises in budget the following quarter because of the heroic saves they did... for stuff they totally caused on themselves. Meanwhile, my perfectly purring department was struggling to keep the lights on." — keyle
> （挣扎的部门因为英雄救火获得嘉奖和预算增加——火还是他们自己放的. 我丝滑运转的部门却在为维持基本运营挣扎.）

> "It's a serious problem in this industry due to the disconnect between non-technical management (who understands how to double click) and engineering (who holds the company standing)."
> （非技术管理层理解的东西和工程部实际支撑公司运转的东西之间存在严重脱节.）

### 3. 让痛苦传导——故意不修?

一种争议性观点: 应该让问题爆发, 让管理层感受痛苦.

> "By building pain into the system. If your hands dealt with injury directly without sending pain signals up to your brain, you'd never change the behaviour that led to that harm. Like it or not, sometimes the best thing for an organisation isn't to just fix every problem and prevent it from bubbling up; it needs to be treated like a learning opportunity for org leadership, which means sending the pain signals upward before just repairing it." — dchevell
> （在系统中建立痛感传导机制. 如果不把疼痛信号传给大脑, 你就永远不会改变导致伤害的行为. 有时让问题浮出水面比默默修好对组织更有利.）

但也有人指出这种策略在现实中可能适得其反:

> "The problem is that management witnesses the pain, but the response isn't to adjust behavior, it is then to punish the limb where the pain originated from." — thx67
> （问题在于管理层看到了疼痛, 但反应不是调整行为, 而是惩罚发出疼痛的身体部位.）

### 4. Stack Ranking 毒性——被迫制造英雄

在强制排名的公司, 工程师不得不玩弄系统:

> "If you're at a company where 'meets expectations' means you're going to get the stick, and you're supposed to redefine expectations every year... then don't do anything preventative. The optics are better when you take the 3am on-call and fix the issue. Be the savior that the VPs praise in the next meeting." — qurren
> （在那些"符合预期"等于要你走人的公司, 别做预防性工作. 凌晨三点修故障的视觉效果更好. 做 VP 们下次会议上表扬的英雄.）

> "They set the rules of the game, you just play the game. The rules were their choice."
> （他们定了游戏规则, 你按规则玩. 规则是他们选的.）

但立刻有人反驳:

> "Obviously the only winning move here is not to play. If you choose to play, you're complicit." — Sharlin
> （唯一的赢法是不玩. 如果选择参与, 你就是共犯.）

### 5. 沟通是关键——让预防可见

多位经验丰富的管理者分享了让预防工作被看见的实际方法:

> "In the 'ticket closing' scenario it's important to open a ticket, regardless of how trivial, for every code action taken. For every meeting attended. For every scenario dodged. If tickets are the way to score then write tickets." — bruce511
> （如果工单是计分方式, 那就为每次代码操作、每次会议、每次避免的场景开工单. 即使微不足道.）

> "I'll ask for something preventative. They ask 'is it a need?' I'll say: 'we can function without, but that means a 5-10% chance in the next 6 months of having a major failure.' We then decide how much that risk is worth. If the thing I warned them about comes, I can point to the receipts." — Forgeties79
> （我提出预防需求, 他们问"必须吗?" 我说: 没有也能运转, 但未来六个月内 5-10% 概率出大事. 然后让他们决定这个风险值多少. 如果出事了, 我有据可查.）

### 6. "Brent" 困境——拯救者还是制造者?

引用《凤凰项目》中的经典角色:

> "I had a former boss call me Brent after reading The Phoenix Project. That made me step back and stop helping so much. Everything seems worse, but whatever — if that's what they want."
> — al_borland
> （前老板在读了《凤凰项目》后叫我 Brent. 这让我退一步, 不再帮那么多. 看起来一切更糟了, 但随便吧——如果那是他们想要的.）

（《凤凰项目》中 Brent 是唯一懂关键系统的人, 所有故障都必须由他解决. 他既是救火英雄, 也是瓶颈——没人能替代他. 当管理者认出某人是 Brent, 意味着他们开始意识到: 单点依赖不是荣耀, 是组织脆弱性. al_borland 选择退一步后, 问题更频繁地浮出水面——但这正是管理者必须面对的考题.）

### 7. "Saboteur" 工程师——反向英雄

一位 35 年经验的老兵分享了他的团队建设哲学:

> "I considered crucial to always have in my teams a 'saboteur' engineer — the one who thought, found, came up with all the ways we could break a design, service, infra components, app, etc., when all the others were designing or operating for perfect or normal conditions."
> — netfortius
> （我一直认为团队里必须有个"破坏者"——当所有人都在设计完美方案时, 他在想我们怎么弄坏它.）

### 8. 这不是 IT 的问题——这是人类的问题

多位评论者指出, 这个问题远不限于软件行业:

> "Isn't this a universal problem, though? Even at home, if one kid does his thing quietly but another kid is difficult, what do we say? 'John has his problems but he is trying.' While his brother gets no praise for just doing his thing quietly." — akudha
> （这不只是软件行业的问题. 在家里也一样: 安静做事的孩子没人夸, 制造麻烦的孩子得到关注——'他在努力'.）

> "When things run smoothly, very few people notice. When things break, everyone notices." — al_borland
> （顺利运转时没人注意. 出问题时所有人都在注意.）

> "Things keep breaking — 'What are we paying you for?' Nothing ever breaks — 'What are we paying you for?' Management can choose their burden."
> — _carbyau_
> （一直出问题——"付你工资干嘛?" 一直不出问题——"付你工资干嘛?" 管理层选择他们的痛苦.）

> "This is literally one of the main reasons America spends so much on healthcare." — notJim
> （这本质上就是美国医疗支出如此高昂的原因之一.）

---

## 典型观点一览

| 立场 | 用户 | 一句话 |
|------|------|--------|
| 🟡 现象描述 | keyle | 救火部门获嘉奖, 防火部门被裁员 |
| 🔵 痛感传导 | dchevell | 让问题爆发, 让管理层感受痛苦 |
| 🔴 玩规则 | qurren | 系统奖励救火, 我就制造救火 |
| 🟢 不玩 | Sharlin | 唯一的赢法是不玩 |
| 🟡 沟通重要 | bruce511 | 开工单、留记录、让预防可见 |
| 🟡 风险语言 | Forgeties79 | 用量化风险而非技术语言沟通 |
| ⚪ 古老智慧 | markus_zhang | 扁鹊三兄弟: 大哥治病于未形 |
| ⚪ IT 版扁鹊 | sirlaser | 大哥预防 bug, 二哥修小 bug, 我四处救火 |
| ⚪ 角色设计 | netfortius | 团队里要有专职"破坏者" |
| ⚪ 不限于 IT | _carbyau_ | 出不出问题都是"付钱干嘛?" |

---

## 总体情绪

与 AI 话题的激烈辩论不同, 这场讨论带着一种**疲惫的共识**: 几乎所有人都遇到过这个问题, 几乎没人有完美解法. 管理层的注意力本能地偏向救火而非防火, 这不是某个公司的问题, 是组织行为学的基本特征.

讨论中罕见的共识: 让预防工作可以被看见——通过工单、风险量化沟通、事后复盘——是目前最实际的应对策略. 但要从根本上解决问题, 需要改变组织激励结构, 这远比写几行代码困难.

引用评论区的一句话: "A stitch in time saves nine… but I charge by the stitch."

---

## 引用帖子

| # | 标题 | 链接 |
|---|------|------|
| 1 | HN 讨论 | <https://news.ycombinator.com/item?id=48498385> |
| 2 | 原文 PDF (MIT Sloan) | <https://web.mit.edu/nelsonr/www/Repenning=Sterman_CMR_su01_.pdf> |

<div class="disclaimer">
**免责声明**: 本文是对 HN 讨论和 MIT 论文的编译与提炼. 引用的英文评论均取自原文. 所有观点来自 HN 评论者, 不代表本人立场.
</div>
