---
layout: post
title: "LinkedIn 招聘中的后门 — HN 讨论提炼"
date: 2026-06-16
categories: [articles]
---

## 原文概要

一位安全研究人员在 LinkedIn 收到加密创业公司的招聘邀约. 对方要求审查一个 GitHub 仓库作为面试任务, 但该仓库包含恶意代码——执行后会安装后门. 研究人员向 GitHub 和 LinkedIn 举报后, 截至发文时仓库未被处理.

多名评论者指出这与 DPRK (朝鲜) Lazarus 集团的攻击手法高度吻合.

来源: HN 热门榜 (/best)

---

## 讨论焦点

### 1. 攻击手法的危险之处

> "This is uncomfortably close to a normal interview task now. Someone sends you a repo, says the install is broken, and asks you to take a look. A lot of developers would run rpm install before thinking."
> — aykutseker
> （这和正常的面试任务太像了. 发个仓库说安装坏了让你看看. 很多开发者想都不想就会执行安装脚本.）

> "Been through this 3 times in the last 6 months. They're getting better. Very credible LI profiles, code looks OK if you only take a glance. The bell starts ringing when they insist you run local commands."
> — dantodor
> （过去 6 个月经历了 3 次. 他们越来越好了. LinkedIn 资料很可信, 代码扫一眼也正常. 但当他们坚持让你本地运行时就该敲警钟了.）

### 2. DPRK Lazarus 集团

> "This is very likely Lazarus Group — specifically Famous Chollima aka the DPRK."
> — clemailacct1

> "Smells like contagious interview campaign by DPRK folks. They have been doing this for a while. Even using IDE settings, Claude hooks for malicious code execution."
> — abhisek
> （朝鲜团伙的传染性面试攻击. 甚至利用 IDE 设置和 Claude hooks 执行恶意代码.）

### 3. 举报无果

> "I reported the repo to GitHub and the recruiter to LinkedIn. So far nothing has changed and the code is still up."
> — 原文作者

> "Oh, Microsoft." — BobAliceInATree

### 4. 应对比建议

> "Why is npm still not blocked by every OS on earth is beyond me."
> — elwebmaster

> "Remember to use protection when meeting strangers' code: sandbox, VM, read before run."
> — theoeiffijr

> "Isn't this how most NPM authors are hacked these days? I think the axios guy got hit with the same approach over LinkedIn."
> — CyanLite2
> （axios 的维护者也是通过 LinkedIn 被同样的手法黑掉的吧?）

---

## 典型观点

| 立场 | 用户 | 一句话 |
|------|------|--------|
| 🔴 手法危险 | aykutseker | 和正常面试任务难以区分 |
| 🔴 多次出现 | dantodor | 6 个月遇到 3 次, 越来越逼真 |
| 🔴 DPRK | clemailacct1 | Lazarus 集团 Famous Chollima 所为 |
| ⚪ 举报无效 | 原文作者 | GitHub/LinkedIn 均未处理 |
| ⚪ 防护 | elwebmaster | 跑的代码必须先审查, 永远先跑沙箱 |

<div class="disclaimer">
**免责声明**: 本文是对 HN 讨论的编译与提炼. 所有观点来自 HN 评论者, 不代表本人立场.
</div>
