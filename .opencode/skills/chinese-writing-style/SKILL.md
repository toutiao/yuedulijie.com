---
name: chinese-writing-style
description: Chinese technical writing style guide for opencode agents
metadata:
  domain: content
  style: reference
---

## 1. Punctuation

| Scenario | Rule | Example |
|----------|------|---------|
| CN body quotes | fullwidth `""` | 他说："这是正确的。" |
| EN quotes inside CN | outer fullwidth, inner halfwidth | 他说："the term 'agent' means..." |
| em dash | fullwidth `——` | 主要原因——性能——已被解决 |
| ellipsis | fullwidth `……` | 还有更多…… |
| CN/EN mixed | space before/after EN | 使用 `agent` 工具 |
| numbers | halfwidth | 在 12 个项目中测试 |

## 2. Terminology

```
- Product/framework names: keep EN, capitalize
  Correct: Claude / LangChain / OpenAI / GitHub
  Wrong: 克劳德 / 语言链 / 开放AI

- Technical terms: keep EN, CN note optional on first use
  Correct: agent / prompt / LLM / PR
  Optional: agent (智能体) / prompt (提示词)

- General concepts: use CN
  Correct: 维护者 / 代码审查 / 开源项目
  Wrong: maintainer / code review / open source project

- Do NOT translate: proper names, brands, file extensions, versions
  Keep: .md / v2.0 / GPG / GitHub / Fedora
```

## 3. Tone

```
- Objective, no drama. No exclamation marks.
- No emotional words: 竟然 / 令人震惊 / 不得不
- Technical judgment: 未必 / 可能 / 通常 (not 肯定 / 绝对)
- Quote attribution: 表示 / 指出 / 认为 (not 声称 / 宣称)
- Max 5 lines per paragraph. Dense data -> lists/tables
```

## 4. Translation

```
- Meaning > literal
  EN: "LLM-generated justifications overwhelmed the maintainer"
  Good: "LLM 生成的论据把维护者淹没了"
  Bad: "LLM 生成的正当理由覆盖了维护者"

- EN puns/cultural references: keep original + CN note
  "run amok" (马来语借词, "发疯失控")

- Code/commands: keep original, do NOT translate
  `git push origin master` — 不译

### Post-quote discussion

Quote + translation 之后, 用你自己的话点一句:
- 这句为什么有意思? (洞察)
- 有没有例子/反例帮你理解? (通俗)
- 它指向什么更大的问题? (但不要强行上价值)

Three-layer structure:
Quote (信源) → Translation (能懂) → Discussion (秒懂)

规则: 如果想不到一句人话让读者"哦"一声, 就别写讨论段.
宁可没有, 也不要强行深刻. 通俗 > 深刻.

### Quote protection

Blockquote 内英文原文必须保持原样.
- 不得改写、润色、简化引文中的任何单词
- 不得对引文应用本 skill 的任何风格规则 (标点/术语/语气)
- 仅翻译行和讨论段落受本 skill 约束
- 引文作者原文是信源, 不可侵犯
```

## 5. Article Independence (Series Blindness)

```
- 禁止提及本系列其他文章. 无论通过标题、主题、对比、还是"如前文所述".
- Do NOT use: 前文 / 上篇 / 另一篇 / 本期 / 本系列 / 与本系列其他文章不同
- Do NOT reference other articles by name: DeepSeek, Burr, Fable, Fedora, etc.
- Do NOT compare current discussion to previous articles: "与XX不同", "与XX呼应"
- Each article must be fully readable as if no other articles in the series exist.
  → 如果某条信息不在本篇文章中交代清楚, 就是不独立.
- 背景信息每篇内部完整交代, 不依赖读者看过其他文章.
```

## 6. Reference Article (TBD)

```
Style reference: (to be determined)
```
