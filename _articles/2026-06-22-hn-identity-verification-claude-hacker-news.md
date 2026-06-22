---
layout: post
title: "Claude 身份验证 — HN 讨论摘要"
date: 2024-07-29
categories: [articles]
---

## 原文概要

Hacker News 上一篇题为“Claude 身份验证”的讨论引发了社区对 Anthropic 公司（Claude LLM 的开发者）实施身份验证政策的广泛关注和激烈辩论。讨论主要围绕 Anthropic 要求用户（特别是针对 Fable 等前沿模型）进行身份验证，以及其对非美国用户、隐私、市场竞争和地缘政治格局的影响。

许多评论者表达了对美国政府限制 LLM 模型出口政策的不满，认为这不仅损害了美国科技公司的国际竞争力，也促使全球用户转向非美国或开源替代方案。同时，用户对上传敏感个人身份信息（PII）给第三方验证服务（如 Persona）的隐私和安全风险表示深切担忧。

## 讨论焦点

### 1. 美国出口限制对国际市场和竞争力的影响

> "The US is really shooting itself in the foot here.The restrictions on LLM models like Fable has created a viable international LLM market where it was difficult to justify investment two weeks ago.As a non-US citizen Opus 4.8 is the best American LLM I will ever have access to. That's no longer up for debate or question. Each month that I pay Anthropic is now a depreciating value -- I'm paying for models I'll never be able to access, while other models are able to catch up." — @data-ottawa
> “美国真的在搬起石头砸自己的脚。对 Fable 等 LLM 模型的限制创造了一个可行的国际 LLM 市场，而两周前，这个市场还很难证明投资的合理性。作为非美国公民，Opus 4.8 将是我能接触到的最好的美国 LLM。这一点已不再有争议或疑问。我每月支付给 Anthropic 的费用现在都在贬值——我正在为永远无法访问的模型付费，而其他模型正在迎头赶上。”

许多非美国用户认为，美国政府对 LLM 模型的出口限制，特别是对 Fable 等前沿模型的限制，正在迫使他们寻找非美国替代方案。这不仅削弱了美国 LLM 提供商的国际市场份额，也刺激了国际 LLM 市场的发展，使得中国等地的模型得以迅速崛起并提供有竞争力的服务。评论者普遍认为，这种政策长期来看对美国科技公司不利。

### 2. 身份验证的隐私和安全担忧

> "I’m a US citizen and absolutely will not be uploading additional information just to use a company’s models. This effectively kills my usage of anthropic for anything beyond their 4.8 models." — @hoytschermerhrn
> “我是一名美国公民，绝对不会为了使用一家公司的模型而上传额外信息。这实际上扼杀了我在 Anthropic 上对 4.8 模型以外的任何使用。”

> "It’s not the five minutes that I balk at, it’s entrusting a third party with all they need to steal my identity. But of course, they’ll never get hacked…" — @-Fu
> “我不是介意那五分钟，而是将所有足以窃取我身份的信息托付给第三方。但当然，他们永远不会被黑客攻击……”

无论是美国公民还是非美国公民，许多用户都对上传政府颁发的身份证明文件以使用 LLM 服务的做法表示强烈反对。主要担忧集中在个人敏感信息（如驾驶执照、护照图像、面部几何数据）被第三方验证服务（如 Persona，该公司曾有数据泄露丑闻）收集和存储的隐私风险。用户担心这些数据可能被滥用、泄露或用于身份盗窃。

### 3. 转向非美国及开源 LLM 替代方案

> "After the recent 75%+ price cuts by DeepSeek & Xiaomi MiMo (and now, MiniMax), I pretty much packed my Claude bag up and moved over. I see no discernable difference (other than chattiness of its thinking modes) in capabilities for the kind of coding & debugging work I do." — @ignoramous
> “在 DeepSeek 和小米 MiMo（以及现在的 MiniMax）最近降价 75% 以上之后，我几乎收拾好我的 Claude 包袱，转投它们。在我所做的编码和调试工作中，除了思维模式的健谈程度外，我没有发现能力上有任何明显的差异。”

由于美国 LLM 的限制和身份验证要求，大量用户正在积极探索并转向非美国（尤其是中国）和开源的 LLM 模型。DeepSeek、GLM、MiMo 和 Qwen 等模型因其有竞争力的性能和更低的成本而受到青睐。许多用户表示，这些替代方案在日常编码、调试和写作任务中表现良好，甚至在某些方面超越了 Anthropic 的 Opus 模型。

### 4. LLM 服务的可靠性与供应链风险

> "This decision has, effectively, turned LMMs into a supply chain risk.Before this incident I’d gladly use any anthropic LLM in production features. Right now, this has become a risky decision that can tank my business overnight." — @baka367
> “这项决定实际上已将 LMMs 变成了供应链风险。在此事件之前，我很乐意在生产功能中使用任何 Anthropic LLM。现在，这已成为一项冒险的决定，可能一夜之间让我的业务崩溃。”

讨论中，一些企业用户指出，美国政府对 LLM 的限制使得依赖这些模型的业务面临巨大的供应链风险。如果关键的 AI 服务可能随时因政策变化而变得不可用，那么将业务流程建立在这些服务之上将变得极其危险。这种不确定性促使企业重新评估其对单一 LLM 提供商的依赖，并考虑采用多模型策略或本地部署解决方案。

## 典型观点一览

| 立场 | 用户 | 一句话 |
|------|------|--------|
| 反对身份验证 | @hoytschermerhrn | 作为美国公民，我绝不会上传额外信息来使用一家公司的模型，这实际上扼杀了我在 Anthropic 上的使用。 |
| 担忧隐私安全 | -Fu | 我不是介意那五分钟，而是将所有足以窃取我身份的信息托付给第三方。 |
| 转向非美LLM | @data-ottawa | 美国对LLM模型的限制创造了一个可行的国际LLM市场，我每月支付给 Anthropic 的费用现在都在贬值。 |
| 质疑限制的长期性 | @ozozozd | Anthropic 首席执行官 Dario 曾请求监管，现在监管来了，你凭什么认为这种情况是暂时的？ |
| 强调供应链风险 | @baka367 | 这项决定实际上已将 LMMs 变成了供应链风险，可能一夜之间让我的业务崩溃。 |
| 认为身份验证是必要之恶 | @ElProlactin | 人们每天向模型提供各种个人信息，却对五分钟的身份验证犹豫不决，这很有趣。 |

## 总体情绪

Hacker News 社区对 Claude 的身份验证政策和美国政府的 LLM 限制表现出普遍的**担忧和不满**。讨论情绪复杂，既有对隐私侵犯的愤怒，也有对美国科技公司未来竞争力的悲观，以及对非美国和开源替代方案的积极探索。许多用户认为此举是美国“搬起石头砸自己的脚”，并预示着 AI 领域地缘政治分裂的加剧。

**总体情绪：争议性/担忧**

## 引用帖子

| # | 标题 | URL |
|---|------|-----|
| 1 | Identity verification on Claude | https://news.ycombinator.com/item?id=48618455 |
| 2 | Wayback Machine archive of Claude support page | https://web.archive.org/web/20260415064244/https://support.c... |
| 3 | Persona leak exposes global surveillance risks | https://cybernews.com/privacy/persona-leak-exposes-global-su... |
| 4 | Discord drops Persona after user backlash | https://hothardware.com/news/discord-drops-persona-after-use... |
| 5 | Previous HN discussion on Claude identity verification | https://news.ycombinator.com/item?id=47775633 |

<div class="disclaimer">
本文为 Hacker News 讨论的中文摘要，仅作信息整理之用。文中引用的用户观点不代表本文立场。原文内容请参阅 HN 原帖。
</div>