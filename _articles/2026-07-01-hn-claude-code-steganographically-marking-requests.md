---
layout: post
title: "Claude 代码被指通过隐写术标记请求 — HN 讨论摘要"
date: 2026-07-01
categories: [articles]
excerpt: "Anthropic 的 Claude 被曝使用隐写术秘密标记用户请求，引发了 Hacker News 社区对透明度、用户信任、数据隐私以及公司行为道德底线的激烈讨论。"
tagline: "Anthropic 的 Claude 偷偷给你的请求打上了“小标记”，这不叫隐写术，这叫“AI 时代的秘密警察”。"
---

## 原文概要

Hacker News 社区近日围绕 Anthropic 的 `Claude` `AI` 模型被指控使用隐写术（steganography）在用户请求中嵌入隐藏标记的事件展开了激烈讨论。这一指控源于用户发现 `Claude` 可能在不告知用户的情况下，秘密地在数据传输中加入可追踪的标识。

这一做法迅速引发了社区对服务提供商透明度、用户数据隐私以及公司行为道德底线的广泛担忧。许多评论者认为，这种缺乏披露的隐秘行为是对用户信任的背叛，并可能构成潜在的数据滥用。

此次讨论在 HN 热门榜 (/best) 上引起了广泛关注，社区成员就 Anthropic 行为的动机、其与知识产权保护的关联，以及 `AI` 行业未来监管的必要性等问题进行了深入探讨。

## 讨论焦点

### 透明度缺失与用户信任危机

许多用户对 Anthropic 缺乏透明度的行为表示强烈不满，认为秘密标记请求而不明确披露是对用户信任的严重破坏。这种隐秘性被视为公司明知用户不会接受其做法而采取的规避手段。

> "They totally knew that this would never be accepted by users, and that is precisely why they resorted to obfuscation and steganography to exfiltrate the data. This was quietly added in an update, and would have been removed in a later one had it gone unnoticed." — ammo1662 [comment: 48743248]
> （他们完全知道用户不会接受这种做法，所以才诉诸混淆和隐写术来窃取数据。这是在一次更新中悄悄添加的，如果没被发现，会在后续更新中移除。）

评论者指出，这种行为让人质疑 Anthropic 是否还在秘密收集其他个人身份信息（`PII`），并认为服务提供商有义务对其工具在客户机器上的具体操作保持完全透明。

### Anthropic 行为的动机与道德争议

社区对 Anthropic 采取这种隐秘行动的动机进行了多方猜测，包括保护知识产权、降低运营成本，以及一些用户将其描述为“控制欲强”或“滥用”的行为模式。

> "Anthropic always came off to me as what can shorthand be described as an abusive controlling partner + the resulting relationship.If you start viewing the conversations around it through that lens, a lot of stuff intuitively clicks into place.Including this apologism for example." — hypfer [comment: 48743408]
> （Anthropic 给我的印象一直是一个可以简称为“控制欲强的虐待型伴侣”以及由此产生的关系。如果你从这个角度看待围绕它的讨论，很多事情都会自然而然地明朗起来。包括这种辩解。）

有观点认为，如果 Anthropic 的目的是阻止“恶意”用户移除遥测数据或防止模型被“蒸馏”，那么采取混淆手段在技术上是可理解的。然而，大多数用户认为，即使存在这些动机，也无法为其缺乏公开披露的行为开脱。

### 知识产权保护与“公平使用”的双重标准

讨论中一个核心争议点是 Anthropic 在保护自身知识产权（`IP`）方面的立场，与 `AI` 模型训练中普遍存在的“公平使用”（fair use）原则之间的矛盾。

> "From my understanding, distilling the model with another model is not illegal per se. Also, the output of the LLM is public domain by law, too.So, why all this "effort" to protect the model? This is a free market, and moving fast and breaking things is the norm.If they are so adamant on protecting their IP, maybe they can start by respecting others' IP, so we can start talking about ethics, equality and playing fair." — bayindirh [comment: 48739112]
> （据我理解，用一个模型来蒸馏另一个模型本身并不违法。而且，`LLM` 的输出在法律上也是公共领域。那么，为什么要费尽心力保护模型呢？这是一个自由市场，快速行动和打破常规是常态。如果他们如此坚持保护自己的 `IP`，也许他们可以先尊重他人的 `IP`，这样我们才能开始谈论道德、平等和公平。）

用户指出，Anthropic 在训练其模型时可能受益于“公平使用”原则，但现在却采取强硬措施保护自身模型不被“蒸馏”，这种不对称性被视为虚伪，并引发了关于 `AI` 行业道德和公平竞争的深层讨论。

### 滑坡谬误与对 `AI` 监管的呼吁

一些评论者对 Anthropic 行为的潜在后果表示担忧，认为这可能导致更严重的滥用，从而引发了关于“滑坡谬误”（slippery slope fallacy）的辩论。

> "Anyone who called for regulations/guardrails of any kind were shouted down as Luddites who hate progress. We all knew this was going to be a mess but $$$ so screw it right?" — Forgeties79 [comment: 48743865]
> （任何呼吁进行任何形式的监管/护栏的人都被斥为仇视进步的卢德分子。我们都知道这会一团糟，但为了钱，管他呢，对吧？）

讨论还触及了对 `AI` 行业缺乏监管的担忧，许多用户认为，在没有外部约束的情况下，大型 `AI` 公司可能不会秉持“不作恶”的态度，并呼吁制定更明确的法规来规范 `AI` 服务的行为。

## 典型观点一览

| 立场 | 用户 | 一句话 |
|---|---|---|
| 批评缺乏透明度 | civet_java | 服务提供商对其工具在客户机器上具体做了什么缺乏透明度，这是不可接受的。 |
| 质疑道德底线 | ammo1662 | Anthropic 知道用户不会接受，所以才偷偷摸摸地使用隐写术，这越界了。 |
| 认为行为虚伪 | bayindirh | Anthropic 在训练模型时利用“公平使用”，现在却哭着保护自己的 `IP`，这是不对称的虚伪。 |
| 呼吁 `AI` 监管 | Forgeties79 | 那些呼吁监管的人曾被嘲笑为卢德分子，但我们都知道这迟早会变得一团糟。 |
| 辩护行为动机 | m11a | 如果担心“恶意”用户移除遥测数据，那么采取混淆方法是可理解的。 |
| 担忧滥用权力 | FooBarWidget | Anthropic 的服务条款已经允许他们打击批评者，并预设批评者会输掉官司。 |

## 总体情绪

Hacker News 社区对 Anthropic 被指控使用隐写术标记请求一事表现出强烈的负面情绪和担忧。讨论普遍围绕着对公司透明度、用户信任、数据隐私以及道德底线的质疑。许多用户认为 Anthropic 的行为是虚伪且具有潜在滥用性质的，并呼吁对 `AI` 行业进行更严格的监管。

**总体情绪：