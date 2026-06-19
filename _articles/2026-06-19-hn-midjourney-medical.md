---
layout: post
title: "Midjourney Medical — HN 讨论摘要"
date: 2026-06-19
categories: [articles]
---

## 原文概要

Midjourney 宣布进入医疗影像领域，推出 Midjourney Medical —— 一款基于超声波的全身扫描设备。用户只需站立在充满水的扫描舱中 60 秒，设备通过 358,000 个传感器从 360 度采集数据，再借由 AI 算法重建出三维身体图像。项目发布后登顶 HN 热门榜 (/best)，获 1281 分、844 条评论。

产品定位介于医疗设备与健康水疗之间。Midjourney 在官网上明确声明产品"非医疗用途"，但宣传中大量使用医学影像术语，并引用了"早期影像检查可避免全球 30% 的死亡和 50% 的医疗开支"这样极具争议的论断。视频演示展示了类似低分辨率 CT 的重建图像，团队承诺随着迭代质量将不断提升。

## 讨论焦点

### 超声波的物理极限：一名放射科医生的一线观察

帖子中评分最高的评论来自一位自称有 14 年执业经验的放射科医生 (jmhmd)。他从多个角度对产品提出了尖锐但保留善意的质疑。

> "This looks really cool and I hope they keep innovating on this. I love seeing new modalities develop and despite my (many) reservations and criticisms, if even one good use case comes out of it that truly helps people, it's tech money well spent imo." — jmhmd

> （这看起来真的很酷，我希望他们继续创新。尽管我有许多保留和批评，但如果能出现一个真正帮助到人的用例，这钱就花得值。）

他随即列举了超声波固有的物理限制：

> "Ultrasound cannot image the lungs, as they are filled with air. You cannot find bone lesions, as the sound waves do not penetrate the cortex. You cannot image many structures in the abdomen if they are surrounded by gas-filled bowel. The brain is encased in bone, so you might get some penetration but it will be very limited." — jmhmd

> （超声波无法对肺部成像，因为肺里充满空气。声波无法穿透骨皮质，因此骨病变无法检出。腹部许多器官被含气的肠管包围，也无法成像。大脑被颅骨包裹，穿透深度极为有限。）

他强调："即便有理论上完美的 AI 重建，这些扫描也不可能做到真正的'全身'——有些结构就是无法可靠成像。"他设想的场景令人警醒：你花了好几年做定期全身扫描，每次都显示一切正常，然后某一天你被肺部结节夺走生命——而它在超声波中从来就不可见。

> "The claim that 'it's completely possible that with enough early imaging in the future, the world could avoid 30% of all deaths and 50% of all healthcare costs', I think, to any practicing physician, would sound completely divorced from reality." — jmhmd

> （"未来通过充分的早期影像检查，全球可避免 30% 的死亡和 50% 的医疗开支"——这句话在任何从业医生听来，恐怕都与现实完全脱节。）

### 全波反演：技术路线之争

另一位同样自称放射科医生的评论者 haldujai 则提供了更技术性的平衡视角。他提醒大家，Midjourney 用的不是传统的脉冲波 B 型模式 (pulsed wave B mode)，而是全波反演 (full wave inversion, FWI)：

> "Remember this is full wave inversion not pulsed wave B mode. You can get much more useful information from both high low frequency and capture transmitted waves." — haldujai

> （记住这是全波反演，不是脉冲波 B 模式。通过同时利用高频和低频、捕捉透射波，可以获得更多有用信息。）

评论者 lebovic 进一步解释了 FWI 的原理：

> "Full wave inversion uses all of the information from the wave and more intense computational tomography to image structures that pulse wave B mode cannot, though gases are still a problem. Computationally, if you squint, it's similar to the work Midjourney does with AI image generation, as it progressively generates a structure that fits the data." — lebovic

> （全波反演利用波的全部信息，通过更强的计算层析成像来呈现脉冲波 B 模式无法呈现的结构。只不过气体仍然是个问题。从计算角度看，这与 Midjourney 在 AI 图像生成方面的工作有相似之处——逐步生成符合数据的最佳结构。）

不过，包括 haldujai 在内的医生也指出，即便 FWI 能改善一些问题，其临床价值能否超过便携式低场强 MRI 是另一回事。

### Butterfly 芯片再包装：产品真实面目

评论者 mrandish 通过深入调查，提出了一个影响广泛的指控：Midjourney Medical 并非自研传感器，而是采购了 Butterfly Network（一家已有手持式超声产品的公司）的换能器芯片。

> "MJ is buying the transducer chips used in Butterfly's low-cost, handheld, pocket-sized USB ultrasound device (it's not an R&D license, they're literally buying the same chip)." — mrandish

> （MJ 买的是 Butterfly 低成本手持式 USB 超声设备上用的换能器芯片——不是研发授权，就是直接从供应商那里买了同一款芯片。）

他指出，"把换能器放在离器官 200-400 倍远的地方，中间隔着大量水"只会使信噪比指数级恶化。AI 的作用不是增强诊断能力，而是"从噪声和多重路径问题造成的信号灾难中勉强恢复一些信息"。

> "This isn't an 'exciting new approach to medical imaging.' It's a marketing repackage of an existing medical product into a non-medical, higher-cost, 'spa experience' with trendy, tech-adjacent appeal and vaguely medical-ish window dressing." — mrandish

> （这不是"激动人心的医疗影像新方法"。它是对现有医疗产品的营销再包装，变成了一种非医疗用途、成本更高、带有科技感的"水疗体验"，外加模糊的医疗术语装饰。）

作为对比，Butterfly 的产品已通过 FDA 批准并且具有经过验证的诊断价值，而 Midjourney 对这一核心差异的回避态度引发了大量不满。

### AI 重建的可靠性陷阱

从事 MRI 分析的评论者 SubiculumCode 从一个更通用的角度发出警告：当一种成像方式高度依赖深度学习模型来"重建"图像时，训练分布与真实患者之间的偏差可能成为致命问题。

> "Midjourney Medical might train a model to produce pretty images with this technique, but the more they need to depend on deep-learning models to get usable data, the more that the match between the training distribution and patient will matter." — SubiculumCode

> （Midjourney Medical 可能会用深度学习来生成漂亮的图像，但越依赖深度学习来获取可用数据，训练分布与患者之间的匹配程度就越关键。）

他以自己在海马体亚区 (hippocampal subfields) 分割研究中的亲身经历为例：一些工具用低分辨率输入配合深度学习生成"壮观的漂亮分割图"，但数据质量实际上不足以支撑结论。"I've rejected a number of papers for this."（我已经为此拒了好几篇论文了。）

放射科医生 jmhmd 对此回应："This is a critical point. I am curious what the team building this looks like? Do they have ultrasound physicists and clinical practitioners in addition to the AI researchers?"（这是一个关键问题。我很好奇这个团队的构成——除了 AI 研究员，他们有超声物理学家和临床医生吗？）

### 偶然发现（Incidentaloma）与过度诊断

讨论中另一个深入的话题是"偶然发现"（incidentaloma，即无意中发现的、大概率良性的异常影像）在群体筛查中带来的连锁反应。

放射科医生解释说，即便对单个患者来说"多一次扫描没什么"，但当数以千计的人发现良性肾上腺腺瘤并需要随访时，就会挤占真正重症患者（如淋巴瘤康复者）的复查资源。

> "A lymphoma patient in remission needs follow up scans too, and I don't want them to have to wait 3 months because thousands of people are now following up their benign adrenal adenomas." — jmhmd

> （缓解期的淋巴瘤患者也需要随访扫描，我不希望他们为了等检查排三个月队，只是因为成千上万的人现在都在随访自己的良性肾上腺腺瘤。）

评论者 queuebert 从统计学角度进一步佐证：

> "Statistically overdetection leads to poorer outcomes because interventions have a risk as well. The current guidelines are based on optimizing for maximum good, and believe it or not some things are best not known about because the risk of dying from it is about the same as the risk of the treatment." — queuebert

> （从统计上看，过度检出反而会导致更差的结局，因为干预本身也有风险。现行指南是基于最大化整体利益而制定的——信不信由你，有些事情最好不知道，因为死于它的风险和死于治疗的风险差不多。）

### 新的观察方式：历史会重演吗？

并非所有评论都是唱衰。评论者 iandanforth 提出了一个更具哲学性的论点：

> "The history of medicine, and science in general, is that creating new ways to look at things has a tendency to reveal information that we never knew we needed." — iandanforth

> （纵观医学史和科学史，创造新的观察方式往往能揭示出我们从未意识到需要的信息。）

他以连续血糖监测仪 (CGM) 的个人体验和 Google 视网膜 AI 研究为例，说明"更高分辨率地观察身体"已经带来了意想不到的发现。他也承认放射科医生的批评在"临床可靠性"层面是合理的，但这不代表这种新方法没有价值。

放射科医生 jmhmd 对此的回应是：

> "It isn't really a new way of generating an image, it's the same physics we've used to generate images from sound waves for decades, and that modality comes with some pretty hard physical limitations that this demo does not directly address." — jmhmd

> （这其实不是什么新的图像生成方式——人类用声波成像已经有几十年了，这种模态一直存在一些物理极限，而这个演示并没有直接解决它们。）

### 社区对专家身份的信任讨论

一个有趣的元讨论也随之展开。当评论者 conroydave 表示"这就是我总来 HN 看专家意见的原因"时，另一位用户 b40d-48b2-979e 泼了冷水：

> "You don't know if the opinion is expert. You don't know who that person is or what credentials they even have. Blindly trusting something that sounds right is a terrible way to inform yourself." — b40d-48b2-979e

> （你根本不知道那是不是专家的意见。你不知道对方是谁、有什么资历。盲目相信听起来有道理的东西，是非常糟糕的信息获取方式。）

随后多位用户挖出了 jmhmd 的历史发帖记录——该账号已注册 14 年，贯穿整个 AI 时代之前就有大量专业的医学讨论——基本确认了其可信度。这场围绕匿名论坛信任机制的讨论本身，也折射出 LLM 时代人们对在线信息源的普遍焦虑。

## 典型观点一览

| 立场 | 用户 | 一句话 |
|------|------|--------|
| 物理原理不支持全身超声 | jmhmd | 超声无法穿透含气器官和骨骼，非"真全身" |
| 技术有前景但限制多 | haldujai | 全波反演改进了信息量，但气体和距离仍是本质问题 |
| 产品是换壳营销 | mrandish | 直接买了 Butterfly 的现成芯片，加了个水缸 |
| AI 重建不可轻信 | SubiculumCode | 深度学习重建的风险：训练分布与真实患者不匹配 |
| 新方法可能带来惊喜 | iandanforth | 历史表明新观察方式总能揭示意料之外的信息 |
| 筛查有统计学代价 | queuebert | 过度检出的干预风险与疾病风险相当，未必有利 |
| 应有服务可及性考量 | smith7018 | CT/MRI 太贵难获取，低成本筛查有独特价值 |
| 匿名论坛需要怀疑精神 | b40d-48b2-979e | 谁也不知道屏幕后的人到底有没有资质 |

## 总体情绪

讨论整体氛围是"谨慎观望中的深度怀疑"。844 条评论中，专业医学和技术背景的评论占据了主要篇幅，几乎没有"Midjourney 做医疗肯定牛"的盲目乐观。多位自称为放射科医生的用户给出了专业且具体的批评，而反驳者大多也不是唱赞歌，而是从"历史上新方法常常带来意外之喜"的角度提供另一种视角。

核心争议点在于：Midjourney 的超声波水缸方案是否解决了任何真正的医疗问题？批评者认为它既没有解决超声波固有的物理限制，也没有提出比现有手持设备更好的工程方案，只是在营销上将其包装为"科幻般的未来体检"。支持者则认为降低成本、提高可及性本身就是价值。

值得注意的是，Midjourney 在医疗影像领域缺乏可验证的临床数据和学术发表，反而优先推出"水疗体验"，这一策略选择极大地削弱了社区对其技术实力的信任。多位评论者明确表示："等看到白皮书再认真对待。"

## 引用帖子

| # | 标题 | URL |
|---|------|-----|
| 1 | Midjourney Medical (HN 讨论) | https://news.ycombinator.com/item?id=48579650 |
| 2 | Midjourney Medical 官方博客 | https://www.midjourney.com/medical/blogpost |

<div class="disclaimer">本文基于 Hacker News 讨论编译，观点不代表译者立场。引文内容可能经过编辑以适应篇幅。文中使用者名和引文均来自公开讨论，不构成对用户身份的确认。</div>
