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

| Category | Rule | Correct | Wrong |
|----------|------|---------|-------|
| Product/framework names | Keep EN, capitalize | Claude, LangChain, OpenAI, GitHub | 克劳德, 语言链, 开放AI |
| Technical terms | Keep EN, optional CN note on first use | agent, prompt, LLM, PR | — |
| General concepts | Use CN | 维护者, 代码审查, 开源项目 | maintainer, code review, open source project |
| Proper names, brands, file extensions, versions | Keep original | .md, v2.0, GPG, GitHub, Fedora | — |

## 3. Tone

| Rule | Description |
|------|-------------|
| Objective, no drama | No exclamation marks |
| No emotional words | Avoid: 竟然, 令人震惊, 不得不 |
| Technical judgment | Use: 未必, 可能, 通常 (not: 肯定, 绝对) |
| Quote attribution | Use: 表示, 指出, 认为 (not: 声称, 宣称) |
| Paragraph length | Max 5 lines per paragraph. Dense data → lists/tables |

## 4. Translation

| Rule | Example |
|------|---------|
| Meaning > literal | EN: "LLM-generated justifications overwhelmed the maintainer" → CN: "LLM 生成的论据把维护者淹没了" (not "覆盖了") |
| EN puns/cultural references | Keep original + CN note: "run amok" (马来语借词, "发疯失控") |
| Code/commands | Keep original, do NOT translate: `git push origin master` |

### Post-quote discussion
After quote + translation, add a layer of insight. Three-layer structure:

`Quote (信源) → Translation (能懂) → Discussion (秒懂)`

Ask yourself:
- 这句为什么有意思? (洞察)
- 有没有例子/反例帮你理解? (通俗)
- 它指向什么更大的问题? (但不要强行上价值)

If you can't find a human take that makes the reader say "哦", skip the discussion.
通俗 > 深刻. 宁可没有, 也不要强行深刻.

### Quote protection
Blockquote 内英文原文必须保持原样:
- 不得改写、润色、简化引文中的任何单词
- 不得对引文应用本 skill 的任何风格规则 (标点/术语/语气)
- 仅翻译行和讨论段落受本 skill 约束
- 引文作者原文是信源, 不可侵犯

## 5. Article Independence (Series Blindness)

| Rule | Example |
|------|---------|
| No cross-references to other articles in series | 禁止: 前文, 上篇, 另一篇, 本期, 本系列 |
| No comparisons between articles | 禁止: 与XX不同, 与XX呼应 |
| No named references to other articles | 禁止: DeepSeek, Burr, Fable, Fedora (as article references) |
| Each article fully readable standalone | 如果某条信息不在本篇文章中交代清楚, 就是不独立 |
| Background context complete per article | 背景信息每篇内部完整交代, 不依赖读者看过其他文章 |
