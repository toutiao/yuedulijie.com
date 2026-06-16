---
layout: post
title: "Curl 七月不受理安全漏洞 — HN 讨论提炼"
date: 2026-06-16
categories: [articles]
---

## 原文概要

Curl 维护者 Daniel Stenberg 宣布: 2026 年 7 月全月不接受新的安全漏洞报告. 原因是维护者需要休假. libexpat 和 uriparser 也跟进.

来源: HN 热门榜 (/best)

---

## 讨论焦点

### 1. 维护者的人性时刻

回复中最被引用的一句话:

> "The bad guys won't rest. Probably not. But we will."
> — Daniel Stenberg

> "A pleasant dose of humanity in decidedly inhuman times." — zarzavat

> "I read one sentence into this and knew directly that the developer must've been Swedish!" — low_tech_love

### 2. 背后的付费支持模式

> "The headline buried the lede — this is a way to get some summer vacation AND encourage enterprise support contracts, which will still have availability."
> — vessenes
> （标题没点出重点: 这既能放暑假, 又能推动企业购买付费支持合同——合同客户在七月仍享有服务.）

### 3. 开源单点依赖

> "This puts the spotlight on our collective dependence on a handful of individuals basically working for free with no backup."
> — laszlojamf
> （这再次揭示了我们集体依赖几个无后备的免费个体.）

### 4. LLM 加剧维护者负担

> "Maintainers of FOSS project are constantly overwhelmed with close to 0 reward and now with LLMs the management of merge requests exploded even further."
> — flaburgan
> （开源维护者长期以接近零回报超负荷工作, LLM 让 PR 管理进一步爆炸.）

### 5. 行业示范效应

> "Both libexpat and uriparser are following the curl security vacation."
> — spyc
> （libexpat 和 uriparser 跟进 curl 的安全休假.）

---

## 典型观点

| 立场 | 用户 | 一句话 |
|------|------|--------|
| 🔵 人性化 | zarzavat | 这是个在非人时代里散发着人性味的好决定 |
| 🟡 商业模式 | vessenes | 休假 + 刺激企业支持合同, 一石二鸟 |
| 🔴 单点依赖 | laszlojamf | 关键基础设施维系在几个免费工作者身上 |
| 🔴 LLM 加剧 | flaburgan | LLM 让维护者的负担又炸了一次 |
| ⚪ 示范效应 | spyc | 其他项目跟进, 可能形成行业惯例 |

<div class="disclaimer">
**免责声明**: 本文是对 HN 讨论的编译与提炼. 所有观点来自 HN 评论者, 不代表本人立场.
</div>
