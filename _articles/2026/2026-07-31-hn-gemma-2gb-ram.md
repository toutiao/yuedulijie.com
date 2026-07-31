---
layout: post
title: "Gemma 4 26B 塞进 2GB 内存 — HN 讨论摘要"
date: 2026-07-31
categories: [articles]
excerpt: >-
  TurboFieldfare 用 Swift + Metal 把 26B 参数的 Gemma 4 压进 2GB 内存，SSD 流式加载专家权重，8GB Mac 也能跑。
tagline: >-
  换 mmap 为 pread，吞吐翻了 8 倍——本地大模型的极限又往前挪了一格。
---

## 原文概要

7 月 29 日，iOS/Metal 工程师 Andrey Mikhaylov 在 HN 发布了开源项目 TurboFieldfare：一个用 Swift + Metal 手写的推理引擎，能在约 2GB 内存中运行 26B 参数的 Gemma 4 26B-A4B，目标机器是 8GB 内存的 MacBook Air。帖子 2 天内拿下 884 分，GitHub 仓库获得 2.2k stars。

核心思路是 "内存不够，SSD 来凑"：模型权重共 14.3GB，TurboFieldfare 只把 1.35GB 共享核心权重和 FP16 KV cache 常驻内存，每个 token 需要哪些路由专家（routed experts），就用 `pread` 从 SSD 流式读取。作者自述，这样做的动力很朴素——"内存变贵了，所以我给一个 260 亿参数的模型定了 2GB 的预算"。

实测速度：8GB M2 MacBook Air 上 5-6 tok/s，24GB M5 Pro 上 31-35 tok/s。项目围绕 MoE 专家缓存做了大量调优，累计记录 103 项实测实验。作者在 README 末尾把项目献给热爱观鸟的妻子 Sasha，项目名 "TurboFieldfare" 就取自一种鸫科鸟类——"它不是最显眼、颜色最鲜亮的鸟，但绝对有自己的性格"。

## 讨论焦点

### 5 tok/s 到 35 tok/s 的差距从哪来

作者自报的数据让读者困惑：同一模型，M2 和 M5 之间差了 6 倍，远超常规的代际提升预期。

> "Where does this big a performance spread come from? I wouldn't naïvely expect SSD performance difference to be that big, and I would expect SSD performance to dominate..." — addaon

> （这么大的性能差距从哪来的？我直觉上不会认为 SSD 性能差异能这么大，而我以为 SSD 性能应该占主导……）

> "It was 83ms read per token for M2 and 12ms on M5 pro. Total is 163ms/tok vs 30ms/tok for M5. So yeah, there is a faster read and faster gpu processing" — gitpusher42（作者）

> （M2 每个 token 读取耗时 83ms，M5 Pro 上是 12ms。每 token 总耗时 M2 是 163ms，M5 是 30ms。所以确实是读取更快，GPU 处理也更快。）

GeekyBear 补充了硬件侧的答案：M5 基础款相比 M2 基础款，内存带宽提升 50%，片上系统级缓存也扩大了 50%。他还引用了实测数据——M5 MacBook Pro 的 SSD 读速约 6,323 MB/s，M4 只有 2,031 MB/s，前者是后者的三倍多。既然这个引擎的速度被 SSD 读取主导，M5 的读写带宽直接决定了结果。

### "未使用的内存就是浪费的内存"

另一个关键变量是系统页缓存：macOS 会把空闲内存自动用作磁盘缓存，这让 2GB 常驻的进程实际读的是内存而非 SSD。

> "Unused RAM is wasted RAM. So not really Apple magic, about every OS uses 'free' memory as disk cache. Try to leave only a gigabyte or two free, speed likely would drop dramatically." — petu

> （未使用的内存就是浪费的内存。这算不上 Apple 的魔法，几乎所有系统都会把"空闲"内存当磁盘缓存用。试着只留一两 GB 空闲，速度很可能会骤降。）

作者验证了这个猜测：在 M5 Pro 上把内存压力推到 8GB，速度从 35 tok/s 掉到 27 tok/s；另一位 M4 Max 用户从正常状态的 48 tok/s 掉到 32-42 tok/s。这也暗示一个反直觉的推论：内存越大、系统缓存越充裕的机器，跑这个引擎越快，而最低配 8GB 机器的成绩才是真实水平。

### 专家缓存：40% 的专家下个 token 还会再用

MoE 模型按 token 动态路由专家，读者最关心的就是这个切换模式——如果每个 token 都要换专家，SSD 读取会变成灾难。

> "The full route changes almost every token. The cache works through partial reuse, about 40% of experts repeat on the next token and 57% within two tokens, cutting I/O from 166 to 88 ms/token on M2 Mac. The longest exact repeat we found was only two tokens." — gitpusher42（作者）

> （完整路由几乎每个 token 都在变。缓存靠的是部分复用——约 40% 的专家会在下一个 token 重复，两个 token 内重复率 57%，把 M2 上的每 token I/O 从 166ms 压到了 88ms。我们找到的最长连续重复也只有两个 token。）

16 个专家槽位在良好条件下能达到约 67% 的缓存命中率。有读者顺着这个思路提出了进一步优化：用模型的 MTP 头（multi-token prediction）预测未来 token 会激活哪些专家、提前预取——这恰好是作者没做、但理论上可行的下一步。

### 从 mmap 到 pread：吞吐翻 8 倍的关键

被问到"哪项优化收益最大"时，作者给出了一个教科书级的答案。

> "Switching from mmap to parallel pread. From 0.5tok/sec to almost 4tok/sec. Running GPU work while reading missed experts also helped a lot, 4.4 -&gt; 4.7" — gitpusher42（作者）

> （从 mmap 换成并行 pread。从每秒 0.5 token 涨到接近 4 token。在读取缺失专家的同时并行跑 GPU 计算也帮助很大，4.4 提到 4.7。）

kees99 解释了背后的原理：`mmap` 触发的是小粒度缺页读取，IOPS 受限；而显式 `pread` 能让内核和 SSD 用更大的块传输，更容易达到最大字节吞吐——当软件提前知道下个 token 需要哪块专家数据，还能在读盘的同时并行做当前 token 的数值计算。

也有读者提出疑问：既然 llama.cpp 开了 mmap 也能让 26B 模型在 2GB 下跑，这个项目相比有什么优势？

> "My first version used plain `mmap`. On the 8 GB M2, a cold 3.36 MB expert took 10 ms with mmap and 2.8 ms with `pread`." — gitpusher42（作者）

> （我的第一版就用的是纯 `mmap`。在 8GB M2 上，冷加载一个 3.36MB 的专家，mmap 要 10ms，pread 只要 2.8ms。）

作者坦言 llama.cpp 或许也能在 2GB 内运行，但"我猜会更慢"。区别在于同步方式：TurboFieldfare 把 SSD 读取与推理活动显式同步，而操作系统对 mmap 的加载时机一无所知。

### Ollama 之争：绕不开的 llama.cpp

有用户被项目惊艳到，顺手拷打了 Ollama：

> "You're a mad man - thank you! Do I understand correctly that Ollama doesnt do that, and that's why responses hang forever on a M3 running the same model through Ollama?" — cyanregiment

> （你真是个疯子——谢谢你！我理解得对吗：Ollama 不做这件事，所以用 Ollama 在 M3 上跑同一个模型会卡死？）

> "Please don't use Ollama." — trollbridge

> （求你了，别用 Ollama。）

cwillu 为这个立场提供了技术注脚："It wouldn't be the first time ollama's llama.cpp fork reintroduced bugs and was missing important optimizations."（这不是 ollama 的 llama.cpp fork 第一次重新引入 bug、丢掉重要优化了。）不过 reddguard 的反问也很公允：Ollama 底层就是 llama.cpp，即使绕过 Ollama 直接用它，也不代表能获得 TurboFieldfare 级别的定制优化——毕竟后者是手写 Metal 内核、专为单模型调优的引擎。

### Gemma 还是 Qwen：模型选择的现实

多位读者希望引擎能跑 Qwen 的 MoE 模型，因为 Gemma 在编码场景的表现不够看。

> "Would be awesome if it ran Qwen (the MoE probably won't squeeze that low, but...). This because I have hardly been able to use Gemma for any sort of useful coding." — rcarmo

> （如果能跑 Qwen 就太好了（Qwen 的 MoE 大概压不到这么低，但……）。因为我几乎没法用 Gemma 做任何有用的编码。）

作者解释选型原因：最初想用 Qwen，但它的架构在自己的技术栈里实现起来复杂得多，选 Gemma 是为了"不用把所有时间花在调试自定义内核上"。

反对者 jwr 为 Gemma 辩护，强调它的通用能力：

> "In defense of this model, Gemma is actually a very good general-purpose model that can work with multiple languages. I use it for spam classification and for processing dictation, which means that I hold the entire model in memory all of the time, which is somewhat problematic (64GB RAM total, but heavy usage by docker, databases, etc)" — jwr

> （Gemma 实际上是一个非常好的通用模型，支持多语言。我用它做垃圾邮件分类和语音听写处理，这意味着我一直把整个模型常驻内存——这有点麻烦（总共 64GB RAM，但 Docker 和数据库占用很重）。）

这正是 TurboFieldfare 的目标场景：让这类用户不必为日常小任务腾出 14GB 内存。

### 本地推理的集体势头

帖子也成了同类项目的聚集地。多名读者提到 colibri、Flash-MoE、antirez 的 DwarfStar4 等近期爆发的 SSD 流式推理项目：

> "I'm really excited about what's been happening couple last weeks for local inference. I feel like it all started after colibri [1] was released. Great work!" — maxignol

> （最近几周本地推理领域太让人兴奋了。我觉得这一切都是从 colibri 发布开始的。干得漂亮！）

对比之下，DwarfStar4 面向 64GB 内存的高端 Mac，而 TurboFieldfare 专攻低端设备。一位用户用一句话点破了分工："DS4 is designed to do real-work. Gemma 4 is not going to cut it."（DwarfStar4 是为干真活设计的，Gemma 4 干不了那个。）在 8GB 入门机器上能跑通 26B 模型，本身就是一种宣言——瓶颈正从硬件配置转移到工程调优上。

## 典型观点一览

| 立场 | 用户 | 一句话 |
|------|------|--------|
| 工程惊叹 | cyanregiment | "你是个疯子——谢谢！" |
| 性能归因硬件 | GeekyBear | "M5 的带宽、缓存、SSD 全面翻倍。" |
| 内存缓存论 | petu | "空闲内存都被系统拿去当磁盘缓存了。" |
| 选型务实 | gitpusher42（作者） | "Qwen 架构太复杂，Gemma 好实现。" |
| Gemma 辩护 | jwr | "做垃圾邮件分类、听写，Gemma 够用了。" |
| 对标质疑 | liuliu | "DwarfStar4 是干真活的，Gemma 不行。" |

## 总体情绪

评论区对 TurboFieldfare 的欣赏几乎一边倒，但欣赏的是工程方法而非模型本身。读者惊叹于 2GB 内存跑 26B 模型的工程实现，同时对 Gemma 的编码能力保持清醒——多数人明确表示这是 "everyday tasks" 场景的工具，而不是取代主力编码模型的方案。

更有价值的是这场讨论暴露出的趋势：专家缓存、SSD 流式推理、手写 Metal 内核——本地推理正在从一个硬件比拼的赛道，变成工程调优的赛道。当 8GB 入门 Mac 也能跑动 26B 模型时，"你的机器带不动"这个理由正在失去效力。

作者在 README 里写的最后一句话，也许比全部性能数据更值得品味："下次出门时，摸摸草地，听听鸟叫。有时那才是最美好的事。如果你可以，请支持你本地的野生动物社区。"

## 引用帖子

| # | 标题 | URL |
|---|------|-----|
| 1 | Show HN: Open-source engine running Gemma 4 26B in 2 GB RAM on any M-series Mac | https://news.ycombinator.com/item?id=49098510 |

## 免责声明

<div class="disclaimer">
本摘要基于 HN 帖子 "Show HN: Open-source engine running Gemma 4 26B in 2 GB RAM on any M-series Mac" 的讨论整理而成，不代表本网站立场。引文内容版权归原作者所有。
<br><br>
<em>本摘要由 AI 模型辅助生成：deepseek/deepseek-v4-flash</em>
</div>
