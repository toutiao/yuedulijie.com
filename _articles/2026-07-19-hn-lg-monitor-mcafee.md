---
layout: post
title: "LG 显示器通过 Windows Update 静默安装推广软件 — HN 讨论"
date: 2026-07-19
categories: [articles]
excerpt: >-
  连接 LG 显示器后，Windows 自动下载 McAfee 推广软件，无需用户同意。
  32 次开机 31 次弹出广告。社区愤怒：这是 malware。
tagline: >-
  Gamers Nexus 实测：LG 显示器 32 次开机 31 次弹出 McAfee 广告。
---

# LG 显示器通过 Windows Update 静默安装推广软件 — HN 讨论

## 原文概要

2026 年 7 月，Gamers Nexus 发布视频揭露 LG 显示器在 Windows 上通过 Windows Update 静默安装推广软件。连接特定 LG 显示器（如 UltraGear 34GX900A-B）后，Windows Update 自动下载 LG 扩展和软件组件包，一分钟后 LG Monitor App Installer 弹出 McAfee 推广——提供 30 天试用后自动转为付费订阅。GN 在 32 次连续开机中，31 次出现 McAfee 弹窗，剩余 1 次推广了 LG 自己的显示器工具。该行为不限于新机型：三年前购买的 LG UltraFine 32UN880-B 同样受影响。用户投诉可追溯至 2024 年。该帖子登上 HN 热门榜，1116 分，561 条评论。

## 讨论焦点

### 这是 malware

社区对 LG 行为的定性几乎没有分歧。

> "Your OS silently installs malware. Doesn't get much worse than this." — thejokeisonme
> （你的操作系统在静默安装恶意软件。没有比这更糟的了。）

> "They used to call this spyware/malware. Now it's a regular practice by eng. teams and managers inside these big corp. Well played guys :) Congrats with new type of tricks" — kingleopold
> （以前这叫间谍软件/恶意软件。现在大公司工程团队和管理层把这当常规操作。干得漂亮，新花样。）

> "From FTC website: Malware is harmful software that's installed on your device without your knowledge. So I think that is what we should continue to call it." — flowerbreeze
> （FTC 定义：恶意软件是在用户不知情下安装的有害软件。所以我们应该继续这么叫。）

CN 读者可能觉得 McAfee 不够"有害"——它在 Windows 上确实提供杀毒功能。但问题核心是未经同意安装在用户机器上，且通过 Windows Update 这一"可信渠道"分发，绕过用户心理防线。

### 围堵 LG 软件

用户 delta_p_delta_x 提供了核心缓解方案：

> "Workaround: gpedit.msc → Computer Configuration > Administrative Templates > System > Device Installation → Prevent automatic download of applications associated with device metadata → Set to enabled." — delta_p_delta_x
> （组策略：阻止自动下载与设备元数据关联的应用程序。）

但 Someone1234 指出 Home 版不含 gpedit。delta_p_delta_x 补充了 Home 版的替代路径：`sysdm.cpl` → 硬件 → 设备安装设置 → 选"否"。

这条看似简单的方案引发了更深的挫败感：

> "Microsoft has also gone out of their way to make it difficult to access the [legacy] System Properties (sysdm.cpl), while not fully reimplementing all the features into the Settings app. Including this one." — Someone1234
> （微软一边让传统控制面板更难访问，一边又不把功能全部搬到新设置里。包括这个选项。）

Alienware 显示器用户 MaxL93 分享了更激烈的对抗经验——即使关闭自动下载，Alienware Command Center 仍然通过注册表以外的渠道卷土重来。他不得不添加多条设备 ID 黑名单：

> "Nothing short of this prevented 'Alienware Command Center' (AWCC.exe) from pushing itself onto my machine because of my Alienware OLED monitor." — MaxL93
> （只有这样才能阻止 AWCC 因为我的外星人 OLED 显示器而不断安装到机器上。）

### 不只是 LG——OEM 集体默契

多位用户指出 LG 并非孤例：

> "And Razer, Logitech, nvidia and everyone else who has it's driver package accepted into WU. No, you can't have a '(o) just the driver' checkbox because... honestly there are a lot of reasons and the device manufacturers are the guys who demand that in the first place." — justsomehnguy
> （Razer、罗技、Nvidia 都一样，驱动包进了 Windows Update。你不能只选"仅驱动"，因为硬件厂商要求捆绑。）

justsomehnguy 分享亲身经历：罗技 M720 鼠标的按钮设置依赖后台运行的 user space 应用，且该应用每月下载约 1GB 更新从不清理，磁盘被占满才发现。mbrndtgn 则对雷蛇的做法尤为不满：

> "Razer mice are the worst because they are just HIDs and could work without any special driver at all! ... It's just crazy to me that a lot of keyboard manufacturers have basically standardized on VIA as their firmware which can be configured via WebUSB without installing any additional driver. But my mouse somehow needs a gigantic driver suite just to configure and save some settings?" — mbrndtgn
> （雷蛇鼠标最离谱：它只是 HID 设备，根本不需要专用驱动。键盘厂商都标准化到 VIA 固件了，WebUSB 就能配置，我的鼠标却要装一个巨型驱动套件才能改设置？）

LG 的行为只是把 OEM 多年的潜规则推到了台前。

### Windows 本身是不是 malware？

有评论将矛头从 LG 转向微软的整个生态：

> "Your OS is malware, if it's Windows." — inigyou
> （如果用的是 Windows，那你的操作系统本身就是恶意软件。）

> "Windows today would have been considered malware in the 90s. This frog hasn't been boiled." — globular-toast
> （今天的 Windows 放 90 年代会被当成恶意软件。温水煮青蛙罢了。）

> "If Windows continually supports third parties installing malware (without your consent and through Windows update, not some third party updater), at what point can the OS itself be considered malware?" — garciansmith
> （如果 Windows 持续支持第三方通过 Windows Update（而非第三方更新器）静默安装恶意软件，到什么程度操作系统本身可以被视为恶意软件？）

但也有冷静的声音：

> "Windows may not be the best OS for you but it definitely isn't malware." — timpera
> （Windows 可能不是最适合你的系统，但它绝对不是恶意软件。）

### Linux 替代方案与现实

一条"[Laughs in Linux/BSD]"的评论引发了平台之争。

> "I had a win10 machine were HP kept installing some 'analytics' service. This happened even on a clean windows install so I guess they used the same delivery mechanism LG is using here. After having read the HP ToS, I decided to wipe the disk and install Linux." — throwa356262
> （我有台 HP 的 Win10 机器，HP 不停安装"分析"服务，甚至全新安装也如此。读了 HP 用户协议后我直接装 Linux 了。）

但 delta_p_delta_x 不认为 Linux 免疫：

> "Arch Linux's AUR was recently hit by an actual malware supply-chain attack, which I would claim is arguably worse than adware. ... just because something is free and open-source or based on Linux doesn't make it a universal panacea for malware or supply-chain pwnage." — delta_p_delta_x
> （Arch Linux 的 AUR 最近遭受了实际的恶意软件供应链攻击，这比广告软件更严重。开源和 Linux 不是万能的。）

delusional 则预见了结构性风险：

> "The saving grace of linux currently is that volunteers package most of the software, and they don't generally package malware. There is no structural guarantee there, and if we invite corporate interests to package at some point (like flatpack and snap wants to) this is 100% going to happen eventually." — delusional
> （Linux 目前的救命稻草是志愿者打包软件，他们一般不打包恶意软件。但这没有结构性保障。如果企业利益进入打包环节——就像 flatpak 和 snap 想做的——这 100% 会发生。）

### 用户的无奈

技术门槛让修复方案对普通用户形同虚设：

> "This is getting technical enough that you might as well install Linux if you figure out how to do this. In other words, we all know that regular consumers will never find this and they'll never understand that their LG software is spyware in the first place." — Grombobulous
> （这已经复杂到你要是搞懂了还不如直接装 Linux。换句话说，普通消费者永远找不到这个设置，也永远不会意识到 LG 软件是间谍软件。）

## 典型观点一览

| 立场 | 用户 | 一句话 |
|------|------|--------|
| LG 行为就是 malware | flowerbreeze | 符合 FTC 定义：未经同意安装的有害软件。 |
| Windows 生态是根因 | inigyou | Windows 为第三方静默安装提供了渠道。 |
| 组策略能解决 | delta_p_delta_x | gpedit/sysdm.cpl 关闭自动下载可解决。 |
| 微软设置越来越难用 | Someone1234 | 传统面板藏得深，新设置又没补全功能。 |
| 不止 LG，全行业潜规则 | justsomehnguy | Razer、罗技、Nvidia 都通过 WU 推送捆绑软件。 |
| Linux 并非净土 | delta_p_delta_x | AUR 刚经历过供应链攻击，开源不是万灵药。 |
| 普通用户无解 | Grombobulous | 手段太技术，普通消费者永远不知情。 |
| Windows 变了 | globular-toast | 今天的 Windows 放 90 年代就是 malware。 |

## 总体情绪

讨论情绪一面倒的愤怒——不是震惊，是"终于被抓到了"的厌倦。社区对 LG 的愤怒很快延伸到对 Windows 生态的系统性质疑：当 OEM 可以通过微软的官方更新渠道静默推送广告时，用户对自己电脑的控制权还剩多少？技术用户尚有 gpedit 和注册表可对抗，但对数亿普通消费者来说，这台插上显示器就开始装广告的电脑，已经不算他们的电脑了。

讽刺的是，最有效的"修复方案"在第一条回复里就有了：用 Linux。

## 引用帖子

| # | 标题 | URL |
|---|------|-----|
| 1 | LG monitors silently install software through Windows Update without consent | [HN](https://news.ycombinator.com/item?id=48956688) |

## 免责声明

<div class="disclaimer">
本摘要基于 2026 年 7 月 18 日的 Hacker News 讨论生成，内容仅代表评论者个人观点，不代表本网站立场。讨论内容可能包含不准确信息，请以 LG 官方声明为准。
<br><br><em>本摘要由 AI 模型辅助生成：deepseek/deepseek-v4-flash</em>
</div>
