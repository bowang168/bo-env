# Claude 专属规则

> 仅 Claude Code 读取。通用规则见 ai-common.md（由 CLAUDE.md 一并 import）。

## 文字快捷替换

以下是我常用的 macOS Text Replacement 缩写，在对话中出现时按展开内容理解：

| Shortcut | 含义 |
|----------|------|
| `exp12` | explain as I am year 12 |

## 知识库 (按需加载)

> **搜索优先级: 本地 Qdrant 先于 WebSearch。任何问题如果可能在知识库中有答案，必须先 Qdrant 搜索，不够再 WebSearch 补充。禁止跳过本地知识库直接 web 搜索。**

### 个人信息查询 → `/brain` skill

个人数据搜索已封装为 skill，触发 `/brain` 或 Claude 自动识别个人信息问题时加载。

### 服务前提

Qdrant Local Mode (每个项目 DB 在自己 repo 内, 无 Docker) + Ollama qwen3-embedding:0.6b + BM25 (jieba)。
搜索默认 hybrid 模式 (语义+关键词 RRF 融合)。Ollama 未启动时提醒用户启动，或直接读文件。
