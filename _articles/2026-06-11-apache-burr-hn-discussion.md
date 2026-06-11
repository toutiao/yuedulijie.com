---
layout: post
title: "Apache Burr — HN 讨论提炼"
date: 2026-06-11
categories: [articles]
---

## 原文概要

Apache Burr 是一个基于状态机的 AI agent 编排框架，由 DAGWorks 团队开发（与 Hamilton 数据流框架同源），2026 年进入 Apache 软件基金会孵化。其核心模式为 `action → transition`：开发者用 `@action` decorator 定义节点，用 builder pattern 串联为状态机。

官网示例代码：

```python
from burr.core import action, State, ApplicationBuilder

@action(reads=["messages"], writes=["messages"])
def chat(state: State, llm_client) -> State:
    response = llm_client.chat(state["messages"])
    return state.update(messages=[*state["messages"], response])

app = (
    ApplicationBuilder()
    .with_actions(chat)
    .with_transitions(("chat", "chat"))
    .with_state(messages=[])
    .with_tracker("local")
    .build()
)
```

官网主打卖点：Simple Python API / Built-in Observability / Persistence / Human-in-the-Loop / Testing & Replay。与 OpenAI、Anthropic、LangChain、Hamilton、Streamlit、FastAPI 等集成。

---

## 讨论焦点

### 1. 要不要 agent 框架？三方立场的碰撞

这是整场讨论的骨架问题，支持与反对的力量相当。

**反方：框架反而阻碍**

顶楼用户 brotchie 以 189 分奠定了讨论基调：

> "I've found it much easier and more maintainable to just build 1:1 code for THAT agent: most of the abstractions you get from an agent framework purely get in the way and obfuscate core agent logic."
> （我发现为每个 agent 单独写代码更容易维护。框架的抽象只会碍事，模糊核心逻辑。）

> "BUT, if you boil it down, an agent really is context building, making an LLM call, executing requested tool calls, parsing the final model output, returning it to some frontend. There's extensions like memory, async tool calls, etc, but not THAT complicated."
> （但是，归结起来 agent 就是构建上下文、调 LLM、执行工具调用、解析输出、返回给前端。有扩展功能但那并不复杂。）

多人附议：

> "Obscuring core logic is the most egregious part of most agent frameworks. One needs a clear view of what, exactly, is being sent to the underlying language model, and what's coming back. Everything in an 'agentic' application is realized as a sequence of tokens eventually. It should be clear and obvious from ~all layers of the app." — kristjansson
> （掩盖核心逻辑是大多数 agent 框架最严重的问题。开发者需要清楚地知道发送给底层模型的是什么、返回的是什么。）

> "Yep.. same. I build my own agents... all use-case specific. Keeps the code super minimal, and avoid unnecessary complexity. I have tried a few of these, but nop.. no help.. only more work (and issues)." — freakynit
> （一样。我自己写 agent，每个用例专属。保持代码极简，避免不必要的复杂度。试过几个框架，没有帮助——只有更多的工作和问题。）

**正方：框架的价值在别处**

> "The advantage of frameworks isn't that they make it easier to write the actual agent, it's tooling + observability + ... Even Langchain, for all the (deserved) criticism it gets, made this very clear very early: Being able to just add one environment variable and instantly have a UI where I can nicely go through all of my traces with basically 0 additional effort is something a hand rolled solution just can't really compete with." — fxwin
> （框架的优势不是让写 agent 更容易，而是工具链和可观测性。加一个环境变量就获得完整的 trace UI，手写方案没法比。）

> "We use libraries to interact with the APIs themselves; nobody would say writing a spec-compliant API client was poor practice. Agentic harnesses are just one layer above: I need to call the API and I need to do it with certain expected conventions." — tcdent
> （我们用库来调用 API，没人说按规范写 API 客户端是坏实践。Agent 框架只比那高一层。）

**折中：框架不是瓶颈**

> "my job rn is just building agents. The hard part about building agents isn't the framework — it's discovery, context, traditional engineering, handling the last mile. There are some invariants like the loop, tools, observability, guardrails, monitors etc..." — vanuatu
> （我每天的工作就是构建 agent。难的从来不是框架——难的是发现、上下文、传统工程、最后一公里。）

brotchie 在子评论中自己也承认框架的真正卖点应该转变：

> "The better pitch would be, 'this is how easy observability, guardrails, monitoring, deployment, evals, versioning, A/B testing are with our framework.' What the agent code looks like is somewhat incidental." — brotchie
> （更好的宣传应该是"我们的框架让可观测性、guardrails、监控、部署、评估、版本管理、A/B 测试变得多容易"。agent 代码长什么样是次要的。）

### 2. Vibe coding 官网——意外的最大热点

一场关于 agent 框架的技术讨论，最热烈的评论却集中在官网设计上。HN 用户直接对照 [performativeUI](https://vorpus.github.io/performativeUI/) 讽刺网站逐项点名：

> "so far I'm seeing: `GradientText`, Animated button, `EyebrowPill`, Aurora background, `MockIDE`, `LogoRow`, `SlippyWords`, `StatCounter`, `CommunityBadge`" — enragedcacti
> （我目前看到了：渐变文字、动画按钮、眉毛小标、极光背景、MockIDE、Logo 行、滑动文字、统计计数器、社区徽章。）

> "also: \`No DSL, no YAML — just Python functions and decorators.\` \`It's not X, its Y\` but with an added em dash is crazy work." — enragedcacti
> （还有 "No DSL, no YAML — just Python functions and decorators"。在 "It's not X, its Y" 后面加个破折号，真是绝了。）

大量用户表示直接关掉了页面：

> "I took one look at the page and immediately closed it. Sorry." — TZubiri
> （我看了一眼页面就关掉了。抱歉。）

> "Wow, such a un-apache-y homepage I've ever seen." — flakiness
> （哇，这是我见过的最不 Apache 的主页。）

> "vibe coded landing page, reddit user testimonial, framework is for state machines. why man.." — vanuatu
> （Vibe coding 的着陆页、Reddit 用户的 testimonial、一个状态机框架。为什么啊……）

有人将这类网站称为"AI 时代的 Bootstrap"：

> "They're all looking the same now. The AI version of bootstrap." — werdnapk

> "Claude Opus really loves this template when building websites. It's very funny how many times I've seen it for recent launches." — lnenad

> "And it lags my desktop every-time, I hate it. It's the default bootstrap theme all over again but instead with SVG's." — doublerabbit
> （每次都卡我的桌面。就是默认 Bootstrap 主题换成了 SVG。）

项目维护者 elijahbenizzy 对此回应："Ha! We went all out on the modern one (user contribution!)."

### 3. "Reddit User" 登上官网 Testimonials

官网 testimonials 段落中出现了一条让 HN 用户忍俊不禁的引用：

> "Of course, you can use it [LangChain], but whether it's really production-ready and improves the time from code-to-prod, we've been doing LLM apps for two years, and the answer is no. Honestly, take a look at Burr. Thank me later." — **Reddit User, Developer, `r/LocalLlama`**

这被 HN 用户视为 vibe coding 的自曝证据——连真实用户的 testimonial 都懒得找，直接从 Reddit 截图。

### 4. Builder + Decorator 风格争议——意外的语言战争

Burr 同时使用了 builder pattern（`.with_actions().with_transitions().build()`）和 decorator（`@action()`），这在 Python 社区引发了争议：

> "A builder pattern AND decorators. Yes, Python has decorators, but they're best used as 'filters' that apply to functions or methods. Cache this, serialize the output, prepare this function to be used as a tool — not registration, not flow control. FastAPI influenced the modern use of decorators far too much in the wrong direction." — tcdent
> （Builder pattern 加 decorator？Decorator 应该用作过滤器——缓存、序列化、标记为工具——而不是注册和流程控制。FastAPI 把 decorator 的用法带歪了。）

> "Builder patterns are a Rust convention, because Rust has no named keyword arguments. A Python function already exposes a named contract. There is very little reason to ever to sequentially pass configuration parameters in chained method calls." — tcdent
> （Builder pattern 是 Rust 的惯例——因为 Rust 没有命名关键字参数。Python 函数本身就有命名契约，几乎不需要链式调用来顺序传参。）

> "Builder pattern isn't only used in Rust, but I agree it's hideous to use in Python." — mkarrmann

> "I think of Java immediately when I hear Builder Pattern." — giancarlostoro

维护者 elijahbenizzy 辩护：

> "So decorators here specifically attach metadata to make a function a reusable component. Builder makes a workflow. In Hamilton it's all decorators because it's purely declarative construction."

### 5. Apache 孵化争议

> "First time I hear about Burr, curious why it was incubated in Apache. This is a crowded market now. They are still `0.42` after two years. What did apache find in the platform to get incubated?" — Oras
> （第一次听说 Burr，好奇为什么 Apache 会收它。这个市场太拥挤了。两年了还停留在 `0.42` 版本。Apache 看中了它什么？）

维护者之一 krawczstef 回答："Cause I submitted it. Learning the Apache process and cranking on other things has been a slow process. But we've got some momentum and beginning more regular releases."

另有用户不客气地指出：

> "Don't ask the why, ask the how. How did they get acceptance into incubation stage with what you just mentioned?" — ivanmontillam

> "The vibe coded landing page is really degrading Apache foundation image imo." — pixel_popping

### 6. `BPEL` 的历史回响

> "Unfortunately agent orchestration frameworks feels like the second coming of `BPEL`, and the incentives are all wrong." — pjmlp
> （Agent 编排框架感觉像是 `BPEL` 的转世，而且激励方向全错了。）

`BPEL` 是 2000 年代 `SOA` 时代的业务流程编排语言标准，最终被广泛认为是过度工程化的失败标准。这个类比击中了不少经历过那个时代的开发者。

### 7. Agent 的"卫生工具"——被忽视的工程痛点

> "The agent isn't the hard part — it's the orchestration, skills, research systems, adversarial reviews, dreaming/compounding, context management and all the rest. Plus all the annoying hygiene tools to 'poke the agent that got a clear prompt and decided to just sit there and wait for no good reason' and 'delete the remote branches that the prompt told all the agents to delete but some of them forgot to'" — peterbell_nyc
> （Agent 本身不难——难的是编排、技能、研究系统、对抗性审查、上下文管理。再加上那些烦人的"卫生工具"：戳一下那些收到了清楚指令却坐着不动的 agent、清理 prompt 要求清理但某些 agent 忘了删的远程分支。）

另一位用户从正面贡献了经验：

> "The most interesting evolution of my agent workflow over the past year is that I've dropped all the language gimmicks: I used to use particular emoji to mark parts of code as hints to the AI... That's all gone now: all my comments, directives, plans and so on are just plain and clear English, nothing more. It just works better that way." — chuckadams
> （过去一年我 agent 工作流中最有趣的演变是：我放弃了一切语言花招——用特定 emoji 标记代码段给 AI 看。现在我的注释、指令、计划都只是清晰直白的英语。效果反而更好。）

### 8. Burr 与 Hamilton 的命名故事

> "Right it was a bit of a joke. Originally stefan and I presented frameworks when we were at Stitch Fix — stefan called his 'hamilton' and I called mine 'burr'. His was better for the use-case. But then we wanted to build something for state machines as opposed to DAGs, so we called it Burr. I wanted the git tagline to be 'make your agents go burr...'" — elijahbenizzy（Burr 联合维护者）

（Aaron Burr 在历史决斗中杀死了 Alexander Hamilton——两个框架的命名恰好对应这对历史宿敌。）

---

## 典型观点一览

| 立场 | 代表用户 | 一句话 |
|------|---------|--------|
| 🟢 反框架 | brotchie | 为每个 agent 写 1:1 代码，框架抽象只会碍事 |
| 🟢 反框架 | kristjansson | 框架掩盖了核心逻辑——每个 agent 应用归根结底只是 token 序列 |
| 🔵 挺框架 | fxwin | 框架的价值在可观测性和工具链，不是写 agent |
| 🔵 挺框架 | tcdent | 用框架和用 API 客户端没有本质区别 |
| 🟡 折中 | vanuatu | 难的从来不是框架，而是上下文、工程和最后一公里 |
| 🟡 折中 | brotchie（自省） | 框架应该卖可观测性而不是 agent 代码 |
| 🔴 设计吐槽 | enragedcacti | 逐项点名了 8 个 performativeUI 组件 |
| 🔴 设计吐槽 | TZubiri / flakiness | 看了一眼就关掉了 |
| 🔴 设计吐槽 | vanuatu | "vibe coded landing page + reddit user testimonial + state machine" 三连 |
| ⚪ 语言战争 | tcdent | Builder + Decorator 在 Python 中丑陋 |
| ⚪ 历史纵深 | pjmlp | Agent 框架是 `BPEL` 转世 |
| ⚪ 工程实践 | chuckadams | 放弃语言花招后效果反而更好 |

---

## 总体情绪

讨论整体对 agent 框架持怀疑态度。**顶楼反框架获得最高分**，框架的护航者转而强调可观测性和部署工具才是真正价值。一个意外的共识是：Burr 本身并没有被深入讨论——**大家更多在辩论"要不要框架"这个元问题**，以及**吐槽官网设计**。项目维护者全程参与回应，态度开放但未能扭转舆论方向。

<div class="disclaimer">
**免责声明**：本文是对 Hacker News 用户讨论的编译与提炼，原文链接：<https://news.ycombinator.com/item?id=48477400>。文中所有观点均来自 HN 评论者，不代表本人立场。
</div>
