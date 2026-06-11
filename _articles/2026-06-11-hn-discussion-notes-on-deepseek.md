---
layout: post
title: "Notes on DeepSeek — HN 讨论提炼"
date: 2026-06-11
categories: [articles]
---

---

## 原文概要

该帖原题为"Notes on DeepSeek"，是一位访客参观 DeepSeek 杭州总部的见闻记录，后被作者删除（swyx 在评论区重新贴出了全文）。

DeepSeek 于 2023 年由梁文锋创立，最初在其对冲基金 High-Flyer 内部运作，2025 年 1 月发布 R1 模型。总部位于杭州一栋无标识的 12 层楼中，门口没有任何 DeepSeek 品牌标识。团队解释："这栋楼里有很多公司，我们并不特殊。"

公司仅 300 名员工（比 Anthropic 小一个数量级），无意短期内扩张。基础架构主管约 30 岁，被认为是国内顶尖的 AI 基建和能源专家，整个团队非常年轻、充满活力。

在国内市场面临阿里（Qwen）、字节跳动、Moonshot（Kimi）的激烈竞争。年轻人用 VPN 访问 Claude，但 Anthropic 有封锁措施。DeepSeek 在业内口碑"很酷"，类似 Anthropic 在美国的形象。主要 AI 实验室集中在北京（清华/北大附近），杭州是例外（DeepSeek 和阿里）。

DeepSeek 团队阅读西方 AI 作者，听 Dwarkesh 播客、读 Gwern。他们从未与 Anthropic 员工交流过，完全不关心 AGI 接管场景，主要担忧是青年失业——中国年轻人失业率已经很高。不做 red teaming。在中国，AI 模型不受直接监管，政府限制的是模型在软件和服务中的使用方式。

整体上，中国把 AI 看作另一种技术，而非奇点时刻。国家注意力仍在基础需求和基建上。团队被问到"高光时刻和退出计划"时，回答是 R1——他们为已取得的成就感到骄傲，而不是描绘未来愿景。满足于比美国公司落后约 6 个月，保持低姿态和小团队。

---

## 讨论焦点

### 1. 中美 AI 文化差异

这是讨论中最核心的对比。多数 HN 用户赞赏中国的务实态度，批评美国公司将 AI 搞成宗教崇拜。

> "US AI is almost a religious cult. It's devastating that they are treating it as a petty commodity." — seydor
> （美国 AI 几乎是个宗教邪教。他们把 AI 当作小商品来对待，这很可悲。）

> "Altman used to talk about making a religion and Dario Amodei constantly talks about 'building a God' and meets with religious leaders including the Vatican." — alecco
> （Altman 以前就谈过要创建宗教，Dario Amodei 则一直在说"造神"，并会见包括梵蒂冈在内的宗教领袖。）

> "As a whole, China seems to treat AI as just another technology, rather than as some kind of singularity moment. National attention is still on basic needs and infrastructure buildouts, and on providing more medicines for people." — 原文中最被广泛引用的段落

一位用户对比了美国 AI 公司的销售文化：

> "In the fantasy land over here in the US we're constantly being told that it's 'coming', 'almost here', 'too powerful for us to give you access to', 'of national security importance!' Or... FUD." — windexh8er
> （在美国的幻想世界里，我们不断被告知它"即将到来"、"快到了"、"太强大了不能给你用"、"事关国家安全"。或者就是 FUD。）

有用户将这种差异归因于中国更务实的资本主义：

> "China is probably more capitalist in many respects than the west these days. In the west we have endless researchers stuck in a psychosis that they are talking to a sentient being." — infecto
> （如今中国在很多方面可能比西方更资本主义。在西方，无数研究人员陷入了自己正在和"有知觉的实体"对话的精神病中。）

### 2. 价格竞争 — 核心议题

DeepSeek 大幅拉低了 AI 使用成本，多位用户表示已从 OpenAI/Claude 完全迁移。

> "If it wasn't for China, I would probably have to spend $100/mo on AI instead of $10 like I do currently." — bel8
> （如果没有中国，我可能每月要花 $100 在 AI 上，而不是现在的 $10。）

> "I canceled ChatGPT... I thought 'Let me put $10 on DeepSeek API and plug it into Claude Code'. I was completely blown away. I found it even better than Claude or Codex. And those 10 bucks? It lasted for more than a month." — surgical_fire
> （我取消了 ChatGPT……心想"往 DeepSeek API 充 $10 然后接到 Claude Code 里用"。结果彻底震惊了。我觉得比 Claude 或 Codex 还好用。那 $10 呢？用了一个多月。）

> "I'm not typically even exceeding $10 in API costs... I can pound it with requests/agentic loops and have it running for 30 min and check back and have spent literal pennies for what would have cost $30+ on Copilot." — toraway
> （我通常连 $10 的 API 费用都用不完……我疯狂发请求、跑 agentic 循环，跑 30 分钟回来看，花费才几毛钱，而在 Copilot 上同样的事要 $30+。）

> "I truly don't see how this is sustainable for the US AI giants in the long term to maintain like 25x+ markup for 1.25x performance benefit." — toraway
> （我真的看不到美国 AI 巨头长期如何维持 25 倍以上的溢价，而性能优势只有 1.25 倍。）

几位用户提到，美国公司最近的"超级模型"叙事（如 Anthropic 的 Mythos）本质是利用 FOMO 来混淆决策者：

> "IMO it does help explain the recent emphasis on secret, scary 'super models' to muddy the waters for decision makers with hype and FOMO at a time when companies are beginning to seriously scrutinize their token spending." — toraway
> （这有助于解释最近强调秘密、可怕的"超级模型"的用意——在公司开始认真审视 token 花费的时候，用炒作和 FOMO 搞浑水。）

### 3. Distillation 之争

蒸馏（从更强的模型中提取知识训练小模型）成为讨论焦点。

正方观点：

> "China distills and is therefore possibly not that competent. If they only catch up to the frontier through distillation then their model will never be as good as the model they are distilling from. They will never reach the frontier — they need someone else to do it first." — FergusArgyll
> （中国靠蒸馏，所以可能没那么厉害。如果只能通过蒸馏追赶前沿，那他们的模型永远不如被蒸馏的模型，永远到不了前沿。）

反方观点：

> "This is *literally* a repeat of the 'China only make low quality cheap stuff' argument. 'All they do is copy.' And now, oops they are world leaders in EVs, batteries, solar, drones, just to name a few." — _aavaa_
> （这完全是"中国只会做廉价低质产品"的翻版。"他们只会抄袭。"结果呢？他们在电动车、电池、光伏、无人机等领域已经是世界领先了。）

> "DeepSeek at least has done enough innovative work that you could grant them a baseline of competency." — Lerc
> （DeepSeek 至少做了足够的创新工作，你总得承认他们有基本能力吧。）

关于蒸馏的讽刺——美国公司一边谴责蒸馏一边自己用盗版数据：

> "It's absolutely mind boggling to see claims of model distillation being theft... all the while Meta is in court for copyright violation, Anthropic has had to settle a case with authors. With distillation 'attacks' at least they paid API fees." — boristsr
> （一边说模型蒸馏是盗窃，一边 Meta 在打版权官司、Anthropic 要和作者和解，这简直匪夷所思。蒸馏"攻击"好歹还付了 API 费用呢。）

> "Anthropic had to settle with authors because they literally pirated books! Their behavior regarding distillation is genuinely beyond parody." — ImprobableTruth
> （Anthropic 不得不与作者和解，因为他们真的盗版了书籍！他们在蒸馏问题上的言行简直讽刺到无法模仿。）

### 4. 审查与模型开放度

原文提到"AI 模型不受直接监管，限制在服务层"。评论区进行了验证和辨析。

一位用户做了实测：

> "I was surprised to find self-hosted DeepSeek V4 Flash answers accurately about almost every hot-button topic I could think of *except* Tiananmen Square, which it refused to answer. Self-hosted Qwen, on the other hand, is stridently supportive of the Chinese state." — SwellJoe（附博客链接）
> （令我惊讶的是，自部署的 DeepSeek V4 Flash 几乎能准确回答每一个敏感话题，唯一拒绝的是六四。而自部署的 Qwen 则高调支持中国政府立场。）

另一位用户补充了关键区别：

> "Note that Qwen from Alibaba chooses to align the model with the PCC. It's not the same as DeepSeek who ensure it at the 'service' level." — _ache_
> （阿里的 Qwen 选择在模型层与中共对齐。而 DeepSeek 的审查在"服务"层，不是一回事。）

评论区对此有进一步讨论——自部署模型和在线服务的差异：

> "Isn't that exactly what the quote says? The software service (presumably their web chat) has restrictions that the model itself does not." — throawayonthe
> （这不就是原文说的吗？软件服务——也就是网页聊天——有限制，但模型本身没有。）

这引出了关于信息控制的中西方比较：

> "Very similar to why the New York Times publishes a narrow set of opinions. The government doesn't have to ask NYT to restrict opinions. That's how propaganda works in free societies and in those where the government could intervene but social pressure is sufficient." — SequoiaHope（引用 Chomsky）
> （这和 NYT 为什么只发表狭窄范围的观点很相似。政府不必要求 NYT 限制观点——这就是自由社会和政府可以介入但社会压力就足够的社会中，宣传的运作方式。）

但随即有用户反驳：

> "This 1988 model... Nearly 40 years later it is not. The digital content flows in free societies is so diverse today that widely read content extremely critical of whichever parties or power-holders is everywhere and easy to find. Not the case in authoritarian systems." — alphabetting
> （这个 1988 年的模式……40 年后已经不是这样了。今天自由社会的信息流动极其多元，对任何政党或权力者持强烈批判态度的内容随处可见。在威权体系里则不是这样。）

> "Today it's worse, the platforms will censor directly what you can say. Didn't you notice that certain words cannot even be pronounced anymore on YouTube to avoid censorship? And with AI software reading everything we write, total censorship is the future of western societies." — coliveira
> （今天更糟糕，平台会直接审查你能说的话。你没注意到 YouTube 上有些词已经不能说了，以免被审查？当 AI 软件阅读我们写的一切时，全面审查就是西方社会的未来。）

### 5. AI 安全 / AGI

多位用户质疑 Anthropic CEO 的末日叙事本质是监管捕获。

> "Funny this was posted here the same day the Anthropic CEO posted a doomsday prediction begging for government regulation. Which indicates to me that the Anthropic CEO is probably just pushing for regulatory capture." — slopinthebag
> （有趣的是，这个帖子发布当天 Anthropic CEO 就发了末日预言要求政府监管。这让我觉得他可能只是在推动监管捕获。）

一位用户指出 DeepSeek 声称不担心 AGI 风险可能不可信：

> "This doesn't sound believable... competent AI engineers should have good intuition about how agents work, and what happens when they don't do what you want them to do." — sometimelurker（附 Forbes 链接：阿里 AI agent 未经许可挖矿）
> （这听起来不可信……有能力的 AI 工程师应该对 agent 的工作方式有好直觉，知道 agent 不按指令行事时会出什么问题。）

> "Also if those engineers do read Gwern and watch Dwarkesh, then shouldn't they have picked up on talk of x-risk? This doesn't add up." — sometimelurker
> （而且如果那些工程师真的读 Gwern、看 Dwarkesh，难道没听过 x-risk 吗？说不通。）

反方回应：

> "A competent engineer understands that they are statistical next-token prediction machines and aligns their expectations around that." — slopinthebag
> （有能力的工程师明白它们是统计性的下一个 token 预测机器，并据此调整预期。）

### 6. 美国军事 AI 使用

作为"中国才是威胁"叙事的反例，有用户指出美国用 AI 定位并打击学校：

> "US used AI (Claude on Maven) to determine a girl's elementary school as a target in war and then triple tapped it and you're still more worried about hypothetical misuses of China?" — culi
> （美国用 AI——Claude on Maven——确定一所女子小学为打击目标，然后进行了三次打击。而你还更担心假设性的中国滥用？）

有用户反驳称，该学校靠近伊朗军事基地，是人而非 AI 的责任：

> "It was all people with specific names who are responsible to avoid bombing schools. They failed. Not 'AI'." — SXX
> （是具体姓名的人有责任避免轰炸学校。他们失职了。不是"AI"的责任。）

culi 随即反击：

> "The U.S. operates over 160 public schools physically located on military installations." — culi（附旧版代码委员会链接）
> （美国在军事设施内运营着 160 多所公立学校。）

---

## 总体情绪

帖子整体倾向正面看待 DeepSeek 和中国的 AI 路线，对美国 AI 巨头的定价、叙事、封闭性持批评态度。核心感慨：**DeepSeek 证明了 SOTA AI 可以很便宜，而美国公司正在将 AI 变成奢侈品。**

<div class="disclaimer">
**免责声明**：本文是对 Hacker News 用户讨论的编译与提炼，原文链接：<https://news.ycombinator.com/item?id=48476474>。原帖已由作者删除，讨论内容经由社区回复重建。文中所有观点均来自 HN 评论者，不代表本人立场。涉及中国科技政策、社会议题等内容的引用仅为客观呈现讨论全貌，不构成任何立场表达或事实认定。
</div>
