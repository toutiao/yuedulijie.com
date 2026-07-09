---
layout: post
title: "Uniqlo T 恤上的 bash 脚本彩蛋 — HN 讨论摘要"
date: 2026-07-09
categories: [articles]
excerpt: >-
  Uniqlo 与 Akamai 联名 T 恤背面印有一段混淆过的 bash 脚本，解码后是一个不断循环的彩色 ASCII 动画，内容是 ♥PEACE♥FOR♥ALL。
tagline: >-
  买件 T 恤还要先 OCR 才能跑彩蛋
---

## 原文概要

Akamai 与 Uniqlo 联名的 "Peace for All" 系列中有一件 T 恤，背面印着一大段看似乱码的字母数字块。仔细看，居然以 `#!/bin/bash` 开头——这是一段完整可运行的 bash 脚本，经过 base64 编码后印在了衣服上。

博主 Tris Sherliker 从妻子那里看到这件 T 恤后，决定把脚本解码出来。他先后用了 Android 圈选搜索的 OCR、Tesseract（带各种参数调整）、以及 Claude 三种方式，比对输出差异后手动修正，最终拼出了完整的 base64 字符串。解码后的脚本是一个彩色循环动画：`♥PEACE♥FOR♥ALL` 字符在终端中以正弦波轨迹逐字下落，颜色从青色 (12) 渐变到橙色 (208)。

衬衫的设计出自 Akamai，米色参考了 80-90 年代电脑机箱的 "beige box" 配色。这已经是 Akamai 与 Uniqlo 合作的至少第二款技术主题 T 恤——前一款印的是 Go 代码。

## 讨论焦点

### OCR 体验：有人踩坑，有人秒解

作者坦言 OCR 过程痛苦，base64 没有纠错能力，转录必须完美。但评论区里不少人有完全不同的体验。

> "I gave the photo to Opus 4.8 and it reconstructed the same script in one shot." — underyx
> （我把照片扔给 Opus 4.8，一次性就还原了完整脚本。）

> "I ran it through paddle paddle OCR and it flawlessly did it." — acters
> （用 PaddleOCR 完美识别，毫无问题。）

> "Is it? Android tap and hold/image text select one-shotted it in 2 seconds." — fennecfoxy
> （Android 图片文字选择功能两秒就搞定了。）

作者本人也出现在评论区，解释了自己用的工具链：

> "Author here - that's a good idea actually, it shouldn't be too hard to compare the various attempts. The tools I used were whatever my Android built-in is (likely Google Gemini, but I can't tell whether this is something Samsung has replaced in OneUI); tesseract; tesseract with various tweaks and charset restrictions; Claude; and finally, manual fixes based on disagreements between all the previous." — speerer
> （作者本人回应：工具包括 Android 自带 OCR、Tesseract、Claude，以及基于三者差异的手动修正。）

也有读者指出，作者费力 OCR 的做法本身就是一个行为艺术般的讽刺：

> "'just typing it' would be more error prone for the average human" — mayas_
> （手动输入对普通人来说更容易出错。）

> "Not really. Transcribing long sequences of nonsense is annoying but quite easy to do without error as long you're patient enough to follow a simple process of reading, typing, and double-checking character-by-character." — t-3
> （其实不难，耐心逐字符阅读、输入、复核就行了。）

### 匿名 LLM 代写的？

评论区最大的争论之一是：这段脚本到底是人写的，还是 LLM 生成的？

> "Definitely LLM. No humans write that many comments." — IshKebab
> （绝对是 LLM 写的，正常人不会写那么多注释。）

> "I don't think it was written by an LLM, some things stand out: The congratulations text is both in English and Japanese. Contains a single heart emoji. There was an intention to have a cyan to orange gradient, but the range starts in an ANSI block, ends halfway through the 256 color block and 256 terminal colors are not arranged like a gradient at all. There's no sleep at the end of the loop where I feel like an LLM would add that defensively." — lemagedurage
> （不像是 LLM 写的。祝贺语有日英双语，只包含一个心形 emoji。颜色渐变意图从青色到橙色，但 256 色终端颜色排列根本不是渐变的。循环末尾没有 sleep——LLM 通常会防御性加上。）

另一位用户做了更细致的逐行分析：

> "What made me start to wonder, personally, was that the output seems identical if you use '♥PEACE♥FOR♥ALL' instead of the version with internal repeats. IF there is any point to that 'manual expansion of the cycles', IMO that deserves a comment much more so than '# Calculate length of text; text_length='. Also, that `echo -n ...` followed by `echo \"\"` instead of just plain `echo` in the first place seems like the kind of copy-pasta code LLMs generate." — cb321
> （反复展开的 "PEACE" 序列实际上没什么效果变化，真正值得注释的地方没人注释。`echo -n` 加 `echo ""` 而不直接写 `echo`，像是 LLM 生成的复制粘贴代码。）

反对者则认为这只是开发者换语言时的生疏表现：

> "All the smells you pointed out, just look like a Python dev approaching bash without fully understanding it." — shakna
> （你说的那些可疑迹象，看起来只是 Python 开发者写 bash 时的生疏表现。）

### 手动输入的情怀

多位年长读者回忆起八九十年代从杂志上敲代码的经历：

> "That was also my thought… but I grew up mashing rubber keys for hours copying 'games' out of magazines and books! Then hours after fixing all the typos!" — christoph
> （我也是这么想的……但我小时候是从杂志上抄游戏代码长大的，敲完还要花几个小时修错字。）

> "Those of us who grew up in the 8-bit era would have just typed it in, carefully, in silence, with no-one allowed to enter or leave the room until we were done ;-)" — ErroneousBosh
> （我们 8 位机时代长大的人，会安安静静地逐字敲进去，不准任何人进出房间直到敲完。）

### 依赖与兼容性问题

脚本依赖 `bc` 做数学计算，但很多系统默认没有安装：

> "./cool.sh: line 31: bc: command not found... Very wow. Shame they assumed everyone has 'bc'." — lloydatkinson
> （脚本假设人人都有 `bc`，但很多系统默认不带。）

> "Why would that be a shame? 'bc' is a mandatory POSIX command, while /bin/bash isn't (/bin/sh is the standard)." — em500
> （`bc` 是 POSIX 强制命令，bash 反而不是。）

另有用户发现 UTF-8 环境问题：

> "I noted from the video that the ♥s (hearts) worked on whatever version of bash he tested with though it failed for me... `LC_ALL=en_US.UTF-8 bash ..` fixed it." — cb321
> （视频里心形符号正常显示，我自己跑却不行……设置 `LC_ALL=en_US.UTF-8` 后解决。）

### 设计师的幕后故事

有用户分享了设计师制作过程的视频：

> "I love this shirt! Here's a nice video from the actual designer about the process of making this shirt (including intentionally making it hard to OCR)." — wbh1
> （设计师视频链接，包括故意让 OCR 困难的细节。）

作者看到后很高兴：

> "Author here. Thank you so much for the link which I hadn't seen! I'm very happy to see this and I'm gratified that it was deliberately difficult to OCR, not just me." — speerer
> （作者感谢视频链接，得知是故意为难 OCR 后感到欣慰。）

### 字体误认

作者最初认为衬衫上使用的是 Consolas 字体，但被 HN 用户纠正为 Roboto Mono。这个误认还引发了一段有趣的误解：

> "I guess Uniqlo is run through Windows though: one thing that struck me was the font, which I'm almost certain is Consolas." — 原文
> （作者由此猜测 Uniqlo 用的是 Windows 环境。）

> "Thank you for spelling it out for me because I thought I was looking at a completely hallucinated AI article." — tym0
> （谢谢你解释清楚，我差点以为这是一篇 AI 幻觉生成的文章——从终端讨论突然跳到 Windows 字体，太跳跃了。）

## 典型观点一览

| 立场 | 用户 | 一句话 |
|------|------|--------|
| OCR 很痛苦 | speerer（作者） | 用了三套工具再加手工比对才搞定。 |
| OCR 很简单 | underyx / fennecfoxy | 现代视觉模型／手机自带功能一次成功。 |
| 脚本是 LLM 写的 | IshKebab / cb321 | 注释太多、写法怪诞，典型的 LLM 风格。 |
| 脚本是人写的 | lemagedurage / shakna | 细节（双语祝贺、颜色偏差）更接近人类，或 Python 开发者转 bash。 |
| 手动输入才是正道 | christoph / ErroneousBosh | 8 位机时代的人会直接敲，不折腾 OCR。 |
| 自动化过度 | conductr | 花 40 小时自动化一个 10 分钟就能手动完成的任务。 |
| `bc` 依赖不合理 | lloydatkinson | 脚本假设 `bc` 人人都有，但很多系统默认不装。 |

## 总体情绪

整个讨论的氛围轻松而怀旧。一件 T 恤上的彩蛋勾起了多重维度的对话：OCR 工具的能力现状、LLM 生成代码的特征辨认、八九十年代手工敲代码的集体记忆。

有用户直言 "花 40 小时自动化 10 分钟的手工活" 是当代工程师文化的缩影；也有用户觉得这正是乐趣所在——"优化的是自己的不耐烦，而不是时间。" 一件 T 恤，剪影了技术圈的多重面孔。

## 引用帖子

| # | 标题 | URL |
|---|------|-----|
| 1 | Obfuscated, self-evaluating bash script by CDN Akamai being supplied to consumers via retail stores | https://tris.sherliker.net/blog/obfuscated-self-evaluating-bash-script-by-cdn-akamai-being-supplied-to-consumers-via-retail-stores/ |

## 免责声明

本文基于 HN 讨论和原文撰写，旨在提供信息整理与观点摘要，不构成任何专业建议。文中引用内容版权归原作者所有。

<br><br><em>本摘要由 AI 模型辅助生成：deepseek/deepseek-v4-flash</em>
