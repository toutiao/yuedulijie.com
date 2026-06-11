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
```

## 5. Article Independence

```
- Each article self-contained. No cross-references to other articles in series.
- Never use: 如前文所述 / 在上一篇中 / 与之前的 XX 不同
- Do not assume reader has read other articles in series
- Background info fully explained within each article
```

## 6. Reference Article (TBD)

```
Style reference: (to be determined)
```
