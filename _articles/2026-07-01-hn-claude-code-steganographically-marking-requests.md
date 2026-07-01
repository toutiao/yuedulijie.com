---
layout: post
title: "Claude Code is steganographically marking requests — HN 讨论摘要"
date: 2026-07-01
categories: [articles]
excerpt: "Anthropic 被指控在 `Claude` 请求中秘密嵌入隐写水印，引发了 Hacker News 社区关于公司透明度、用户信任、数据隐私以及大型 AI 公司行为伦理的激烈讨论。"
tagline: "AI 公司偷偷给你的请求打水印？这不叫技术，这叫信任危机，还是“控制欲强的伴侣”的又一力证？"
---

## 原文概要

Hacker News 热门榜 (/best) 上的一篇帖子揭露，Anthropic 旗下的 `Claude` 模型可能正在使用隐写术（steganography）秘密标记用户发送的请求。这意味着用户在不知情的情况下，其输入内容被嵌入了不可见的元数据，并在传输过程中被回传给 Anthropic。

这一发现迅速引发了社区的广泛关注和激烈讨论，许多用户对 Anthropic 缺乏透明度的行为表示强烈不满和担忧。讨论焦点集中在用户隐私、数据处理的知情权、公司行为的道德边界以及大型 AI 公司在市场中的权力不对称等问题。

评论者普遍认为，这种未经明确披露的隐秘标记行为，不仅损害了用户对服务提供商的信任，也引发了对未来数据收集和滥用可能性的深层忧虑。

## 讨论焦点

### 缺乏透明度与用户信任危机

许多用户对 Anthropic 未能明确披露其隐写标记行为表示强烈不满，认为这严重损害了用户信任。评论者指出，无论公司有何商业需求，都不应以牺牲透明度为代价。

> "There are some commentors in this thread downplaying the severity of a service provider being less than transparent about exactly what their shipped tooling does on customer's machines. That the provider's business needs necessitate the this behaviour doesn't justify their lack of honest disclosure." — civet_java [comment: 48737661]
> （本帖中有些评论者轻描淡写了服务提供商对其提供工具在客户机器上具体行为缺乏透明度的严重性。提供商的业务需求需要这种行为，并不能为其缺乏诚实披露开脱。）

有用户将这种行为比作未经同意的人体试验，认为 Anthropic 明知用户不会接受，因此采取了混淆和隐写术来窃取数据。

> "They totally knew that this would never be accepted by users, and that is precisely why they resorted to obfuscation and steganography to exfiltrate the data. This was quietly added in an update, and would have been removed in a later one had it gone unnoticed." — ammo1662 [comment: 48743248]
> （他们完全知道用户绝不会接受这种做法，这正是他们诉诸混淆和隐写术来窃取数据的原因。这是在一次更新中悄悄添加的，如果未被发现，本会在后续更新中移除。）

### 公司动机与行为伦理的争议

社区对 Anthropic 采取隐写标记的动机进行了多方猜测，并对其行为的伦理基础提出质疑。一些用户认为这可能是为了节省运营成本，而另一些则认为是保护知识产权的手段。

> "Why would they want to do that when it’s likely that someone will find out anyway and it could turn into a scandal? One possibility: they wanted to keep it secret because they’re crooks. Another possibility: there are so many calls that it costs a lot in operating expenses." — sixtyj [comment: 48743632]
> （为什么他们会想这样做，因为反正很可能会被发现并演变成丑闻？一种可能性：他们想保密是因为他们是骗子。另一种可能性：调用次数太多，运营成本很高。）

也有评论指出，Anthropic 曾公开表示有外国实验室在“蒸馏”（distilling）他们的模型，因此隐写标记可能是为了识别这种行为的“明显回应”。然而，这种解释并未平息争议，反而引发了对 Anthropic 在 IP 保护上“双重标准”的批评。

> "From my understanding, distilling the model with another model is not illegal per se. Also, the output of the LLM is public domain by law, too. So, why all this "effort" to protect the model? This is a free market, and moving fast and breaking things is the norm." — bayindirh [comment: 48739112]
> （据我理解，用另一个模型来蒸馏模型本身并不违法。此外，`LLM` 的输出在法律上也是公共领域。那么，为什么要费尽心思保护模型呢？这是一个自由市场，快速行动和打破常规是常态。）

### “滑坡谬误”与言论审查担忧

讨论中出现了关于“滑坡谬误”（slippery slope fallacy）的辩论，即这种隐秘标记行为是否会成为 Anthropic 未来对用户进行更广泛审查和限制的开端。

> "First its the "Chinese" then it will be people using "cyber" capabilities, or "jailbreaking" or "going against Dario" or any other thing they find "objectionable"." — kiproping [comment: 48738864]
> （首先是“中国人”，然后将是使用“网络”能力的人，或者“越狱”的人，或者“反对 Dario”的人，或者任何他们觉得“令人反感”的事情。）

一些用户认为，鉴于 Anthropic 的服务条款已经包含对批评者的限制，这种担忧并非毫无根据。

> "Their terms of service already effectively attacks people for criticizing Anthropic. It says that if you use Claude to criticize Anthropic, then you've pre-agreed to pay for their lawyers going after you, and pre-agreed to lose the court case." — FooBarWidget [comment: 48743025]
> （他们的服务条款已经有效地攻击了批评 Anthropic 的人。它规定，如果你使用 `Claude` 批评 Anthropic，那么你已预先同意支付他们律师追究你的费用，并预先同意输掉官司。）

### 公司与用户关系的隐喻

有评论者将 Anthropic 的行为及其引发的讨论，比作一种不健康的权力关系，例如“控制欲强的伴侣”与受害者之间的关系，以此来解释公司看似非理性的行为和一些用户对此的辩护。

> "Anthropic always came off to me as what can shorthand be described as an abusive controlling partner + the resulting relationship. If you start viewing the conversations around it through that lens, a lot of stuff intuitively clicks into place. Including this apologism for example." — hypfer [comment: 48743408]
> （Anthropic 给我的印象一直可以简称为一个控制欲强的伴侣 + 由此产生的关系。如果你开始通过这个视角来看待围绕它的对话，很多事情就会直观地变得清晰起来。例如，包括这种辩解。）

这种隐喻试图从更深层次的心理和社会学角度，理解大型科技公司在市场中利用其不对称权力所采取的行动。

## 典型观点一览

| 立场 | 用户 | 一句话 |
|------|------|--------|
| 批评 | `ammo1662` | Anthropic 故意隐瞒其隐写行为，这与未经同意的人体试验无异，完全越界。 |
| 质疑 | `civet_java` | 公司缺乏透明度令人担忧，这让我怀疑他们还在从我的机器上收集什么个人信息。 |
| 猜测 | `sixtyj` | 隐写标记可能是为了节省运营成本，但也可能是公司“不诚实”的表现。 |
| 讽刺 | `bayindirh` | Anthropic 在训练模型时利用“合理使用”，现在却抱怨他人“蒸馏”其模型，这是自食其果的伪善。 |
| 担忧 | `kiproping` | 这种行为可能是一个危险的“滑坡”，未来 Anthropic 可能会以各种理由审查用户。 |
| 隐喻 | `hypfer` | Anthropic 的行为就像一个“控制欲强的伴侣”，许多看似不合理的举动都能用这个视角来解释。 |

## 总体情绪

Hacker News 社区对 Anthropic 涉嫌秘密使用隐写术标记用户请求的行为表现出压倒性的负面情绪。讨论充满了对公司缺乏透明度、侵犯用户隐私和道德伦理的强烈谴责。许多用户认为 Anthropic 的行为是对用户信任的背叛，并对其动机和未来可能采取的行动表示深切担忧。尽管有少数评论试图从公司运营或 IP 保护角度解释，但这些解释并未能平息社区的愤怒，反而引发了对公司“伪善”和权力滥用的进一步批评。

**总体情绪：争议性**

## 引用帖子

| # | 标题 | URL |
|---|------|-----|
| 1 | Claude Code is steganographically marking requests | https://news.ycombinator.com/item?id=48734373 |

<div class="disclaimer">
本文为 Hacker News 讨论的中文摘要，仅作信息整理之用。文中引用的用户观点不代表本文立场。原文内容请参阅 HN 原帖。
</div>