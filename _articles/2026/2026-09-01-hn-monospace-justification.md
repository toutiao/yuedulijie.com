---
layout: post
title: >-
  手工逐词对齐 17,000 字攻略 — HN 讨论摘要
date: 2026-09-01
categories: [articles]
excerpt: >-
  1990 年代，一位《超级银河战士》攻略作者用 ASCII 编辑器手写 17,000 字攻略，硬是靠挑词让每一行右缘对齐，一个双空格都不留。评论区由此炸出排版的执念、X 档案的对白之谜，以及"AI 会不会让这种手工艺过时"的争论。
tagline: >-
  排版软件做不到的事，1990 年代的攻略作者用挑词做到了：17,000 字，每行右缘对齐。
---

## 原文概要

2026 年 8 月 30 日，博客 Unsung 发了一篇短文《"I just chose words carefully"》，登上 HN 首页，拿下 1183 分、约 340 条评论。文章的核心是一个排版问题：等宽字体（monospace）里做全两端对齐（full justification）非常难——空格太大、无法均匀分布，观感糟糕。

排版界常用的解法是断字（hyphenation），但在等宽字体里连字符同样碍眼，还会破坏复制粘贴。作者指出还有第三条路：不排版，直接重写文字——只挑那些恰好凑够行长的词，避免出现双空格。这正是 rs1n 在 1990 年代末为《超级银河战士》写攻略时干的事：一篇 17,000 字的攻略，每一行右缘都精确落在字母上，找不到一个双空格。

攻略底部有个自问自答：用什么程序做的两端对齐？"没有。我只是仔细挑词，让一切在右侧对齐。全部用 ASCII 编辑器完成。"作者说，纸质书为了避开孤行（widow）和孤儿行（orphan）重写文字不算稀奇，但在屏幕上少见。评论区读到这里，反应是"既敬佩又恐惧"。

## 讨论焦点

### X 档案的"不要孤行"轶事

评论区第一个岔路来自一条相似的轶事：吉莲·安德森（Gillian Anderson）在采访中透露，X 档案的编剧兼主创 Chris Carter 有近乎强迫症的习惯，写对白时会刻意避开孤行，让每段对白的末行贴齐右缘。有用户指出这影响了整部剧的对白节奏：

> "There's a similar anecdote Gillian Anderson recently revealed during an interview on the X-Files, saying Chris Carter had an OCD-like habit to write dialog to conform to certain text layout preferences (no widows) in the script, which made for the show's distinctive style of dialog cadence." — sho_hn

> （"X 档案有个类似的轶事，吉莲·安德森最近在采访里提到，Chris Carter 有近乎强迫症的习惯，写对白时会让它符合某种文字排版的偏好——剧本里不出现孤行，这造就了这部剧标志性的对白节奏。"）

有用户真的去翻了剧组的正式剧本核对，结论是这条轶事属实：

> "Hey, I looked into this too! And I came to the conclusion that it's completely true." — tobr

> （"我也查过这件事，结论是它完全属实。"）

也有排版爱好者泼冷水，认为"避开孤行"撑不起整部剧的节奏：

> "'No widows' on its own isn't enough to create a distinctive dialog cadence." — rectang

> （"光'避开孤行'本身，不足以造就一种独特的对白节奏。"）

更深的洞察是：节奏的奇特未必来自排版规则，而来自为满足排版而进行的语言加工——从自然流动的语言，变成堆乐高：

> "the distinctive cadence is not a direct consequence from eliminating widows but from the mental process used to achieve this efficiently. language goes from natural fluidity to stacking Lego bricks." — raffael_de

> （"那种独特节奏并非消除孤行的直接结果，而是来自为高效做到这一点所用的思维过程。语言从自然的流动感，变成了堆乐高。"）

### Tom7 用 LLM 干了同一件事

很快有人提起 Tom7（suckerpinch）的视频——他用 LLM 自动完成了同样的等宽两端对齐：

> "suckerpinch has a great video where he uses an LLM to do this same thing automatically" — ivw

> （"suckerpinch 有个很棒的视频，他用 LLM 自动完成了同样的事。"）

评论区一致认为原文作者没提 Tom7 的经典作品是重大遗漏：

> "No mention of Tom7's 'Badness 0' by the author is the a crime!" — ivanjermakov

> （"作者居然没提 Tom7 的 'Badness 0'，这是犯罪！"）

有用户为这个视频辩护，提醒别被"用 LLM"劝退：

> "If you're reading this and you're put off by the 'uses an LLM', don't be. This is not a low-effort video, quite the opposite. This is one of the best YouTube videos I have ever seen." — bla3

> （"如果你读到'用了 LLM'就想划走，别这样。这绝不是低成本的视频，恰恰相反，这是我见过最好的 YouTube 视频之一。"）

还有一句传神的总结：这是"形式压倒功能"的终极形态：

> "He managed to create the ultimate version of form over function. All hail Lorem Epsom." — uolmir

> （"他做出了形式压倒功能的终极版本。万岁，Lorem Epsom！"）

### AI 会让这种手工艺过时吗

更大的一层忧虑是：这种靠人力和执念堆出来的作品，会不会被 AI 淘汰。有用户直言可惜：

> "The Super Metroid guide is the kind of thing that AI will render obsolete, which makes me sad." — gkoberger

> （"超级银河战士攻略是那种会被 AI 淘汰的东西，这让我难过。"）

反方的反驳很关键：作者当年也不是非做不可，他做是因为在乎，AI 时代依然会有人在乎：

> "But he didn't need to do that before either. He did it because he cared (in a weird way, sure). And some people will still care." — garciansmith

> （"但他当年也不是非做不可。他做，是因为他在乎（当然，是种奇怪的在乎）。而有些人依然会在乎。"）

真正的问题被一步追问到：你还能分得清"他在乎"和"他花 30 秒打了句提示词"吗？

> "Yup that's my point, and maybe the bigger issue isn't if people care or not but rather... can we distinguish between 'they cared' and 'they spent 30 seconds on a prompt'." — gkoberger

> （"对，这就是我的意思。更大的问题也许不是有没有人在乎，而是……你能不能分清'他用心了'和'他花了 30 秒打提示词'。"）

### 孤行与孤儿行的术语学

讨论里顺便普及了一轮排版术语：孤行是段落末行被挤到下一页顶部，孤儿行是段落首行单独落在页尾：

> "Widows are when the final line of a paragraph starts the next page. Orphans are when the first line of a paragraph ends a page." — wombatpm

> （"孤行（widow）是段落的末行跑到了下一页开头；孤儿行（orphan）是段落的首行单独落在页尾。"）

有用户拿这个开涮——"修复孤行"和"修复孤儿"在排版与生活中难度正好相反：

> "Funny because 'fixing an orphan' is hard in real life (assuming they've lost both their parents, you have to find them a foster home) but easy in typesetting (just add an empty line before), whereas 'fixing a widow' is easy in real life (just remarry) but hard in typesetting." — Biganon

> （"好笑的是，'修复孤儿'在现实中很难——假设他们双亲都没了，你得给他们找领养家庭——但在排版里很容易，加个空行就行。反过来，'修复孤行'在现实中很容易，再婚就行，但在排版里很难。"）

德语术语更生猛——孤行叫 Hurenkind，直译是"婊子的孩子"：

> "In german typography the name for widow is 'Hurenkind' wich translates to 'child of a whore'. I was pretty surprised to hear that word on a regular basis while working in text for print." — ahofmann

> （"德语排版里，孤行叫 Hurenkind，直译是'婊子的孩子'。在印刷行业工作时天天听到这个词，我相当震惊。"）

### 拼错的 "missles" 与诺亚·韦伯斯特

有人注意到攻略里把 missiles 拼成了 missles，并好奇作者发现后是不是选择将错就错：

> "I wonder if at any point during writing, the heroic author of that Super Metroid guide learned that 'missiles' are not spent 'missles', and decided to own the mistake rather than reword the entire guide." — _jackdk_

> （"我好奇这位英雄般的攻略作者在写作中某一刻发现 missiles 不是 missles 时，是不是决定认下这个错，而不是为它重写整篇攻略。"）

有人顺势调侃，作者可能是在致敬诺亚·韦伯斯特的音标拼写改革：

> "I choose to believe that the author was channeling the spirit of Noah Webster as a deliberate champion of phonetic spelling reform." — kibwen

> （"我选择相信作者是在召唤诺亚·韦伯斯特的灵魂，做音标拼写改革的有意捍卫者。"）

另一位用户搬出安德鲁·杰克逊的段子，把拼写之争推回 19 世纪：

> "Or Andrew Jackson approaching the problem from the other end. 'It is a damn poor mind indeed which can't think of at least two ways to spell any word.'" — somat

> （"或者像安德鲁·杰克逊那样从另一端下手：'一个连一个词都拼不出至少两种写法的人，脑子确实够呛。'"）

### 手工对齐的共鸣与质疑

最后，这则轶事让不少开发者和编辑找到了共鸣——在注释和提交信息里干过同样的傻事：

> "I am filled with both a deep admiration and horror at this. It's shockingly impressive." — epistasis

> （"我对此既深深敬佩又深深恐惧。它惊人地厉害。"）

也有用户补充：这不是普通排版，而是排版界没人敢碰的极限：

> "And that it was done for an amateur game guide! This is like a legendary work of art." — cm2012

> （"而且它是为一个业余游戏攻略做的！这简直是传说级的艺术作品。"）

质疑声也有：有用户认为原文不过是把旧事重抄了一小段：

> "The OP is just a small snippet of plagiarism of an old fact." — gowld

> （"原帖不过是把一件旧闻抄了一小段。"）

## 典型观点一览

| 立场 | 用户 | 一句话 |
|------|------|--------|
| 敬佩派 | epistasis | 对这份手工作品既敬佩又恐惧 |
| 怀旧派 | cm2012 | 业余攻略做到这个程度，是传说级艺术品 |
| 追问派 | gkoberger | AI 时代还能分清"他在乎"和"他打了句提示词"吗 |
| 乐观派 | garciansmith | 他当年是因为在乎才做的，以后依然会有人在乎 |
| 考据派 | tobr | X 档案"避孤行"轶事经剧本核对完全属实 |
| 质疑派 | rectang | 光避孤行撑不起整部剧的对白节奏 |
| 观察派 | raffael_de | 奇特节奏来自语言加工本身，像在堆乐高 |
| 吐槽派 | gowld | 原帖只是把旧闻抄了一小段 |

## 总体情绪

这篇短文的魅力在于它很小，却能同时触发敬意、好奇与怀旧。评论区的情绪先是"天啊这是手写的"，随后转向考据：X 档案的"避孤行"轶事被翻剧本验证，德语 Hurenkind 的粗俗令人发笑，拼错的 missles 引出诺亚·韦伯斯特和安德鲁·杰克逊。整场讨论像一次集体考古——大家围着 1990 年代的一篇攻略，重新确认某种快要失传的"花时间"。

而最扎心的问题来自 AI 时代：当一切都可以靠提示词瞬间生成，"有人用心做了这件事"和"有人花了 30 秒"之间的边界正在模糊。可在攻略 FAQ 那句朴素的回答面前——"没有程序，我只是仔细挑词"——评论区给出的答案很简单：总有人会在乎，也总有人愿意为对齐一行字，挑一整个下午的词。

## 引用帖子

| # | 标题 | URL |
|---|------|-----|
| 1 | "I just chose words carefully" | https://news.ycombinator.com/item?id=49503601 |
| 2 | 原文："I just chose words carefully" | https://unsung.aresluna.org/i-just-chose-words-carefully/ |

<div class="disclaimer">
  <strong>免责声明：</strong>本文为 AI 摘要，旨在提炼 HN 社区讨论要点，不代表本网站立场。内容可能存在遗漏或偏差，建议阅读原文以获取完整信息。
  <br><br>
  <em>本摘要由 AI 模型辅助生成：deepseek/deepseek-v4-flash</em>
</div>
