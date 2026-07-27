---
layout: post
title: "Android 或限制设备端 ADB，Shizuku 生态面临终结 — HN 讨论摘要"
date: 2026-07-27
categories: [articles]
excerpt: >-
  Google ADB 维护者提议将 ADBD 绑定到 wlan0，切断 loopback 连接。Shizuku、libadb-android 等开源工具生态面临灭绝。976 点 HN 讨论：这是安全加固还是控制扩张？
tagline: >-
  Google 说这是安全漏洞修复，社区说这是 Shizuku 的死刑判决。
---

来源：HN 热门榜 (/best)。[原帖链接](https://news.ycombinator.com/item?id=49045159)。

## 原文概要

2026 年 7 月 20 日，Shizuku 生态开发者 Kitsumed 发布博文，曝光 Google IssueTracker 上一则 feature request（[526109803](https://issuetracker.google.com/issues/526109803)）：ADB 核心维护者（Google 员工）提议限制 On-Device ADB 连接，将 ADBD（ADB 服务器守护进程）绑定到 `wlan0` 接口，从而切断 loopback（127.0.0.1）上的本地 ADB 连接。

起因是 [CVE-2026-0073](https://nvd.nist.gov/vuln/detail/CVE-2026-0073) 漏洞——Wireless ADB 认证流程可被完全绕过。维护者认为 loopback ADB 是恶意应用提权的入口："Connection to localhost has also been the source of exploit where app are using that socket to adbd to escalate their privileges."

Kitsumed 本人是 ShizuCallRecorder（基于 Shizuku 的通话录音应用）的开发者，也为残障用户提供服务。他指出，On-Device ADB 的合法用途远超 Google 的想象：在 Termux 中本地调试、通过 Shizuku 实现免 Root 权限管理、用 libadb-android 构建开发者工具。**坏蛋无法自行发起 ADB 连接**——它需要用户手动开启 USB 调试、启用 Wireless ADB、并配对或授权。任何攻击路径都已有人为操作介入。

博文结尾讽刺道："我之前开玩笑说'我猜他们终有一天会以安全之名禁用 loopback ADB'……看来我几乎说对了。"

## 讨论焦点

### 安全剧场还是真实威胁？

> "ADB connecting a device to itself is just bad design and a hack. Either the capabilities should just be granted directly to the app or it should all be blocked." — charcircuit
> （设备自连 ADB 本身就是糟糕的设计和 hack。要么把能力直接给应用，要么全堵死。）

> "I am generally in favor of security improvements, but I do not really see much of a benefit here. This attack vector requires both that the user enabled developer settings *and* that they have remote adb enabled. So, this does not seem to be a realistic attack vector for 99.9% of the users and most of the other 0.1% probably know what they are doing." — microtonal
> （我支持安全改进，但这个攻击面需要用户同时开启开发者选项 + 远程 ADB。对 99.9% 的用户不是现实威胁，而剩下的 0.1% 基本知道自己在做什么。）

分歧的核心在于：一个需要用户手动开启调试模式、手动授权配对、手动确认连接的"漏洞"，到底算不算漏洞？评论中反复出现的逻辑是："人类可以手动授权恶意应用成为设备管理员或授予无障碍权限——但我们不会因此砍掉这些功能。"

### 控制权而非安全性

> "They don't care about security; only about control. There are hundreds of millions of outdated Android devices that all Google attestation systems consider secure even though they all running Linux kernel that was never ever updated and can be rooted by anything." — SXX
> （他们不在乎安全，只在乎控制。数以亿计从未更新内核的陈旧 Android 设备被 Google 认证系统标记为"安全"，但可以被任意方式 Root。）

> "Security, but not for you, is no security." — chii
> （安全，但不是为你，就不是安全。）

多位评论者指出 Google 的 Android 安全模型将应用与用户视为"平等主体"——在这个模型下，用户无权查看或干预应用行为，因为应用和用户在系统中有同等 agency。surajrmal 辩护称"这是合法的安全模型"，但遭到激烈反驳：消费者购买了设备，理应有最终控制权。

> "Toxic max security. Not everyone has the same threat model as you, $BIGTECHCORP." — Arbortheus
> （有毒的极致安全。不是每个人都有和你一样的威胁模型，大公司。）

### Android 不再有趣了

> "In 2008 Sergey Brin and Larry Page saw the limo waiting, and instead chose to rollerblade to the Android unveiling. Sergey Brin, during the presentation, threw his G1 in the air to show off how his homemade application leveraged the accelerometer to see how high he'd thrown it. That use-case was never designed for when the sensor was added, and is every bit as hacky and fun as adding call recording with a loopback address. And that's the first problem: Android is no longer fun." — xethos
> （2008 年 Sergey Brin 和 Larry Page 看到等候的豪华轿车，选择轮滑去 Android 发布会。Brin 现场把 G1 手机抛到空中，展示自制应用如何用加速度计测量抛投高度。这个用例从来不是传感器的设计目标，和用 loopback 地址加通话录音一样 hacky 又有趣。这是第一个问题：Android 不再有趣了。）

> "I'm afraid in a few years iOS will actually (not as a joke) be the more open and customizable option." — kasabali
> （恐怕几年后 iOS 真的会成为更开放、更可定制的那一个——不是玩笑。）

### 妥协方案：工厂重置级开关

> "No one's requested the config switch from A to B *with* a restriction that's acceptable to those seeking B. … Here's a simple and easy to implement example compromise that could be offered today: 'Changing between A and B requires a device reset.'" — altairprime
> （没有人提出过一个双方都能接受的 A/B 配置开关。这里有一个今天就能实施的简单妥协："切换 A/B 需要重置设备。"）

这个提议认为，要求物理接触+重置设备才能开启 loopback ADB，既能阻止自动化攻击（重置会清除恶意软件、触发所有账号的"新设备登录"告警），又为真正需要的人保留入口。

### 代理软件的黑暗面

> "Isn't this because of the kimwolf (and now 6+ other botnets) that are taking advantage of people running residential proxyware unknowingly on the device which permits outbound connections to 127.0.0.1 on tcp/5555 to auth in and exec wgets or drops a loader that grabs the ddos malware APKs and install it?" — pigggg
> （这不是因为 kimwolf 和另外 6 个以上的僵尸网络吗？它们利用用户不知情下运行的住宅代理软件，通过 tcp/5555 连接 127.0.0.1，认证后执行 wget 或投放恶意 APK。）

londons_explore 指出这种代理业务直接向用户推销"手机睡觉时赚钱"，用户需要手动允许 ADB 连接来换取虚拟金币。这是 Google 方面最有说服力的真实威胁案例，但也正如 Kitsumed 在更新中指出的：Google 完全可以默认禁用 loopback ADB，然后允许开发者通过 USB ADB 手动开启，而非彻底移除该功能。

## 典型观点一览

| 立场 | 用户 | 一句话 |
|------|------|--------|
| 支持限制 | pigggg | Kimwolf 等僵尸网络已利用 loopback ADB 展开真实攻击。 |
| 反对限制 | SXX | 安全只是借口，数亿陈旧设备不受更新，却在限制用户可控的本地功能。 |
| 中间路线 | altairprime | 用"重置设备"作为切换代价，既阻止自动化攻击又保留入口。 |
| 放弃 Android | fsflover | GNU/Linux 手机已存在——来自我的 Librem 5。 |
| 技术中立 | surajrmal | Android 的安全模型是多方的，应用和用户拥有同等 agency，不喜欢可以换系统。 |
| 感性反对 | xethos | 曾几何时 Android 是 Geek 的游乐场，Brin 在发布会抛手机，现在只剩锁。 |

## 总体情绪

讨论整体呈现出一种被背叛的疲惫感。几乎没人相信 Google 的"安全"说辞——评论区弥漫着对 Android 平台十年间从开放走向封闭的失望。支持限制的技术理由（CVE-2026-0073、僵尸网络）真实存在，但绝大多数评论者认为合理的解决方案是"默认关闭 + 可选项"，而非彻底移除。值得注意的是，几乎没有人为 Google 辩护：连倾向于理解 Android 安全模型的 surajrmal，也承认用户可以选择其他 OS（但评论区立刻指出：选择其他 OS 意味着失去银行应用、失去认证、手机变砖）。情绪最深处是一种"无处可逃"的无力感——iOS 更封闭，AOSP 分支不支持主流硬件，欧美的监管也未必偏向用户。

## 引用帖子

| # | 标题 | URL |
|---|------|-----|
| 1 | Android May Soon Restrict On-Device ADB (原文) | https://news.ycombinator.com/item?id=49045159 |

<div class="disclaimer">
  本文是对 Hacker News 用户讨论的编译与提炼，原文链接：<a href="https://news.ycombinator.com/item?id=49045159">https://news.ycombinator.com/item?id=49045159</a>。文中所有观点均来自 HN 评论者，不代表本人立场。<br><br><em>本摘要由 AI 模型辅助生成：deepseek/deepseek-v4-flash</em>
</div>
