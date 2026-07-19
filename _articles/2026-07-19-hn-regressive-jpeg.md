---
layout: post
title: "Regressive JPEGs — 一张图片里藏一段视频 — HN 讨论"
date: 2026-07-19
categories: [articles]
excerpt: >-
  利用 JPEG 渐进式扫描特性，把多张图片拼进同一个文件。浏览器加载时自动切换画面，播放速度完全取决于网络延迟。
tagline: >-
  把 90 帧 JPEG 拼成一张图：第一帧是猫，最后一帧也是猫，但不是同一只猫。
---

Maurycy Z 发布了一篇技术博文，展示了一种奇特的 JPEG 文件——"Regressive JPEG"。标准 JPEG 支持渐进式（progressive）编码，图片先加载低频信息（模糊轮廓），再逐步补充高频细节。作者利用这个特性，将多个不同图片的扫描段（scan）拼接进同一个文件：浏览器加载时，先看到第一张图的低频信息，随后高频数据覆盖上去，最终显示的是另一张图。

更加极端的方法是只保留 DC（直流）扫描段。这样可以在一个 JPEG 中塞入约 90 帧，形成一段"视频"——播放速度完全取决于网络延迟。Chrome 能渲染约 90 帧，Firefox 的耐心更多一些。作者自嘲说“除了 Rickroll 和恶作剧，没有实际用途”。

社区显然不这么想。

### “这不是第一个文件格式越界的 hack”

多人指出类似的思路在其他格式上也出现过。

> "I did something very similar with progressive (adam7 interlaced) PNG" — Retr0id
> （Retr0id 用 PNG 的 Adam7 交错编码做了同样的事：将多个画面编码进一张 PNG，通过服务器端延迟发送来控制帧率。）

> "And I did something similar to steam live video via an infinite gif" — jbochi
> （jbochi 用无限 GIF 实现了实时视频流。）

> "I've been here screaming 'Motion JPEG EXISTS and is well supported in browsers' the entire time those gif hacks were popular." — donatj
> （donatj 指出 Motion JPEG（MJPEG）早已存在且浏览器原生支持。他展示了一个基于 MJPEG 的多用户画板，完全不需要 JavaScript。）

### 服务器端控制播放节奏

既然网络延迟决定"播放速度"，那服务器完全可以主动控制发送节奏。

> "You can use Service Worker to emulate a slow connection :)" — est
> （est 调侃说用 Service Worker 伪造慢速连接即可控制帧率。）

> "Easy enough to add a delay() each frame if your server is python/nodejs/PHP/whatever" — londons_explore
> （在服务端每帧加入 delay() 即可实现精确计时。）

### 浏览器的差异化表现

不是所有浏览器都能正常播放这些"视频"。

> "Safari just freezes in place until the image is entirely finished downloading." — LoganDark
> （Safari 直接卡死，等整个图片下载完才渲染。）

> "Weird that it's inconsistent. Works fine for me in desktop Firefox. But on mobile iOS the 'whole video within a jpeg' is 3 frames, all of which are nearly entirely solid color brown->orange->red with a vague cat silhouette." — snailmailman
> （桌面 Firefox 正常，iOS 上只显示 3 帧纯色块——棕色→橙色→红色，猫只剩一团剪影。）

### 隐写术与 AI 对抗

有人看到了更深层的用途。

> "Yep this is an AI subversion technique for sure. Put the message to the humans in the first frame, and the message to the AI in the final frame. This is how we defeat skynet: by sending each other pictures of cats." — aetherspawn
> （对人类显示一帧，对 AI 显示另一帧——打败 Skynet 的方法就是互发猫图。）

> "I wonder if and how you can use this for steganography, hiding data in plain sight. I bet most automated image analysis programs would only consider the final image." — tda
> （tda 推测大部分自动图像分析程序只会读取最终帧，让中间帧成为隐写通道。）

### Progressive JPEG：有用还是无用？

讨论自然延伸到了 Progressive JPEG 的实用价值——一个老话题被重新翻了出来。

> "I've recently played with opengl and jpeg turbo and I wanted to display images fast. I don't remember exact numbers, but enabling progressive for a jpeg was a significant slowdown for decoding." — Yokohiii
> （Yokohiii 实测 progressive 会显著降低解码速度，质疑其实际价值。）

> "Progressive decoding isn't expected to speed up decoding, it's expected to speed up displaying large image files, especially for downloads via slow mobile connections." — cubefox
> （cubefox 反驳：progressive 不是为了加速解码，而是为了在慢速连接上更快地看到图片的模糊版本，决定是否值得继续等待。）

> "JPEG photos stored as progressive usually take ~5% less space so there is value." — Self-Perfection
> （Self-Perfection 补充：progressive JPEG 通常还能节省约 5% 的存储空间，且可以无损转换。）

## 典型观点一览

| 立场 | 用户 | 一句话 |
|------|------|--------|
| Hack 赞赏 | cousin_it | 用服务器按时间分块发送，甚至可以做成无限流。 |
| 实用性质疑 | korbatz | 如果色情行业都没用上，那大概真的没用。 |
| 隐写/AI 对抗 | aetherspawn | 人类看一帧，AI 看另一帧——用猫图拯救世界。 |
| Progressive 质疑 | Yokohiii | 解码速度慢到不值，已经几十年没见过渐进加载效果了。 |
| Progressive 辩护 | msm_ | 你可能没注意到而已，30% 文件大小时就能显示低分辨率版本。 |
| 社区情感 | bartread | 周末的 HN 才是 HN，平时那是 LinkedIn。 |

## 总体情绪

整个讨论充满了"这才是 HN 该有的内容"的氛围。社区对作者的创意表达了近乎一致的欣赏，同时积极贡献了 PNG 交错编码、MJPEG、Service Worker 节奏控制、隐写术猜想等延伸思路。关于 Progressive JPEG 实用性的争论贯穿始终，但没有人否认这个 hack 本身的精妙。

一张 JPEG 在浏览器里变成了一段视频——不需要 JavaScript，不需要视频格式，只需要一个足够慢的网络连接。

## 引用帖子

| # | 标题 | URL |
|---|------|-----|
| 1 | Regressive JPEGs — HN 讨论 | https://news.ycombinator.com/item?id=48954851 |
| 2 | 原文：Regressive JPEGs | https://maurycyz.com/projects/bad_jpeg/ |
| 3 | Retr0id 的 PNG Adam7 版本 | https://www.da.vidbuchanan.co.uk/adamation/image.png |
| 4 | MJPEG-php | https://github.com/donatj/mjpeg-php |
| 5 | Progressive Image Viewer | https://stan-kondrat.github.io/progressive-image-viewer/ |

<div class="disclaimer">
本文是对 Hacker News 讨论的摘要与整理，不构成原文的完整呈现。所有引文均来自 HN 社区，其观点不代表本网站立场。
<br><br><em>本摘要由 AI 模型辅助生成：deepseek/deepseek-v4-flash</em>
</div>
