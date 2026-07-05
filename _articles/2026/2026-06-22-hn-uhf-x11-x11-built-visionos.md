---
layout: post
title: "UHF X11: X11 Built for VisionOS and Apple Vision Pro — HN 讨论摘要"
date: 2026-06-22
categories: [articles]
excerpt: "有人在 Apple Vision Pro 上跑起了 X11。HN 讨论从技术实现延伸到 Vision Pro 的实用性争议和开放替代方案的期待。"
tagline: "在 3500 美元的头显里跑三十年前的 Linux 窗口系统——极客的浪漫。"
---

## 原文概要

Hacker News 上的一篇帖子介绍了 UHF X11 项目，这是一个专为 Apple Vision Pro 和 VisionOS 构建的 X11 实现。该项目旨在将传统的 X11 应用程序引入 Apple 的空间计算平台，允许用户在 Vision Pro 的沉浸式环境中运行经典的 Linux/Unix 桌面应用。

讨论围绕这一技术实现展开，但很快扩展到对 Apple Vision Pro 本身更广泛的评估。评论者探讨了 Vision Pro 的实用性、舒适度、高昂价格以及其在当前市场中的定位。许多用户将其与历史上的苹果产品（如 Lisa 或 Newton）进行比较，并讨论了其作为新产品类别第一代的潜力。

此外，讨论还涉及了对更开放、更具可定制性的替代 VR/AR 头显的兴趣，例如即将推出的 Steam Frame。关于 X11 协议本身的生命力以及欧盟应用商店法规对独立开发者的影响也成为讨论的次要焦点。

## 讨论焦点

### 焦点一：X11 在 Vision Pro 上的技术实现与功能展望

用户对在 Vision Pro 上运行 X11 表现出浓厚兴趣，并探讨了其技术潜力。特别是关于 3D 渲染和用户交互的细节引发了讨论。

> "3D in 2D in 3D. OpenGL clients can use GLX rendering over X11. Compatibility varies, as it did in the 2000s.Made me chuckle. I think at one point in my life I actually knew which exact GL versions and features were working on which servers. Also it's pretty cool." — fp64
> （“3D 中的 2D 再在 3D 中。OpenGL 客户端可以通过 X11 使用 GLX 渲染。兼容性各异，就像 2000 年代那样。这让我发笑。我想我人生中曾一度确切知道哪些 GL 版本和功能在哪些服务器上运行。这也很酷。”）

评论者对在 Vision Pro 上实现 OpenGL 渲染的可能性感到兴奋，但也回忆起过去 X11/OpenGL 兼容性的复杂性。关于经典 X11 应用 `xeyes` 是否能在 Vision Pro 上追踪用户目光也引发了好奇，尽管 Vision Pro 出于隐私原因不直接提供凝视位置，但用户指出可以通过头部位置追踪实现类似效果。

### 焦点二：Apple Vision Pro 的实用性、舒适度与价格争议

Vision Pro 的高昂价格、佩戴舒适度以及实际用途是讨论中最集中的负面反馈点。

> "im an apple enjoyer with disposable income, i bought because my brother worked on the foveated rendering, but goddamn it’s so heavy that if i use for >2hrs i’ll have neck pain for >2 days. it’s neat and fantastic for chores and cooking if i wear for 30min at a time but super impractical for me to actually use if im not speed running exactly one task" — jitl
> （“我是一个有可支配收入的苹果爱好者，我购买它是因为我兄弟参与了凹点渲染的工作，但该死的它太重了，如果我使用超过 2 小时，我的脖子会疼超过 2 天。它很整洁，非常适合做家务和做饭，如果我每次戴 30 分钟的话，但如果我不是为了快速完成一项任务，它对我来说就非常不实用。”）

许多用户抱怨 Vision Pro 的重量导致长时间佩戴不适，甚至引发颈部疼痛。高昂的 3500 美元售价被认为是其普及的最大障碍，一些人认为它更像是一个“美化过的开发者套件”，而非成熟的消费产品。此外，也有用户提到佩戴 VR/AR 设备可能引起的恶心和晕动症。

### 焦点三：Apple Vision Pro 的市场定位与未来前景

关于 Vision Pro 在 AR/VR 市场中的地位及其未来发展路径，用户们展开了激烈的辩论，将其与苹果公司历史上的其他产品进行比较。

> "AR simply has no market. Apple could sell Vision Pro for $10,000 apiece, if there was natural demand for high-quality AR hardware. But the product isn't competing for Hololens' commercial contracts, and it forfeit the consumer VR segment on release. The remainder of consumer-forward AR experiences are even less lucrative than Zuckerberg's commoditized Quests. Apple wants to build a nonexistent market with an inaccessible product." — bigyabai
> （“AR 根本没有市场。如果对高质量 AR 硬件有自然需求，苹果可以以每台 10,000 美元的价格出售 Vision Pro。但该产品并未与 Hololens 的商业合同竞争，并且在发布时就放弃了消费者 VR 市场。其余面向消费者的 AR 体验甚至不如扎克伯格的商品化 Quest 有利可图。苹果希望用一款难以接近的产品来建立一个不存在的市场。”）

有观点认为，AR 市场尚未成熟，Vision Pro 试图以高价产品创造一个不存在的需求。另一些人则将其比作早期的 Apple Lisa，认为它是未来更成功产品（如 Mac）的先驱，需要时间迭代。然而，也有人反驳说，Vision Pro 的迭代速度不如 Lisa 到 Mac，更可能像 Newton 一样，最终会被截然不同的产品取代。

### 焦点四：对开放性替代方案的期待（Steam Frame 等）

与 Vision Pro 的封闭生态系统形成对比，用户对更开放、更具可定制性的 VR/AR 头显表现出浓厚兴趣，尤其是 Valve 的 Steam Frame。

> "I've been interested in VR for a while and would be interested to try out a headset I could actually work in, but personally my interest in the Apple Vision Pro basically disappeared when the Steam Frame was announced.It's lower resolution, but I think it would probably be sufficient for light work, and I'm not really interested in the pass-through camera features of the AVP. The real differentiator though was that the steam frame will also work with my existing computer for gaming, and I think it's likely to be much more hackable than the Apple Vision." — solid_fuel
> （“我对 VR 感兴趣已久，也很想尝试一款我能真正用于工作的头显，但当 Steam Frame 发布时，我对 Apple Vision Pro 的兴趣基本上就消失了。它的分辨率较低，但我认为对于轻度工作来说可能足够了，而且我不太关心 AVP 的透视摄像头功能。真正的区别在于 Steam Frame 也能与我现有的电脑配合进行游戏，而且我认为它可能比 Apple Vision 更具可玩性。”）

许多用户表示，Steam Frame 因其运行 Arch Linux、与现有电脑兼容以及 Valve 承诺的“你的电脑，你可以随心所欲”的开放性而更具吸引力。这种对“可玩性”和自由度的追求，与对苹果封闭生态的担忧形成了鲜明对比。

## 典型观点一览

| 立场 | 用户 | 一句话 |
|------|------|--------|
| AVP太重/不适 | jitl | 用久了脖子疼，不适合长时间使用。 |
| AVP太贵/无市场 | bigyabai | 3500美元太贵，AR市场不存在，Apple在用高价产品试图创造不存在的需求。 |
| 期待Steam Frame | solid_fuel | Steam Frame更开放、更便宜，且能与现有电脑配合，比AVP更吸引人。 |
| X11生命力顽强 | rezmason | X11可能会比VisionOS活得更久。 |
| AVP是未来迭代起点 | mulderc | AVP是苹果新产品