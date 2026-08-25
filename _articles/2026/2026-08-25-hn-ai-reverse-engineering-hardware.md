---
layout: post
title: >-
  用 AI 逆向工程真正拥有你的硬件 — HN 讨论摘要
date: 2026-08-25
categories: [articles]
excerpt: >-
  黑客用 Claude Opus 5 在两周内把桌上五台外设的固件全部逆向，一条 HTTP POST 就能关掉补光灯的签名校验；另一人花 266 美元让四个模型 root 了自己的亚马逊平板。评论区吵的不是技术，而是"你拥有的，究竟是不是你的"。
tagline: >-
  你买来的摄像头，录制指示灯说关就关。
---

## 原文概要

一个周末项目在 HN 上刷了 1368 分：开发者 schlarp 在过去两周里，让 Claude Opus 5 把自己伸手可及的 5 台外设全部逆向了一遍，总耗时 13 小时"churn"、98 条提示词。他把每台设备的固件丢进自己的 `re-shell` 逆向环境，目标统一：摸清固件更新协议、找出隐藏功能、判断安全属性。结论是惊人的——几乎每台设备都形同虚设。

结果清单很具体：Insta360 Link 摄像头跑着 Ambarella 的 ThreadX RTOS，内部还带面部追踪的小型视觉模型，但固件只有 MD5 校验，一个 USB 扩展命令就能让设备"完全由你掌控"——他让 Claude 打了个补丁，录制时本该常亮的绿色指示灯从此不再亮；ASUS ROG Swift PG42UQ 显示器为了烦人的"像素清洗"弹窗而逆向，发现 A/B 双分区加简单校验码等于没防护；Shure MV7 麦克风的固件藏在 Windows 软件 MOTIV Mix 里，装进 Wine 就能提取，其 USB HID 协议暴露了一个 48 条命令的明文 shell，还能从网页通过 WebHID 直接调用；Elgato Key Light Mini 是唯一带签名固件的（Ed25519），但签名只在更新瞬间生效——一条 `ATSE=0200ED94,0E001009` 的 HTTP POST 就能把签名校验变成空操作。

文章最后话锋一转。作为安全从业者，schlarp 认为这套能力把"固件植入"从国家级行为变成了任何人两小时能干的事：WebUSB、WebHID、WebBluetooth 意味着一次疏忽的授权弹窗就可能让设备永久后门，他还顺手拿下了商用 Dell 显示器的 root shell 和 Eaton UPS 的 RCE。"AI 驱动的自动逆向蠕虫"在他看来只差一个攻击者愿意动手。他原话：就算这东西已经存在，我也不会惊讶。

同一天，HN 上另一个帖子（686 分）把同样的主题推到了普通消费者身上。作者 ericpardee 的亚马逊 Fire HD 平板（eBay 上 114.26 美元）反复被系统软件强制关机，而 root 又无公开方案。他花 266.15 美元先后请了四个模型：Kimi K3 在 30 小时内找到未被修补的 CVE-2022-38181（Arm Mali 内核驱动的 use-after-free，Fire OS 7.3.2.6 未打补丁），GLM-5.2 纠正了"CPU 与 GPU 无缓存一致性"的错误判断，GLM-5.3 在一天内搞定——把 SELinux 关成 permissive，卸掉 100 个亚马逊软件包，包括那些"受保护"的关机权限。"You own the device." 这是它的收官留言。

## 讨论焦点

### 开源梦的继承者，还是把热爱外包给了大厂

LLM 让逆向门槛崩塌这件事，不少人直接把它捧成"开源运动的梦寐以求时刻"：

> "It's amazing to see LLMs give us software and hardware freedoms that the open source movement has only ever dreamed about." — compiler-devel

> （LLM 给了我们开源运动只敢梦一梦的软件与硬件自由。）

马上有人泼冷水，措辞辛辣：

> "Did the open source movement dream of outsourcing what they loved to do themselves for free, as in both beer and freedom, to products which are trained on the corpus of their own knowledge without any consent and sold by behemoth corporations on a subscription basis?" — wartywhoa23

> （开源运动梦到过这种事吗——把自己免费（免费的啤酒加免费的自由）热爱做的事，外包给那些未经许可用他们的知识语料训练出来、由巨头公司按订阅制出售的产品？）

ks2048 的提议更务实：与其每个人对同一台设备烧 4 小时，不如像开源那样共享成果——"全世界的代码，服务于所有人"。但反对者也有理：过去这类逆向要示波器、逻辑分析仪、Ghidra 和几周时间，2019 年还是这样的活，2026 年变成"13 小时 churn"——这正是量变。

### 一次授权，设备永久变成别人的

WebUSB/WebHID/WebBluetooth 被 teddyh 单拎出来当作全文最关键的一句：

> "And the existence of WebUSB, WebHID, and WebBluetooth mean that for some devices, depending on the specifics of which classes are used, a moment of user indiscretion in accepting a permissions prompt could permanently backdoor one of their attached devices." — teddyh

> （WebUSB、WebHID 和 WebBluetooth 意味着，对某些设备而言，用户一时手滑接受了授权弹窗，就可能让某个外设被永久植入后门。）

_kb 把理由讲透了：USB-C 一统天下之后，电源不再只供电、显示器不再只传画面，任何设备都能在运行时改变自己在干什么。

> "In a world of USB-C everything we no longer have power supplies that are physically bound to power delivery, HDMI or DP display connections that have constrained data channels, or analogue mics, headphones, and speakers. Any device can dynamically change what it senses, does, or emits." — _kb

> （在 USB-C 的世界里，不再有只负责供电的电源、只走视频信号的显示接口、只传模拟声音的麦克风耳机喇叭。任何设备都能在运行时动态改变自己感知什么、做什么、发什么。）

hypfer 则把话往反方向收：厂商锁固件不全是恶，也挡坏蛋——"每台我们能拥有的 IoT 设备，同样也会被非技术人群遭遇滥用"。他的结论更冷：这局不是所有人都赢，赢的其实是少数人。

### 指示灯之争：Apple 能做，为什么大家不做

webcam 指示灯被软件关掉这件事，炸出一个经典安全话题。NavinF 先拿 Apple 当标尺：

> "Oof. Apple claims this is not possible for macbook cameras because the LED can't be controlled from software. Wish more manufacturers would do the same." — NavinF

> （唉。Apple 声称 MacBook 摄像头做不到这一点，因为指示灯无法用软件控制。真希望更多厂商能这么做。）

ryandrake 拆穿了它的技术含量：

> "It's not even that clever, really. The camera power rail must be physically close to the camera, so it's trivial to hang an LED off it. A device manufacturer has to go out of their way to make it so the LED and camera function are independent, and I'm sure many do, for the worst reasons you can possibly think of." — ryandrake

> （说穿了它一点都不高明。摄像头电源轨就在摄像头旁边，挂个 LED 上去是举手之劳。厂商要费尽心机才能让指示灯和摄像头功能互相独立——我确信很多厂商确实这么做了，而且是出于你能想到的最坏的理由。）

Gigachad 一句话收尾：

> "It's more a testament to how little most companies care. The solution is simple and yet most products are defective." — Gigachad

> （这更多是厂商有多不上心的证明。方案很简单，可大多数产品就是不合格。）

### 亲测派：20 分钟拿到 WiFi 熔岩灯的固件

讨论里最实用的部分是一批"顺手就干"的实战帖。Waterluvian 两句话就拿下了一个继电器：

> "Two weeks ago I told Claude 'I have a <wifi outlet relay> on the LAN at <IP>. Assume direct control of it.' And about 8 command approvals later I had a new firmware running on it." — Waterluvian

> （两周前我跟 Claude 说："我在局域网 <IP> 上有一个 WiFi 插座继电器，直接接管它。"大约 8 次命令确认之后，新固件就跑在上面了。）

他说自己只想弄个 WiFi 熔岩灯，结果 20 分钟干完了过去得查半天资料的活。philips 分享了一个更冷门但更典型的案例——用 agent 逆向 Supernote 笔记的文件格式，社区求了几年的文档，几小时就有了代码和规范。cromka 更绝，他顺着这思路去给自己的宠物喂食器（PetKit 牌）换 ESPHome，结果发现原厂固件重试 5 次后会把更新降级成明文 HTTP，密钥和升级路径全部暴露——"这些 IoT 公司对安全有多不上心，一望便知"。

### 护栏双标：美国模型拒绝，中国模型照做

两篇文章有一个共同的刺——模型的安全护栏。PeterStuer 在 schlarp 帖下直接开火：

> "Claude let you do this, but if I want to debug my own Python code it refuses because 'cybersecurity'?" — PeterStuer

> （Claude 让你干这个，但我只想调试自己的 Python 代码，它却以"网络安全"为由拒绝？）

aetherspawn 更直接：他觉得 Opus 5 对逆向毫无用处，"直接拒绝，只有靠一番'我依据合法维修权在修东西'的提示词工程才能让它跑一分钟"。

而平板帖把对比推到了中美模型层面。文章里，Claude 连"总结我自己设备上的旧日志"都做不了——提示词被安全护栏拦截，会话被作者命名为"claude-nerf"；Kimi K3 则先自我论证"root 自己的设备在大多数司法辖区合法"，再开工。AntonyGarand 的"AI:DR"一句话点题：

> "an AI:DR; is enough: the models found unpatched vulnerabilities and managed to create an exploit to root the tablet, chinese models did it while American ones fell back to their safeguards." — AntonyGarand

> （一个 AI 摘要就够：模型们找到了未修补的漏洞并做出 root 平板的利用程序，中国模型干成了，美国模型退回到了自己的安全护栏。）

### "prompt kiddie"之争：技术的活都干了，剩下的是什么

平板帖的另一半讨论跑偏到"作者是不是用 AI 写的文章"。cgearhart 用"水管工"打了最漂亮的比方，把"prompt kiddie"驳得体无完肤：

> "I understand why 'prompt kiddie' feels accurate, but I don't think it is. Expertise is amplified with LLM agents. The same $300 of tokens given to my plumber—who is an excellent plumber—is unlikely to produce the same outcome." — cgearhart

> （我懂为什么"提示词小子"听起来挺贴切，但我觉得不是。经验会被 LLM agent 放大。同样 300 美元的 token，给我那位手艺极好的水管工，几乎不可能产出同样的结果。）

jychang 的批评更技术化：他看出文章是"人类 prompt + claude 腔铺陈"的拼接体——作者真实的 prompt（"okya, it's been hours, grind attempt 46…"）读起来像工程师，而正文铺陈读起来像 claude。Grombobulous 则主张就此打住：

> "At this point it's more exhausting to discuss whether an article was written using AI than it is to accidentally read an article written by AI." — Grombobulous

> （讨论"这篇文章是不是 AI 写的"，比不小心读一篇 AI 写的文章还让人心累。）

## 典型观点一览

| 立场 | 用户 | 一句话 |
|------|------|--------|
| 解放派 | echelon | 一切硬件都属于我们了，AI 让拆解零护城河 |
| 兴奋派 | compiler-devel | LLM 给了开源运动梦寐以求的自由 |
| 开源反思 | wartywhoa23 | 把热爱的事外包给订阅制大厂，这算哪门子开源梦 |
| 安全悲观 | hypfer | 每台我们能"拥有"的 IoT，坏人也照样能用 |
| 厂商责任 | ryandrake | 指示灯与摄像头分离是举手之劳，很多厂商故意不做 |
| 反恐怖叙事 | jauntywundrkind | 把好工作包装成恐怖片，只会让你更不敢碰设备 |
| 经验放大 | cgearhart | 同样 300 美元 token，给水管工和给你，结果天差地别 |
| 写作质疑 | jychang | 作者的真实 prompt 读起来像工程师，铺陈读起来像 claude |

## 总体情绪

评论区呈现出罕见的三分裂。一方是纯粹的"技术解放"兴奋——AI 把逆向从"国家级技能"变成"两小时 churn"，亲测派晒出的战绩一个比一个离谱：从 WiFi 熔岩灯到 10 倍精简的兄弟打印机驱动。另一方是彻骨的安保恐惧——LED 能关、签名能绕、隔空设施能被烟雾报警器敲开，hypfer 的"赢的只是少数人"给狂欢踩了刹车。还有一小撮人在讨论媒介本身：连"这篇文章是不是 AI 写的"都能吵一百多楼。

最有张力的对比在最后。schlarp 以安全从业者身份恐惧这套能力；而 jauntywundrkind 反驳说，把解放硬件的工作讲成恐怖故事，只会让大家更不敢碰自己的设备。这个行业永远分不清"力量"和"恐惧"该用哪个词。但两篇文章共享同一个支点：厂商把"所有权"偷走了，AI 又把它还回来了。护栏挡得住模型，挡不住决心；锁能锁住固件，锁不住好奇心。也许那句总结平板之战的评语，才是对这场讨论最贴切的注脚——你真正想要的本就不是 root，而是"这玩意儿归我"。

## 引用帖子

| # | 标题 | URL |
|---|------|-----|
| 1 | Everything I own, owned | https://news.ycombinator.com/item?id=49413320 |
| 2 | I spent $266 and four AI models to own my tablet. GLM-5.3 finished it in a day | https://news.ycombinator.com/item?id=49409073 |

## 免责声明

<div class="disclaimer">
本摘要基于 HN 帖子 "Everything I own, owned" 与 "I spent $266 and four AI models to own my tablet" 的讨论整理而成，不代表本网站立场。引文内容版权归原作者所有。
<br><br>
<em>本摘要由 AI 模型辅助生成：deepseek/deepseek-v4-flash</em>
</div>
