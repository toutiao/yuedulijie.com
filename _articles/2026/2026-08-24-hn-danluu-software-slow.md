---
layout: post
title: >-
  "软件没有理由再慢了"：AI 让性能优化的成本暴跌 — HN 讨论摘要
date: 2026-08-24
categories: [articles]
excerpt: >-
  danluu 的论文式长文：过去需要专业团队数月才能完成的性能优化，现在用 AI 几分钟就能跑通实验。但评论区吵的不是"优化变便宜"，而是"便宜的优化到底有没有人用"。
tagline: >-
  优化成本掉到地板价，但"慢"从来不是技术问题。
---

## 原文概要

danluu 在新长文里提出一个观点：LLM 让"性能优化"这件事的成本断崖式下跌，过去只有大公司或高利润项目才做得起的专项优化，现在任何人都能干。他从一个 viral 推特切入——有人说等大家用"超优化汇编"重写一切，LLM 导致的慢代码就会自食其果——然后论证这其实正在发生，只是方式不同。

文章用自己最近的实验做证据。他上次用 agent 循环一个月打造的 `FRE` 正则引擎（基于 rebar benchmark 套件）被"holdout benchmark"逼着从过拟合走向泛化。这次他又花几分钟打了几句话，让 agent 在 ripgrep 正常运行的同时，用另一个线程编译 native AOT 版本，跑完再切换过去。长查询有 2x-4x 提升，代表查询约 7% 提速——对一个"花几分钟打字"就能完成的实验来说不算差。

danluu 还拿自己的 Azul AI（一种桌游）说事：他说这是他见过的全球最强 Azul AI，比论文里的第二名强，但投入时间少两个数量级，还大部分在笔记本上跑。理由是 AI 替他把多线程、minimax/MCTS 双架构这种"过去需要高手团队"的活全干了。全文的主线是：优化不再是"值不值得"的问题，而是"想不想"的问题。

## 讨论焦点

### 慢不是技术问题，是优先级问题

0xbadcafebee 直接拆穿了标题的修辞——"没有理由"和"现在能做"是两回事：

> "There's no reason being very different than we can now do the thing easier. There are still tons of reasons for software to be slow, the biggest of which is priorities." — 0xbadcafebee

> （"没有理由"和"现在做起来更容易"完全是两码事。软件变慢的理由依然一大堆，最大的一条是优先级。）

他补了一段辛辣的实操建议：想让软件变快，就把 Python、TypeScript 换成 Go、Rust、C++，或者把预算从加功能挪到 profiling——但没人会这么做，因为"多慢才算慢？答案是：慢到吓到股东、或烦到用高配笔记本的开发者的程度。"

bell-cot 则从商业逻辑上补刀：大部分用户——按给软件公司贡献的利润加权——根本不在乎慢。

> "The vast majority of users - weighting by the profits they generate for software companies - obviously don't care about slow." — bell-cot

> （绝大多数用户——按他们给软件公司贡献的利润加权——显然不在乎"慢"。）

### 测试套件是 AI 优化的隐形基础设施

y1n0 提出一个被反复争论的核心论点：测试套件就是可执行规格，spec 越好，AI 给出的结果越好。

> "It's all about the test suite. The test suite becomes an executable specification, and the better the spec, the better the results you can get from AI." — y1n0

> （一切都取决于测试套件。测试套件变成了可执行的规格，规格越好，你能从 AI 得到的结果就越好。）

hodgehog11 把这话推到了"可证明"的高度：

> "No it really is about the test suite, and provably so. As another poster pointed out, speed is a superoptimization problem and the test suite provides the constraints. If the constraints are appropriately set, even a naive genetic algorithm will eventually improve the outcome over time." — hodgehog11

> （不，它真的取决于测试套件，而且是可以证明的。正如另一位网友指出的，速度本质上是一个超优化（superoptimization）问题，测试套件提供了约束。只要约束设得对，哪怕一个朴素的遗传算法，最终也能随时间推移改进结果。）

mlsu 则把代码和测试的关系说得极简：两者是一体两面，难的从来不是写哪个，而是搞清"这个"到底应该是什么。

> "The test suite is the same thing as the code, just approached from the other side... the hard part is not the code or the tests. it's knowing what 'this' is supposed to be, exactly." — mlsu

> （测试套件和代码是同一个东西，只是从另一面看它……难的不是代码或测试，而是确切搞清"它"应该是什么。）

### 亲测派：AI 优化真的能出量级提升

tekne 提供了一个"个人样本"，配得上 danluu 文里的乐观：

> "Data point of one, but after a few months of uselessness, I have managed to get some pretty serious, measurable performance improvements with AI optimizations -- order-of-magnitude speedups of business critical processes which took days as well as significant latency reductions." — tekne

> （样本只有一个，但在经历了几个月的无用之后，我确实通过 AI 优化拿到了相当可观、可测量的性能提升——对耗时数天的关键业务流程实现了数量级加速，同时显著降低了延迟。）

他补了前提：需要扎实的工作流、能快速跑的 benchmark、大量 token，以及严格的 profiling 流程。

gravypod 分享了一个更"随手"的案例——让 agent 把数据结构换成前缀树，而不是默认上 sqlite：

> "I recently built a piece of code which downloads a bulk set of data, indexes it for search, and then serves a pretty web UI... I had an agent take the data structures, pack the text effectively, and build a prefix tree for fast auto completion from the search bar... The resulting web server is significantly faster feeling than an sqlite implementation would feel like." — gravypod

> （我最近用 AI 做了一个下载数据、建索引、再套个 Web UI 的小程序。通常我会直接上 sstables 或 sqlite，这次我让 agent 优化数据结构、把文本打包好，为搜索栏的自动补全建了一棵前缀树……结果 Web 服务的响应速度明显比 sqlite 方案快。）

### 怀疑派：LLM 是"按指令做事"，不是"懂你在做什么"

jongjong 是全场最持重的反对者，他担心的不是技术，而是把优化交给 AI 的后果：

> "This idea is the reason why software will keep getting slower and less reliable. Because it's wrong and yet people believe it... The essence of the problem is that the LLM does exactly what you tell it. In the hands of a skilled engineer who understands the project, this is a superpower. In the hands of a junior, this is dangerous." — jongjong

> （正是这种想法让软件会一直变慢、变不可靠——它是错的，可大家相信它……问题的本质在于，LLM 只会照你说的做。在真正懂项目的资深工程师手里，这是超能力；在小白手里，这是危险。）

rfgplk 立刻反驳，用 SIMD 举例说过去"高手专属"的活现在真的一指就到：

> "Not even close to being true. Prior to the advent of LLMs writing good SIMD was hard... But now you can. You can literally instruct your agent to write SIMD accelerated code everywhere, or to optimize down to it. And it just does." — rfgplk

> （离事实差了十万八千里。LLM 出现之前，写出像样的 SIMD 代码很难……但现在你可以。你可以直接让 agent 到处写 SIMD 加速代码，或者让它优化到 SIMD 级别，它就真的照做。）

jongjong 也承认"定义良好的问题"上 AI 很强，但他补了一个更真实的观察——AI 会为了过一个无关紧要的测试点而浪费 15 分钟过度设计：

> "At one point it spend at least 15 minutes trying to change the code to make a test case pass to save a few meaningless percentage points of performance... Any engineer would have done this but Claude didn't want to take that initiative." — jongjong

> （有一次它花了至少 15 分钟改代码，只为了让一个测试用例通过，去省下几个毫无意义的性能百分点……任何工程师都会直接改超时时间，但 Claude 不愿意主动这么做。）

### 旁观者的幽默：Dan Luu 的网站本身就成了梗

一大群人不讨论优化，而是讨论 danluu 的博客为什么长得像没样式化的纯文本——这反而成了最热的衍生话题。tobinfekkes 抱怨没有 Reader Mode 早就点叉了：

> "Wow, my browser's Reader Mode saved my bacon on this one. Otherwise, I would have left immediately. I'm all for speedy, simple, plaintext websites, but it is a negligible amount of work in 2026 to throw some barebones CSS in and make it approachable." — tobinfekkes

> （天哪，这题全靠浏览器阅读模式救了我，不然我当场就走了。我不反对快速、简单、纯文本的网站，但在 2026 年，随便加几行最基础的 CSS 让它可读一点，几乎不花力气。）

markdown 干脆认定这是刻意的"geek 人设"：

> "Nah, he's just trying to be different. It's vanity. He's had a usable website in the past. This one is explicitly made to be shitty. 'Look at me, I'm such a geek' energy." — markdown

> （不，他就是想显得与众不同，是虚荣。他以前有过一个能用的网站，现在这个是被刻意做烂的。"看我多极客"的气场。）

userbinator 则举双手赞成这种朴素风格：

> "This page is exactly what I want the majority of websites to look like: no fluff, no idiotic 'modern design' trendchasing bullshit, just pure and simple content." — userbinator

> （这页恰恰是我希望大多数网站该有的样子：没有花活，没有愚蠢的"现代设计"追潮流垃圾，只有纯粹简单的内容。）

## 典型观点一览

| 立场 | 用户 | 一句话 |
|------|------|--------|
| 乐观派 | danluu | 优化成本暴跌，过去请不起的专项优化现在几分钟就能跑 |
| 优先级论 | 0xbadcafebee | 慢的最大理由是优先级，不是能力 |
| 商业逻辑 | bell-cot | 贡献利润的用户不在乎慢，所以没人改 |
| 测试即规格 | y1n0 | 测试套件就是可执行规格，spec 好 AI 就好 |
| 可证明派 | hodgehog11 | 速度是超优化问题，测试套件就是约束 |
| 一体两面 | mlsu | 代码和测试是一回事，难的是知道"该是什么" |
| 亲测派 | tekne | 几月无用到量级提升，前提是 workflow 够硬 |
| 顺手优化派 | gravypod | 让 agent 换前缀树，比 sqlite 快多了 |
| 怀疑派 | jongjong | LLM 照指令做事，小白手里是危险 |
| 反拨派 | rfgplk | SIMD 这种过去的高手活，现在一句话就能让 agent 写 |
| 站点评论 | userbinator | danluu 的页面才是网站该有的样子 |

## 总体情绪

评论区整体呈现"技术乐观 + 组织悲观"的分裂：几乎没人否认 AI 让优化变便宜了，亲测者还晒出数量级提速；但一聊到"那为什么软件还是慢"，讨论立刻转向商业激励、优先级和 token 预算——这些都不是 AI 能解决的。

最有意思的对比是 jongjong 和 rfgplk 的交锋：一个说 LLM 只会照做、不懂拒绝，另一个说 SIMD 这种过去的天才活现在真的能一句话触发。两边其实都对——优化的门槛塌了，但"该优化什么"的判断力，比任何时候都更值钱。技术让"快"变得便宜，组织让"慢"变得合理。danluu 的结论没变，只是换了个说法：你不需要再等一个天才来优化你的代码，你只需要一个愿意为优化买单的人。

## 引用帖子

| # | 标题 | URL |
|---|------|-----|
| 1 | There's no reason for software to be slow anymore | https://news.ycombinator.com/item?id=49395628 |

## 免责声明

<div class="disclaimer">
本摘要基于 HN 帖子 "There's no reason for software to be slow anymore" 的讨论整理而成，不代表本网站立场。引文内容版权归原作者所有。
<br><br>
<em>本摘要由 AI 模型辅助生成：deepseek/deepseek-v4-flash</em>
</div>
