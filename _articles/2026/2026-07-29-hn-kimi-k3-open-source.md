---
layout: post
title: "Kimi K3 开源发布 — 3T 权重开放、架构详解与社区热议"
date: 2026-07-29
categories: [articles]
excerpt: >-
  Moonshot AI 如期开放 Kimi K3 权重，2.8T 参数、104B 激活、MXFP4 原生量化。HN 热议托管成本、本地运行可行性，以及 NoPE 架构是否在悄悄改写注意力机制规则。
tagline: >-
  首个 3T 级开源权重模型降临 HuggingFace，社区为 1.5TB VRAM 的托管成本和那个没有位置编码的注意力机制吵翻了。
---
Moonshot AI 于 7 月 27 日将 Kimi K3 权重上传至 HuggingFace，兑现了此前"7 月 27 日前开放"的承诺。Kimi K3 是一个 2.8T 总参数（104B 激活参数）的 MoE 模型，采用 16/896 专家路由策略，架构上使用 Kimi Delta Attention (KDA) 与 Attention Residuals，并在所有层中完全移除 RoPE，改用 NoPE（无位置嵌入）。模型支持原生多模态（文本+图像）和 100 万 token 上下文窗口，权重采用 MXFP4 量化感知训练。

这是首个达到前沿水平的开源 3T 级模型。根据其自报基准，K3 在多数测试中与 Claude Opus 4.8 和 GPT-5.5 处于同一梯队，部分 agent 类基准（如 BrowseComp、MCPMark-Verified）甚至超过 Claude Fable 5。权重发布当天即获得 8,000+ HuggingFace 赞和 1,366 个 HN 积分，成为当日 HN 最热话题。

伴随权重发布的还有全套开源基础设施：MoonEP（专家并行框架）、FlashKDA（KDA 的高效 Triton 实现）以及 AgentEnv（agent 评估环境）。技术报告和 Sebastian Raschka 的架构详解同时引爆了第二轮深度讨论。

## 托管一个 3T 模型要花多少钱

Kimi K3 的开放让社区第一次有机会估算"托管一个 3T 模型到底贵不贵"。

> "First, depending on where the median pricing settles w/ 3rd party providers will tell us what it costs to serve a 3T model. Since it's going to be mxfp4 native, it'll take ~1.5TB of VRAM to host this, which is juuust at the limit of 8xb200s (but realistically you'll need 16x for context / throughput optimisation)." — NitpickLawyer

> （首先，第三方提供商的中位定价会告诉我们托管一个 3T 模型的成本。由于它原生使用 MXFP4，托管需要约 1.5TB 显存，刚好在 8×B200 的极限上——但实际上需要 16× 才能优化上下文和吞吐量。）

NitpickLawyer 进一步指出，通过第三方托管价格可以反推实验室是否在"补贴 API 定价"。对此，dist-epoch 引用了 SemiAnalysis 的数据：Anthropic 当前混合毛利率已升至 60% 以上，API 业务毛利率超过 80%。

但 vb-8448 泼了一盆冷水：

> "No, you don't. Without training cost you can infer only the marginal cost of serving this kind of models. Moreover, you don't know the actual size of closed models (what if Fable is a 10T model? What if it's 1T?)" — vb-8448

> （不，你不能。没有训练成本，你只能推断出这类模型的边际服务成本。而且你根本不知道闭源模型的实际大小——万一 Fable 是 10T 呢？万一它只有 1T 呢？）

这引出了一个更深的问题：推理成本本身也在迅速与训练成本纠缠。NitpickLawyer 解释说，当今模型的进步主要来自 RL，而 RL 的推理算力需求是训练的约 7 倍（按单位算力计）。因此，推理效率直接决定了训练成本。

SemiAnalysis 的数据和 OpenAI 泄露的财务信息表明，顶级实验室在纯推理上是盈利的，但加上训练成本就亏了。lel anthran 的总结很到位："知道实验室在推理上是否边际盈利仍然有用——如果不盈利，我们可以预期大幅涨价；如果盈利，涨价可能不会那么剧烈。"

## CPU 内存运行：可行但有多实用？

walrus01 提出了一个非主流的方案——用二手服务器 + 3TB 内存跑 K3：

> "It will be very interesting to see what kind of 'slow' performance people get from running it on a no GPU, but tons of RAM server (like a dual or quad socket xeon with 1.5 to 3TB of RAM). Even if the output is like 5-6 tok/s, that might be usable for some purposes." — walrus01

> （看看在没有 GPU、只有海量内存的服务器上跑它会有多"慢"会很有趣。即使输出只有 5-6 tok/s，对某些用途来说也可能是可用的。）

他指出，一套二手 4U 机架服务器加 3TB 内存（64GB DIMM × 32）的成本不到 $30,000，远低于 GPU 方案。但他的电费只有 $0.075/kWh，月运行成本约 $48。

fooker 立即反驳：

> "You'll spend ~100x more on electricity than the API cost to have it run on someone else's GPU at several hundred tokens per second." — fooker

> （你花的电费是 API 调用成本的 100 倍，而 API 在别人的 GPU 上每秒能跑几百个 token。）

这引发了关于"什么时候值得本地跑大模型"的辩论。数据主权被反复提及——对于非美国公司来说，将数据发送到美国云服务商可能不是选项。

> "for anyone not US-based, this company is hostile and you have to assume the US government can and will force them to give access to your data." — well_ackshually

> （对于任何非美国用户来说，这家公司是敌对的，你必须假设美国政府可以且会强迫他们交出你的数据。）

Sanzig 的立场更直接："I am in Canada. I cannot legally host defence workloads in the United States, even if I wanted to."

frognumber 则从商业规模角度补充：万亿美元的大公司可以花钱买隐私，但预算只有 $100 万的初创公司连 OpenAI 的电话都打不通。开源权重恰好填补了这个中间地带——允许在认证过的第三方提供商、本地租赁等方案中选择。

## 开源权重：加速还是减速 AI？

随着 K3 权重开放，关于开源模型生态影响的争论自然升温。

m_ke 的评论一针见血：

> "Anyone who claims open source and open weights models are 'decel' needs to get their head checked" — m_ke

> （任何声称开源/开放权重模型是"减速"的人都该去查查脑子。）

他同时列出了 Moonshot AI 一并开源的基础设施：MoonEP（专家并行）、AgentEnv（agent 评估环境）和 FlashKDA（KDA 的 Triton 实现）。

StevenWaterman 提出了一个逻辑链：开源权重 → 推理竞争加剧 → 推理利润下降 → 训练投入减少。但 reissbaker 用历史事实反驳：

> "Anthropic couldn't ship a reasoning model until they copied DeepSeek R1's homework, and they've all copied DS-style super-sparse MoEs at this point too." — reissbaker

> （Anthropic 在抄 DeepSeek R1 的作业之前根本做不出推理模型，而且现在所有实验室都抄了 DeepSeek 式超稀疏 MoE。）

Smaug123 则持中间立场：如果世界观的预设是"大部分进步来自闭源实验室，开源只是快速跟进"，那么打压闭源实验室确实会减缓整体进步。但如果像 reissbaker 指出的那样，Anthropic 自己在关键创新上也是跟进者，这个预设就不成立了。

## NoPE 与 KDA：架构创新的争议

Sebastian Raschka 的架构详解贴获得大量关注。他指出了 Kimi K3 最引人注目的设计选择：完全移除 RoPE，在所有层中使用 NoPE（无位置嵌入）。

> "This is the first frontier-level one [that uses NoPE everywhere] as far as I know." — Sebastian Raschka

> （据我所知，这是第一个在所有层使用 NoPE 的前沿模型。）

gokohl 对此评论：

> "Interesting that they went NoPE everywhere — everyone else hedges with RoPE in the local layers. Feels like the linear-attention stuff (Kimi Delta) is quietly doing the positional work so they can get away with it." — gokohl

> （有意思的是他们在所有层都用 NoPE——其他每个人都在局部层用 RoPE 来对冲。感觉是线性注意力机制（KDA）在悄悄完成位置编码的工作，所以他们才能这么干。）

thunderbird120 从技术角度详细解释了为什么 KDA 不需要 RoPE：

> "Kimi Delta Attention (KDA)... isn't really attention at all in any conventional sense. It's more like an RNN which can be efficiently parallelized during training... Because it's RNN-like, it has an inherent idea that X comes before Y which comes before Z in the sequence XYZ. Transformers, by default, don't have that." — thunderbird120

> （KDA 从任何传统意义上讲都不是真正的注意力机制。它更像是一个可以在训练时高效并行化的 RNN……因为它是 RNN 式的，它天生就知道序列中 X 在 Y 前、Y 在 Z 前的顺序关系。而 Transformer 默认没有这个能力。）

但 Ilaurens 表达了困惑：

> "It just baffles me that this even works at all. Doesn't it just become a token soup?" — Ilaurens

> （这居然能工作，真让我困惑。它不会变成一锅 token 汤吗？）

这也解释了为什么 KDA 层的 KV-cache 实现会出现奇怪的"1024 token 对齐"问题。samuelknight 指出，在某些推理提供商那里，KDA 需要固定增量 token 块（1024 个），每次 cache miss 会导致最多 1023 个额外输入 token——这是线性注意力在工程化过程中的典型代价。

## 微调一个 3T 模型的现实

woctordho 讨论了低 VRAM 微调 MoE 模型的现状：

> "Speaking of finetune, currently a common practice is LoRA over bnb 4-bit base model, but I think it's time to replace bnb with GGUF as the base model format." — woctordho

> （说到微调，目前的常见做法是在 bnb 4-bit 基座模型上用 LoRA，但我认为该用 GGUF 替代 bnb 作为基座模型格式了。）

他指出 bnb 尚未找到对 MoE 进行足够精度量化的方法，而 GGUF 社区已经为 MoE 开发了 APEX quant 等方案。他用 Qwen3.5-35B-A3B 在 16 GiB VRAM 上成功微调，DeepSeek-V4-Flash（284B-A13B）在 90 GiB VRAM 上完成。但 K3 这样的 2.8T 模型仍然需要多机多卡。

关于 Cursor 等产品是否在微调 K3，qeternity 认为："It's incredibly unlikely that they have trained a QLoRA for Composer. It's almost certainly full parameter post training of the original model weights."

## 典型观点一览

| 立场 | 用户 | 一句话 |
|------|------|--------|
| 价格透明乐观 | NitpickLawyer | 第三方托管价格可以反推实验室是否在补贴 API 定价 |
| 成本估算有限 | vb-8448 | 没有训练成本数据，你只能推断边际推理成本 |
| CPU 运行务实 | walrus01 | $30K 二手服务器 + 3TB 内存 —— 慢但可用，且数据主权完整 |
| CPU 运行不经济 | fooker | 电费是 API 调用成本的 100 倍 |
| 开源是加速 | m_ke/reissbaker | 闭源实验室在关键创新上也是跟进者，开源推动整个行业 |
| 开源可能减速 | Sma123 | 如果进步主要来自闭源实验室，打垮它们会减缓整体进展 |
| NoPE 可行 | thunderbird120 | KDA 本质是 RNN，天生有顺序感，不需要 RoPE |
| NoPE 工程代价 | samuelknight | 1024 token 对齐的 cache miss 问题增加了推理延迟 |

## 总体情绪

HN 社区对 Kimi K3 的开源发布几乎一致正面——毕竟这是一次"说到做到"的权重开放，而且开源了全套基础设施。但讨论的重心已经从"它强不强"转向了"它贵不贵"和"谁能真正用得起"。

围绕托管成本的争论展示了社区的成熟：没有人被"3T 级开源模型"这个标签吓住，而是迅速进入成本结构分析——VRAM 需求、推理效率、训练与推理的算力分配。这也反映了 AI 行业正在从"模型能力竞赛"进入"落地运营竞赛"阶段。

与此同时，NoPE 架构的成功验证可能被低估了。如果线性注意力机制（KDA 及其后继者）能够在前沿规模上替代 Softmax Attention 而不需要位置编码，这可能是 Transformer 架构自诞生以来最根本的简化之一。当然，工程代价（1024 token 对齐的 KV-cache 实现）说明这条路还没走完。

最后，数据主权和开源生态的讨论暗示了一个更大的趋势：随着中美科技脱钩加深和美国云服务商的信任度下降，开源权重模型正在成为全球 AI 基础设施的"通用货币"——不是最快的，但可能是最多人用得起的。

## 引用帖子

| # | 标题 | URL |
|---|------|-----|
| 1 | Kimi-K3 on HuggingFace | https://news.ycombinator.com/item?id=49065752 |
| 2 | Kimi-K3 Technical Report [pdf] | https://news.ycombinator.com/item?id=49070985 |
| 3 | Kimi K3 Architecture Overview and Notes | https://news.ycombinator.com/item?id=49085698 |
| 4 | Kimi Linear: An Expressive, Efficient Attention Architecture | https://news.ycombinator.com/item?id=49082022 |
| 5 | A walk through of the DeltaNet family of linear attention variants | https://news.ycombinator.com/item?id=49085909 |

<div class="disclaimer">
本摘要基于 HN 讨论帖 <a href="https://news.ycombinator.com/item?id=49065752">Kimi-K3 on HuggingFace</a> 及多篇相关文章的讨论内容编译整理，不代表本网站立场。讨论内容版权归原作者所有。摘要内容仅反映 HN 社区观点，不构成任何投资或技术选型建议。
<br><br><em>本摘要由 AI 模型辅助生成：deepseek/deepseek-v4-flash</em>
</div>
