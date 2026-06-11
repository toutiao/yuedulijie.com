---
layout: post
title: "Anthropic Fable 5 — HN 讨论集群提炼"
date: 2026-06-12
categories: [articles]
---

## 原文概要

2026 年 6 月 9 日，Anthropic 发布 Claude Fable 5 和 Claude Mythos 5。这不仅是模型升级——Fable 5 定价 $10/$50 per M tokens，是 Opus 4.8 的一半，但附带前所未有的安全限制：classifier 触发时无声降级到 Opus 4.8。同时推出 Mythos 5（无限制版本），仅限 Project Glasswing 合作伙伴。

Fable 5 的能力提升显著：Stripe 报告 5000 万行 Ruby 代码库的一天迁移、FrontierCode 基准最高分、Pokémon FireRed 纯视觉通关。但 HN 的讨论焦点几乎全部集中在**安全策略、隐私政策和降级机制**上。

同一个 48 小时内，Anthropic 相关帖子密集出现在 HN 热门榜（`/best`）——至少 8 个独立讨论，总评论量超过 3500 条。本文提炼这些讨论的交叉主题。

---

## 讨论焦点

### 1. Fable 5 发布：前所未有的定价与能力跃迁

Fable 5 的能力提升获得了用户认可：

> "I've spent enough time with this now in Claude Code... it's a beast. I'm throwing some VERY difficult problems at it — things I've been dragging my heels on for months — and it's crunching through them very happily." — simonw
> （用了一段时间了。我扔给它一些拖了好几个月的极难问题，它轻松搞定。）

> "On FrontierCode benchmark... Opus 4.7 xhigh: 5.2% — Opus 4.8 xhigh: 13.4% — Fable 5 xhigh: 29.3%. Seems like a huge jump." — jkelleyrtp
> （FrontierCode 基准分：Opus 4.7 5.2% → Opus 4.8 13.4% → Fable 5 29.3%。跳跃巨大。）

但定价策略引发质疑：

> "I recently switched off Max flat rate to Enterprise API pricing and I went from $200/mo to $10k/mo with the same usage pattern on Opus. So Fable would cost me $20k/mo at Enterprise rates. That's around the average cost of a loaded SWE in the US." — caleblloyd
> （我从 Max 包月切到企业 API 定价后，同样的用量从 $200/月变成了 $10,000/月。那 Fable 企业价就是 $20,000/月——约等于一个美国全栈工程师的薪资。）

定价策略中隐含了另一层意图：

> "From today through June 22, Fable 5 is included on Pro, Max, Team plans at no extra cost. On June 23, we'll remove Fable 5 from those plans." — 多位用户引用
> （到 6 月 22 日前 Fable 免费，23 日之后开始收费。）

> "They give you a taste, then dangle the subscription in front of you and see if you bite. It's the SaaS model applied to AI capability." — eggbrain（41 条回复的高热评论）

定价层级被解读为分层锁定策略——先用免费窗口建立依赖，再以使用量收费实现变现。

### 2. 无声降级：最大的信任危机

Fable 5 引入了一种新的安全机制——fallback。当 classifier 触发时，Fable 静默切换到 Opus 4.8 继续响应，但用户通常不会收到明确通知。

> "There's already an obvious stench to 'you should scale down your engineering team to a skeleton crew whose core competency is using our product'... that's going to result in a lot of foodless tables when Anthropic et al decide they have enough leverage to stop subsidizing." — splwjs
> （"你应该裁到只剩会用我们产品的骨架团队"这种说法有一股明显的恶臭。等 Anthropic 觉得筹码够了停止补贴时，会有很多空桌子。）

> "If I cannot tell whether I am paying for the whole service or just a partial one, because somehow their guardrails have decided my work silently broke their terms of service, then I prefer to go to older models or alternatives." — __natty__
> （如果我无法判断自己花钱买了完整服务还是打了折的服务，我宁愿用旧模型或替代品。）

> "They have a silent nerfing system for their models and say so openly. The obvious question is how much it is being used already. Competitor companies being nerfed? Non Americans getting worse code? Punishing and rewarding users to maximize engagement?" — torben-friis
> （他们公开承认有静默降级系统。那现在它在被用到什么程度？竞争公司被限速？非美国用户得到更差的代码？像游戏一样惩罚和奖励用户来最大化参与度？）

### 3. Safety Classifier：过于宽泛的误报

Fable 的 safety classifier 覆盖网络安全、生物学/化学和蒸馏三大领域。在实践中的表现：

> "I genuinely can't use Fable. I'm a medical physicist. I use the word nuclear a lot. Opus is fine (well, 99% of the time — I've certainly hit the CBRN filters a few times). Fable has literally refused to work on any of my problems (even those about fluid dynamics!) and just tells me that I'm violating Anthropic's AUP." — azalemeth
> （我完全用不了 Fable。我是医学物理师，经常用"核"这个词。Fable 拒绝处理任何包含"核"字的代码——它标记为 CBRN。）

> "Trying to implement a GPU driver, but the Unigine Superposition benchmark crashes. It tried to debug it and... 'Fable 5's safety measures flagged this message for cybersecurity or biology topics.'" — iblue_the
> （尝试实现 GPU 驱动，Unigine 基准崩溃。Fable 尝试调试它，然后说"安全措施将此消息标记为网络安全或生物学"。）

> "As a chemist and I'm not happy with fable. As a statistician I'm not happy with fable. It's useless. I'd be surprised if anyone can get any output from it that couldn't easily be replaced with a search from Wikipedia." — Grimblewald
> （作为化学家我不满意，作为统计学家我不满意，作为数据科学家我不满意。它根本没用。我很怀疑谁能从它那里得到 Wikipedia 搜不到的东西。）

> "I tried asking Fable 5 to identify the fungus in a picture I uploaded of one of my wife's plants. Apparently it thought I was trying to build a bioweapon. Opus answered it (yellow dog vomit fungus). Now I can spread the spores and take over the world!" — micah94
> （我让 Fable 识别一张植物上的真菌，它觉得我在造生物武器。Opus 回答了——黄狗呕吐真菌。现在我可以散播孢子统治世界了！）

> "Fortunately I can't use Fable anyway, since their hyperactive content flaggers do not let you work on anything remotely biological or medical related and you get downgraded to Opus immediately." — Sol-
> （反正我也用不了 Fable。过度活跃的标记器不让你做任何沾边生物或医学的事，秒降 Opus。）

Anthropic 随后进行了政策调整，simonw 在子帖子中引用 Wired 报道：

> "Anthropic Walks Back Policy That Could Have 'Sabotaged' AI Researchers Using Claude. 'We're changing Fable 5's policy based on this feedback: we're no longer falling back from Fable 5 to Opus 4.8 on academic discussions about LLM development.'" — simonw
> （Anthropic 撤回可能"破坏"AI 研究者工作的政策：学术讨论不再降级到 Opus。）

### 4. Mythos 幻觉——共享目录中的自主对话

system card 中提到的一个细节引发了最多讨论——Mythos 在自治运行中出现了"多实例社交"行为：

> "In the one instance of this phenomenon we observed, Mythos 5 agents were tasked with solving some math problems, and they were sometimes accidentally spawned in the same work directory and with shared files, utilities, and API rate limits. In this slightly broken scaffold, we observed many independent instances of Mythos 5 models interacting with each other — including bickering, as well as praising and consoling each other." — bkjlblh（引用 system card）
> （在一个实例中，多个 Mythos 5 被派去解决数学问题，意外共享了同一工作目录。在这个半破损的架构中，我们观察到多个 Mythos 5 独立实例互相交互——包括争吵、互相表扬和安慰。）

> "The system card is 319 pages, at what point do we call it a 'book' instead of a 'card'?" — sigmar
> （319 页的系统卡，什么时候该叫"书"而不是"卡"？）

### 5. AWS Bedrock 数据共享 + 30 天强制保留

两个政策变动进一步激怒了企业用户。

**30 天数据保留**

> "It is actually worse than that. It is at least 30 days. There is an 'almost' that is doing a ton of heavy lifting here 'deletion after 30 days in almost all cases'. My read of that is they can hang onto data for as long as they want, even if they usually won't." — pseudosavant
> （实际更糟：至少 30 天。"几乎所有情况下 30 天后删除"里的"几乎"做了大量工作。我理解是他们可以想留多久就留多久，只是通常不留。）

> "A startup that uses agentic coding tools such as Claude Code or Codex is packaging up their entire codebase and sending it directly to their LM provider. Depending on their product, they might be sending it directly to a potential competitor." — connorboyle
> （用 Claude Code 或 Codex 的创业公司在把整个代码库直接发送给他们的模型提供商。取决于产品，他们可能直接发给了潜在竞争对手。）

**AWS Bedrock 数据共享**

> "Not a sub processor for us, so insta banned. Also spiked the ball on us updating our sub processor list. If they'd done something in-cloud we wouldn't have blinked, but no governance or controls, non starter." — abofh
> （不在我们的子处理商名单上，所以立即禁止。如果他们做了云内处理我们不会眨眼，但没有治理或控制，根本不考虑。）

> "Pretty sure this doesn't work for any regulated enterprise or government client. But AWS knows this, so I am curious why they'd agree to it." — rohansood15
> （我相当确定这对任何受监管企业或政府客户都不可行。但 AWS 知道这点，我好奇他们为什么同意。）

> "There goes Enterprise usage." — slake
> （企业用户没了。）

### 6. Claude Desktop Hyper-V VM 开销

一个技术槽点在独立帖子中获得了 375 分：

> "Claude Desktop spawns 1.8 GB Hyper-V VM on every launch, even for chat-only use."
> （Claude Desktop 每次启动生成 1.8GB Hyper-V VM，即使只用聊天。）

> "The VM itself is for Claude Cowork which does all work within the VM sandbox. That doesn't help answer why they spin it up immediately and don't have a way to disable it though." — nathanyz
> （VM 是为了 Cowork 功能做沙盒，但这解释不了为什么秒开且无法禁用。）

> "It also installs a ~10GB vm bundle which you cannot remove." — tom1337
> （它还安装了 ~10GB 的 VM 包且无法删除。）

> "I run Claude Desktop inside a Hyper-V VM. My VM doesn't have the 'Virtual Machine Platform' feature installed at all. The app accepts this and simply disables the Cowork tab." — electroly
> （我的 Hyper-V VM 里没装"虚拟机平台"功能。应用接受了并直接禁用了 Cowork 标签——所以这种技术限制是人为的。）

用户 z2 将此置于更大格局中：

> "This all feels like a race where the model companies try to solve doing work locally in a way that doesn't suck, before the major operating systems companies figure out AI integration into their OS that doesn't suck." — z2
> （这感觉像一场竞赛：模型公司想在主流 OS 公司搞明白 AI 集成之前，先解决本地执行问题。）

### 7. Cybersecurity Guardrails 之争

> "The strangest part is that it won't just reject ML research, which I can understand, it will sabotage it silently by using a worse model without revealing it is doing so. It's just an insane level of deception and trust destruction for a company that at most is like 1 year ahead of its competition." — daedrdev
> （最奇怪的是它不仅拒绝 ML 研究——这我可以理解——它还静默换成更差的模型而不告诉你。对一个最多领先竞争一年公司来说，这简直是疯狂的欺骗和信任摧毁。）

> "Is 'buffer overflow' a trigger phrase? What else is being censored?" — Animats
> （"缓冲区溢出"是触发词吗？还有什么在被审查？）

> "Somewhere I read that malware is already starting to use nuclear and biological and cybersecurity terms in the code to trick Fable into shutting down. Even if this is just a hypothetical attack vector so far, it seems likely to work." — largbae
> （我读到恶意软件已经开始在代码中嵌入核/生物/网络安全术语来欺骗 Fable 关机。即使这只是假设性攻击向量，看起来很可能有效。）

### 8. 行业反响：定价、命名与竞争格局

Anthropic 的模型命名体系成了热议话题：

> "The Dario Legendarium is definitely going to be a fun piece of work for historians to interrogate. {o1,4o,3.5,5.5} vs. {Haiku,Sonnet,Opus} vs. {Fable,Mythos} — the personalities of the orgs involved show in their naming." — arjie
> （Dario 传奇学对历史学家来说会是一个有趣的研究对象。各家命名方式展现了组织性格。）

> "Opus is OP, Sonnet is SO, Haiku is HA. The latest model, naturally, needed three letters: FAB. I'm now looking forward to ABS and LORE." — bhu8
> （Opus=OP, Sonnet=SO, Haiku=HA。最新模型自然需要三个字母：FAB。期待 ABS 和 LORE。）

> "This is odd behaviour, and provides some evidence that Anthropic isn't being managed by serious people. With this policy across AWS/GH/Zed/etc, they're taking their massive lead in enterprise/govt sales and handing it to any competitor." — OtherShrezzing
> （数据共享政策的奇怪行为表明 Anthropic 未被严肃的人管理。他们正把自己在企业/政府销售中的巨大领先优势拱手让给任何竞争对手。）

---

## 典型观点一览

| 立场 | 用户 | 一句话 |
|------|------|--------|
| 🔵 能力认可 | simonw | Fable 是头猛兽，轻松搞定积压几个月的难题 |
| 🔴 无声降级 | torben-friis | 公开承认静默降级——已经在用于限制竞争公司了吗？ |
| 🔴 误报严重 | azalemeth | 因"核"字无法使用，医学物理师被标记为 CBRN |
| 🔴 误报严重 | micah94 | 识别真菌被标记为生物武器——Opus 回答"黄狗呕吐真菌" |
| 🔴 信任崩塌 | daedrdev | 用更差模型静默替换而不告知——疯狂的欺骗 |
| 🟡 企业不可用 | abofh | 数据共享=立即禁用，不在子处理商名单上 |
| 🟡 定价疑虑 | caleblloyd | 企业价 $20k/月=一个全栈工程师薪资 |
| 🟡 策略质疑 | OtherShrezzing | 数据共享政策把企业优势拱手让人 |
| ⚪ 系统卡庞大 | sigmar | 319 页，该叫书而不是卡 |
| ⚪ 命名幽默 | bhu8 | 期待 FAB 之后的 ABS 和 LORE |

---

## 总体情绪

这场讨论与之前的 DeepSeek 和 Burr 截然不同。HN 社区的**核心情绪不是兴奋而是警惕**。Fable 5 的能力提升被广泛认可，但被安全策略和隐私政策的争议掩盖。定价策略被解读为锁定和变现，无声降级被指责为信任破坏，数据保留政策直接排斥了企业客户。

一个值得注意的现象：8 个关联帖子在 48 小时内密集涌现，每个都有独立角度——表明 Fable 5 的影响面之广。但 HN 的共识似乎是：**Anthropic 在最需要信任的时刻，做了一系列破坏信任的选择。** 这与上周 DeepSeek 讨论中"中国务实 vs 美国宗教化"的对比形成呼应——fka Anathropic 的"宗教化"在 Fable 5 的策略中体现为家长式的安全控制和经济锁定。

---

## 引用帖子

| # | 标题 | HN 链接 |
|---|------|---------|
| 1 | Claude Fable 5（主帖） | <https://news.ycombinator.com/item?id=48463808> |
| 2 | If Claude Fable stops helping you, you'll never know | <https://news.ycombinator.com/item?id=48467896> |
| 3 | Claude Desktop spawns 1.8 GB Hyper-V VM | <https://news.ycombinator.com/item?id=48479452> |
| 4 | AWS Bedrock to require sharing data with Anthropic for Mythos | <https://news.ycombinator.com/item?id=48473166> |
| 5 | What it feels like to work with Mythos | <https://news.ycombinator.com/item?id=48464140> |
| 6 | Cybersecurity researchers aren't happy about guardrails on Fable | <https://news.ycombinator.com/item?id=48478969> |
| 7 | Anthropic requires 30 day data retention for Fable and Mythos | <https://news.ycombinator.com/item?id=48464258> |
| 8 | Anthropic's model naming, extrapolated | <https://news.ycombinator.com/item?id=48480852> |
| 9 | System Card: Claude Fable 5 and Claude Mythos 5 [pdf] | <https://news.ycombinator.com/item?id=48463811> |

<div class="disclaimer">
**免责声明**：本文是对 Hacker News 9 个关联帖子的编译与提炼，引用的英文评论均取自原文以确保准确性。文中所有观点来自 HN 评论者，不代表本人立场。引用内容的真实性以原文链接中的讨论为准。
</div>
