---
layout: post
title: "Zig 作者开喷 Anthropic —— Bun 改 Rust 背后的 AI 营销闹剧"
date: 2026-07-14
categories: [articles]
excerpt: >-
  Bun 从 Zig 重写为 Rust，Anthropic 说是技术需要，Zig 作者 Andrew Kelley 直指这是管理混乱加 AI 营销。1400 点 HN 热帖解剖一场语言战争的真相。
tagline: >-
  百亿美元公司被一个人骂破防了。
---

Anthropic 旗下的 JavaScript 运行时 Bun 最近完成了从 Zig 到 Rust 的重写。这本是一篇技术博客，但 Zig 语言创建者 Andrew Kelley 的反应把它变成了一场公开骂战。随后 Ray Myers 的长文《Zig Creator Calls Spade a Spade, Anthropic Blows Smoke》登上了 HN 热门榜榜首（1400 分），将这场争论推向高潮。

## 事件背景

Bun 是一个 TypeScript/JavaScript 运行时，定位是更快的 Node.js。它最初用 Zig 编写，曾经是 Zig 生态中最大的代码库之一。Bun 声称其代码"接近 100% 由 AI 贡献"。而 Zig 项目则有一条严格规定：不接受任何 AI 生成的代码（PR 必须由人类编写）。

今年 5 月，Bun 被 Anthropic 收购后，团队用 AI agent 将整个代码库从 Zig 重写为了 Rust（unsafe Rust）。5 月合并，7 月才发布解释博文。Zig 作者 Andrew Kelley 随后发布了尖锐回应，直言 Bun 团队的工程管理是一团糟。

## 讨论焦点

### 这是一次技术决策还是营销活动？

双方支持者各执一词。Anthropic/Bun 方面的说法是：Zig 的内存安全问题无法通过风格指南解决，Rust 的编译期检查是唯一出路。但 Kelley 和 Myers 指出，问题不在于语言，而在于工程管理。

> "The reason for the rewrite was marketing, not engineering. The justification after the fact can be done no matter what language they were rewriting from." — lelanthran
> （重写的理由是营销而非工程。事后的理由可以随便编，不管他们从什么语言重写。）

另一位用户 `nozzlegear` 认为，如果 Bun 的创始人不是为了 Anthropic 工作，这件事根本不会引起这么大的争议：

> "since he does work for Anthropic, it just looks like a big marketing gimmick that was going to be done whether it was the right thing to do or not." — nozzlegear
> （因为他确实为 Anthropic 工作，这就看起来像是无论如何都会做的营销噱头。）

但也有反对意见。用户 `vlaaad` 表示：

> "Zig's response is a sour opinion piece full of personal attacks." — vlaaad
> （Zig 的回应是一篇酸溜溜的观点文章，全是人身攻击。）

反驳者则认为 Anthropic 本身就不是中立的观察者。用户 `lelanthran` 补充说 Anthropic 不在编程语言市场——它"在所有编程语言市场"。

### AI 时代的语言选择

重写选择 Rust 有一个隐蔽的背景：AI 模型写 Rust 代码的效果可能比其他语言更好。多位用户讨论了这个趋势。

> "Rust may have a tremendous success in the future, because it's much easier to write it with AI." — pizza234
> （Rust 未来可能取得巨大成功，因为用 AI 写它更容易。）

一位用户提出了一个讽刺性的前景：

> "Rust could become the most deployed but the least written (by humans) programming language if the dreams of AI bros come true." — worrycue
> （如果 AI 兄弟们的梦想成真，Rust 可能成为部署最多但人类写得最少的语言。）

还有用户注意到，AI 公司实际上在通过模型训练数据的倾斜引导行业走向：

> "LLM companies have truly astounding power to now steer the direction of the entire industry. It should worry all of us." — unknownfuture
> （LLM 公司现在拥有令人震惊的能力来引导整个行业的方向。这应该让所有人担忧。）

但另一方面，用户 `overgard` 根据实际体验指出，AI 并非在所有语言上都表现良好："当我在 Unreal Engine 上用 C++ 和 Blueprint 写代码时，我几乎完全手写，因为它根本没法在 Blueprint 上做任何有意义的事。"

### Andrew Kelley 的骂战方式

Kelley 的回应以直接、尖锐著称，甚至用了"just a total shit show"来描述 Bun 团队的管理。评论区分成了两派。

> "The outrage around what Andrew said was performative and melodramatic." — LAC-Tech
> （对 Andrew 言论的愤怒是表演性的和戏剧化的。）

有人引用 Kelley 此前称 GitHub 员工为"monkeys"和"losers"的旧账：

> "Andrew Kelley described Github employees as 'monkeys' and 'losers'." — howling
> （Andrew Kelley 曾把 GitHub 员工描述为"猴子和失败者"。）

但也有用户认为，正是因为 Kelley 说了别人不敢说的话，才让人更尊重他：

> "Honestly, seeing the project lead take a stand against poor engineering practices without any equivocation makes me more inclined to want to use Zig." — lelanthran
> （老实说，看到项目负责人毫不含糊地反对糟糕的工程实践，反而让我更想用 Zig。）

### 工匠精神 vs. 工业级安全

一位用户用汽车比喻来形容 Zig 和 Rust 的定位差异：

> "Rust is perhaps a rally car (fast but still a car so occupants inside are well protected), whilst Zig really is a quadbike or open wheel cart." — whizzter
> （Rust 像是拉力赛车——快但有保护；Zig 像是沙滩车或开放式卡丁车。）

这个比喻引发了广泛讨论。反对者认为，未来不再允许"手动管理一切"的做法：

> "All I've seen is there is literally no programmer smart and careful enough to never create a use after free or out of bounds read in a sufficiently complex codebase." — Gigachad
> （在足够复杂的代码库中，没有哪个程序员聪明细心到从不写出 use-after-free 或越界读取。）

支持 Zig 路径的则认为，Rust 的借用检查器增加了成本，但未必带来对应的收益：

> "It is not at all obvious to me that banging your head against the borrow checker is a worthwhile tradeoff in this new world." — pseudony
> （在这个新时代，和借用检查器死磕是否值得，远非显而易见。）

## 典型观点一览

| 立场 | 用户 | 一句话 |
|------|------|--------|
| 支持 Kelley | LAC-Tech | 对 Andrew 的愤怒是表演性的和戏剧化的。 |
| 支持 Anthropic | vlaaad | Zig 的回应酸溜溜，全是人身攻击。 |
| 营销论 | lelanthran | 重写的原因是营销，不是工程。 |
| 担忧 AI 引导行业 | unknownfuture | LLM 公司在引导整个行业方向，令人担忧。 |
| 安全优先 | Gigachad | 没有程序员能完全避免内存错误。 |
| 工匠路线 | pseudony | 和借用检查器死磕未必值得。 |
| 关注管理问题 | audunw | Kelley 说的虽是真相，但措辞可以更温和。 |
| 代码风格检测 | embedding-shape | "礼貌"可能是 LLM 输出的信号。 |

## 总体情绪

这场讨论的深层问题不是 Zig vs Rust，而是"AI 够不够用"。Anthropic 需要你相信 AI 已经足够强大，但 Ray Myers 列举了一串反例：Bun 用 unsafe Rust 正是承认 AI 不够、编译期检查不够、代码审查不够。每一次加一层防护，都在证明"AI is not enough"。

Kelley 的回应方式可能不够得体，但他指出了一个更关键的问题：当一家千亿美元公司可以通过公关手段把一个工程决策包装成"AI 胜利"时，整个行业的信息环境都会受到污染。

截至发稿，Bun 的 Rust 版本已经正式上线。Zig 社区在失去最大用户的同时，获得了一份意外的流量。Jarred Sumner 和 Andrew Kelley 都没有就此事进一步置评。

## 引用帖子

| # | 标题 | URL |
|---|------|-----|
| 1 | Zig Creator Calls Spade a Spade, Anthropic Blows Smoke | https://news.ycombinator.com/item?id=48889637 |
| 2 | Andrew Kelley 对 Bun 重写的回应 | https://andrewkelley.me/post/my-thoughts-bun-rust-rewrite.html |
| 3 | Anthropic/Bun 的官方解释 | https://bun.com/blog/bun-in-rust |

## 免责声明

本文基于 HN 讨论的公开内容，引用均已标注来源。不构成对任何方的支持或认可。

<br><br><em>本摘要由 AI 模型辅助生成：deepseek/deepseek-v4-flash</em>
