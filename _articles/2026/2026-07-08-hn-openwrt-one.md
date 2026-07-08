---
layout: post
title: "OpenWrt One — 开源路由器硬件登场"
date: 2026-07-08
categories: [articles]
excerpt: >-
  OpenWrt 推出了自己的官方硬件 One，定价 $84-106。HN 读者在评估后表示：只有 2 个网口（1+2.5GbE），没有 6GHz WiFi，它到底是个路由器还是个 AP？
tagline: >-
  OpenWrt 自己的路由器：两个网口，没有 6GHz，开发者该买吗？
---

[OpenWrt One](https://openwrt.org/toh/openwrt/one) 是 OpenWrt 项目官方推出的开源硬件路由器，由 Banana Pi 生产制造。它搭载 MediaTek Filogic 芯片，配备 1 个 1GbE + 1 个 2.5GbE 网口，双频 WiFi（2.4+5GHz，无 6GHz），1GB RAM，定价 $106（带外壳天线）或 $84（裸板）。项目在 HN 首页（/news）获得 798 票，但评论区很快聚焦到一个核心问题上：这台设备的定位到底是什么？

## 两个网口引发的身份危机

> "Just two Ethernet ports (1+2.5GbE), and it's dual-band (no 6GHz)… I'm not sure who's the target audience or what's the use case." — drdaeman
> （只有两个网口——一个千兆一个 2.5GbE——而且是双频 WiFi没有 6GHz……我不确定目标用户是谁，也不确定它的使用场景是什么。）

daringrain32781 表示理解："这是面向开发者的，不是给普通消费者买的。OpenWrt 有更好的硬件选择。"但 petee 立即追问："如果面向开发者，到底要开发什么？尤其这款用的芯片在其他设备上几乎找不到。"

> "It does raise the question that if it is for developers, what exactly is being developed? Especially if its not representative of hardware that is available or desired." — petee
> （这就产生了一个问题：如果是给开发者的，那开发者要开发什么？尤其当它用的硬件在市场主流产品中都不常见。）

aidenn0 提供了一个务实的方案：加一个不到 $100 的 5 口 2.5GbE 交换机就能扩展到 5 个端口。"现在很少有设备会直接连到路由器 LAN 口了。"PcChip 立刻反驳："游戏台式机不应该都是有线连接吗？"aidenn0 回应说他父母和岳父母的台式机都不插网线——"连猫都不在同一个房间。"

ssl-3 从另一个角度辩护："用 OpenWrt，网络接口你想怎么配就怎么配——这就是 OpenWrt 的好处之一。"但 petee 不买账："那你的 WAN 是千兆、LAN 是 2.5GbE……这不如直接叫它 AP 好了，很多争议就没了。"

ssl-3 最后承认接口配置确实奇怪："最合理的用法是接一个 2.5GbE 管理型 PoE 交换机，用 VLAN 把路由器和 AP 功能合在一根线上——但即使这样 WAN 流量也会和本地 WLAN 流量争带宽。太极端了，我不会指望任何人真这么用。"

## WRT54G 情怀和开源路由器的黄金年代

> "What amuses me about the 'Wrt' name is that it was originally alternate firmware for the Linksys WRT54G router from 25 years ago. The name has stuck for whatever reason." — baggachipz
> （"Wrt"这个名字有趣的地方在于：它最初是 25 年前 Linksys WRT54G 路由器的第三方固件。不管出于什么原因，这个名字一直用到了今天。）

这条评论引爆了一波怀旧潮。boobsbr 说家里还留着 WRT54GL，EvanAnderson 分享了一个经典故事——2008 年用两台 WRT54G 在工地蹭隔壁餐厅的免费 WiFi。"（我们在那家餐厅吃过饭，所以我们当然是顾客（Customer），对吧？）"

kalleboo 回忆 Linksys 甚至专门推出了 WRT54GL（L 代表 Linux）这个 SKU 来支持第三方固件。"一家主流硬件公司专门为第三方固件出独立产品线——放在今天这个订阅和监控才是利润来源的市场，简直不可思议。"

jandrese 则不解："为什么 Linksys 不从 WRT54GL 的成功中学到教训？每个厂商都坚持自研固件——又慢又不稳定，功能一半都实现不好。"

ssl-3 分析说厂商自研固件是"非我发明"综合征和二进制闭源 blob 双重作用的结果。而它们不愿继续做廉价、可破解的硬件主要是因为售后成本——"有人折腾砖了会骗保修 RMA。那些人真是糟糕透了。"

vitally3643 补充了一个更黑暗的角度："别忘了还有多个国家的政府在排队'客气地要求'植入固件后门。"

## 路由器美学：为什么都长成了赛博蜘蛛

> "Why do they always have to look like some unholy blend of a cybernetic spider and a Knight Rider?" — vsviridov
> （为什么它们总是看起来像赛博蜘蛛和霹雳游侠的不洁混合体？）

vsviridov 的吐槽获得了大量共鸣。all2 说 WRT54 是他最爱的工业设计——"小巧的外壳，蓝灰配色，两根天线。"

ButlerianJihad 给出了一个社会学解释："因为游戏玩家和爸爸们——做家庭路由器采购决策的主力——喜欢 F-117 和隐形轰炸机。"

Karliss 写了一篇长文深入分析。WiFi 5-7 需要在 2.4/5/6GHz 三个频段工作，加上波束成形和 MIMO，天线数量暴增。但他也指出市场上有很多低调的选择——Ubiquiti、小米、TP-Link Deco 系列、华硕 ZenWiFi。"如果你在意外观，就不要买长得像蜘蛛的。"

mike_d 说得直白："现代 WiFi 路由器至少需要 6 根天线，9 根更好。这种需求天然导向蜘蛛造型或垃圾桶造型。你还有其他布局方案吗？"

## 1GB 内存够不够？

> "$106usd or $84usd without a case and antennas. That's a solid price. Wish it had more than 1gb ram - goddamn datacenters." — kennywinker
> （$106 或不带外壳天线 $84。价格不错。要是内存超过 1GB 就好了——该死的数据中心。）

ssl-3 轻松回应："我那些什么都能干的 OpenWrt 路由器，内存占用从来没超过 100MB。1GB 对于这个用途来说已经很充裕了。"

kennywinker 解释说他想在路由器上跑 Blocky（DNS 过滤）外加文件服务器、PairDrop、IRC、Tailscale。"随便一个 Node.js 应用就能把剩余内存吃光。"

ssl-3 坚持自己的理念："400MB 仍然可以做很多有用的事。但我倾向于让路由器专注路由工作，不想把单点故障设备搞得太复杂——万一我把路由器折腾坏了，我要能尽快恢复上线，不用操心一堆非路由服务。"

undersuit 贴出了自己在 256MB 树莓派上跑 Pi-hole 的实际内存数据——只用了 54MB。"OpenWrt 比 DietPi 还要紧凑，1GB 绰绰有余。"

## 未来：OpenWrt Two 和 WiFi 7

> "They are working on an OpenWRT Two at the moment which will be Wifi 7." — PaulKeeble
> （他们正在开发 OpenWrt Two，会支持 WiFi 7。）

PaulKeeble 透露了一些令人期待的消息。他也提到基于同款 Filogic 芯片的其他设备已经配备了双 2.5GbE 口，华硕 BT8 等设备已经能跑 OpenWrt 并支持 WiFi 7。"它的路由性能实测大约 16Gbps，跑我家的 1.2Gbps 宽带毫无压力。"

WithinReason 引用了 OpenWrt Two 的规划页面，指出它将由 GL.iNet 制造，但预期 2025 年底上市的时间已经跳票。da768 贴出 Reddit 链接说"最新的猜测是他们已经没有制造商了。"

不过对普通用户来说，GL.iNet 已经有很多预装 OpenWrt 的产品可选。BikiniPrince 说他的 GL.iNet 设备表现很好，随时可以刷成官方 OpenWrt。vsviridov 则抱怨 GL.iNet 路由器的外观设计："为什么就不能出个朴素低调的工业风？"

## 典型观点一览

| 立场 | 用户 | 一句话 |
|------|------|--------|
| 定位困惑 | drdaeman | 只有 2 个网口、没有 6GHz——这个硬件的目标用户到底是谁？ |
| 开发者说 | daringrain32781 | 这是给开发者的开发板，不是消费者路由器 |
| 交换机方案 | aidenn0 | 加个不到 $100 的 2.5GbE 交换机就能解决问题 |
| WRT54G 怀旧 | baggachipz | OpenWrt 的名字来自 25 年前的 WRT54G，这个传统值得尊重 |
| 厂商 cynic | ssl-3 | 厂商不做可破解硬件是因为售后成本——有人折腾砖了会骗保修 |
| 内存够用 | ssl-3 | 1GB 对于路由器绰绰有余，不要在上面堆太多服务 |
| 内存不够 | kennywinker | 跑个 DNS 过滤再加一个 Node.js 应用就爆了 |
| 设计批判 | vsviridov | 路由器为什么都长得像赛博蜘蛛？ |
| 设计辩护 | Karliss | 天线数量决定了外形，有不丑的型号可以选 |
| 未来期待 | PaulKeeble | OpenWrt Two 将支持 WiFi 7，现在用华硕 BT8 也能跑 |

## 总体情绪

HN 对 OpenWrt One 的态度是"敬而远之的欣赏"。一方面，社区为 OpenWrt 终于有了官方硬件而高兴——798 票证明了这一点。另一方面，评论者几乎一致认为这台设备不适合普通消费者：两个网口、没有 6GHz、针对开发者的定位，让它处于一个尴尬的中间地带。

但这场讨论的真正价值不在产品本身，而在它所引发的那些更大话题：为什么消费级路由器市场被 buggy 的厂商固件主导？为什么没有任何公司接替 Linksys WRT54GL 的位置？WiFi 路由器为什么一定要长得像星际迷航的道具？

OpenWrt Two 不知道什么时候才能出来。但至少 One 已经让 798 个人停下来想了想，一个真正开放的路由器生态应该是什么样子。

## 引用帖子

| # | 标题 | URL |
|---|------|-----|
| 1 | OpenWrt One – Open Hardware Router | https://news.ycombinator.com/item?id=48808482 |
| 2 | Banana Pi BPI-R4 Pro | https://openelab.io/a/s/products/banana-pi-bpi-r4-pro-1 |
| 3 | Turris Omnia NG (双 10G SFP+) | https://www.turris.com/en/products/omnia-NG-wired/ |
| 4 | GL.iNet BE9300 (WiFi 7, 5x2.5G) | http://www.gl-inet.com/en-gb/products/gl-be9300 |

<div class="disclaimer">
本文基于 HN 讨论撰写，不代表本网站立场。内容可能存在翻译和理解偏差，引用原文仅供参考。
<br><br><em>本摘要由 AI 模型辅助生成：deepseek/deepseek-v4-flash</em>
</div>
