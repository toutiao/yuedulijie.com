---
layout: post
title: "欧洲数字 ID 钱包依赖 Google 和 Apple 安全服务 — HN 讨论摘要"
date: 2026-07-02
categories: [articles]
excerpt: "欧盟多国正在推行的数字身份钱包，底层依赖 Google Play Integrity 和 Apple 的设备证明服务。这意味着使用 GrapheneOS、e/OS 等去 Google 化操作系统的用户可能被排斥在公共服务之外。HN 社区对此展开了激烈辩论。"
tagline: "欧盟说要打破科技垄断，却把公民的数字身份钥匙交到了 Google 和 Apple 手里。瑞士已经放弃了这条路，荷兰和意大利还在加倍下注。"
---

## 原文概要

2026 年 7 月 1 日，Waag 发表了一篇文章，指出欧洲多国正在推行的数字身份钱包存在一个严重的设计问题：这些钱包的底层安全机制依赖 Google Play Integrity API 和 Apple 的 Managed Device Attestation——即 Google 和 Apple 的远程证明服务。

Google Play Integrity API 的作用是验证设备是否运行在"经过认证的 Android 设备"上。但这同时也意味着，它只认可 Google 许可版的 Android——去 Google 化的操作系统如 GrapheneOS、e/OS 会被视为潜在的安全风险。Waag 指出，Android 其实存在一个更开放的替代方案：Android Hardware Attestation API，它提供硬件级安全校验，但不强制绑定 Google 的生态系统策略。

问题不仅存在于技术层面。荷兰和意大利的钱包应用直接集成了 Play Integrity，这意味着用户如果想使用这些公共服务，就必须使用搭载 Google 软件的设备。而欧盟框架文件（Architecture Reference Framework）虽未强制要求使用 Google 证明服务，却将其列为推荐方案——这导致各成员国执行标准不一。瑞士已主动弃用 Play Integrity，转而使用 Android 原生的证明机制。

来源：HN 热门榜 (/best)

## 讨论焦点

### GrapheneOS 用户被排斥在公共服务之外

讨论的开端是一位用户指出，欧盟钱包参考框架明确要求使用 Google Play Services。意大利的 IO 应用（钱包、文件、年龄验证）持续拒绝 GrapheneOS 用户的接入请求：

> "The EU reference for wallets strictly required google play services. So Italy's IO app (wallet, documents, age verification) continuously refuses the users' request for GrapheneOS support and requires google. Nothing will change until the lawsuits start coming in." — Luker88

另一位 Fairphone 6 用户（e/OS 系统）直接质问：作为欧盟公民，却无法使用自己本应有权使用的应用。

### 两条战线：废除远程证明 vs 公平化远程证明

远程证明（remote attestation）技术本身是否应该存在，社区存在两种战略分歧。

microtonal 提出了两条值得同时推进的战线的观点：

> "I think there are two fights that are both worth fighting: 1. Completely outlawing remote attestation. 2. In a world where remote attestation is given, let it be controlled in a fair way and not just by Google and Apple. The risk is that only fighting for (1) leaves you in a world with remote attestation, where only Google and Apple can decide who gets to pass and who not." — microtonal

支持禁令的一方认为，远程证明在设备端的应用本质上是反竞争。pimterry 指出：

> "If we gatekeep service access to specific implementation attestations, it becomes much harder for new implementations to emerge. It doesn't really matter who controls the process. In that sense, it's always bad." — pimterry

qurren 则从纯技术角度论证，信任应该建立在密码学协议层面，而不是硬件限制：

> "It's much better to base trust on established cryptographic methods on a protocol level. You treat them as a black box, and the trust is established by the inputs and outputs, not what's inside the box." — qurren

但有用户也指出，远程证明在特定场景下有其价值——比如服务端向用户证明自己运行的是未被篡改的代码。

### 现实中证明机制被滥用

一位在大型游戏公司工作的用户分享了实际使用经验，指出现实中企业从未将证明机制用作"风险评估"，而是简单地二元裁决：

> "I cannot think of any company that has appropriately used attestation as a trust/risk calculation. I work in major game studio; there is never calculation only a binary. It never 'let's check if the mobile user has purchased in-game content server side to prevent pirating', it's 'suspend any account that has signed in with a device that fails safetynet, permanently ban any account that has failed a jailbreak or root checks'." — femboyvtuber

这位用户还补充，他们公司之所以在某些地区放松了 Play Services 检查，唯一原因是中国区不使用 Google 认证设备的用户消费额最大。

### 主权与技术依赖的两难

多位用户将讨论引向了地缘政治层面。考虑到最近 Anthropic 出口管制事件（Fable 5 被限制后解禁），美国科技公司不可靠已成为社区共识：

> "It's honestly quite baffling that the EU would want to put any more power in the hands of any US controlled company at this point. The US is a borderline hostile state, only recently threatening to invade Greenland among numerous other examples. The situation with Anthropic has illustrated that the US government will not hesitate to leverage power over US companies when it feels its interests are advantaged by doing so. If anything, the EU should be banning use of Google or Apple dependent architectures, not pseudo mandating them." — zmmmmm

deaux 的评论一针见血：

> "It's even more expensive to have your country's digital ID held hostage by the US or its big tech players." — deaux

也有用户持务实态度，指出在当下确实缺乏第三选择——但可以政府主导提供替代方案。ulrikrasmussen 提到丹麦 MitID 的做法值得参考：虽然 App 依赖 Play Integrity，但政府同时提供免费的 TOTP 码生成器或 FIDO2 芯片作为替代方案。

### 数字 ID 本身的隐私争议

讨论也延伸到了欧盟数字身份体系本身——有人质疑，问题的核心也许不是 Google 还是欧盟控制，而是政府是否应该拥有如此全面的数字追踪能力：

> "I like how we quickly moved past the fact that the government wants to know who we are, what we visit, what we say, what we buy, and has explicitly said that they want to control what we buy, where we go, and what we are allowed to say. But we are focused on what specific mega-corporation those systems will use to function." — greenleafone7

一位用户指出，欧盟数字钱包不是匿名的——它的 provider/verifier 端点在验证用户身份后，会通知网站该用户是否年满 18 岁。这意味着政府可以通过 IP、时间戳和 Token 追踪用户的账户活动。

## 典型观点一览

| 立场 | 用户 | 一句话 |
|------|------|--------|
| 技术层面被排斥 | Luker88 | 欧盟钱包要求 Google Play Services，GrapheneOS 用户被拒之门外 |
| 两条战线并存 | microtonal | 既要争取彻底废除远程证明，也要争取证明机制的公平化 |
| 证明机制反竞争 | pimterry | 任何形式的服务访问证明都会阻碍新生态系统的出现 |
| 信任应建立在密码学上 | qurren | 用输入输出来建立信任，而不是依赖硬件限制 |
| 企业滥用证明 | femboyvtuber | 现实中证明从未被用作风险评估，只有二元封禁 |
| 主权风险 | zmmmmm | 欧盟不应该半强制性地让美国公司掌控关键基础设施 |
| 务实替代 | ulrikrasmussen | 丹麦同时提供 TOTP 和 FIDO2 作为非智能手机方案 |
| 质疑数字 ID 本身 | greenleafone7 | 政府想要知道你的一切，而我们却在讨论谁控制这套系统 |

## 总体情绪

讨论氛围严肃且偏向悲观。技术社区的共识是：将公共基础设施的关键安全环节交给两家美国公司，在战略上是不明智的——尤其是考虑到不断升级的地缘政治紧张态势。但社区对解决方案存在分歧：一派主张彻底废除远程证明，另一派主张推动证明机制的开放和公平化。

围绕隐私的讨论则更加根本：数字 ID 钱包本身就是一把双刃剑。即使摆脱了 Google 和 Apple，欧盟政府获得的全新追踪能力是否比科技巨头的垄断更值得担忧？这个问题没有答案，但至少在 HN 社区中被清晰地提了出来。

## 引用帖子

| # | 标题 | URL |
|---|------|-----|
| 1 | European digital ID wallets rely on safety services of Google and Apple | https://news.ycombinator.com/item?id=48730729 |
| 2 | Waag 原文 | https://waag.org/en/article/european-digital-id-wallets-are-gift-google-and-apple/ |

<div class="disclaimer">
  本文总结了 Hacker News 用户对以上文章的讨论，仅作信息整理用途，不代表本文立场。讨论中的观点属于各参与者，未经事实核查。内容仅供参考。
</div>
