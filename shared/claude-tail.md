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


## 委派 Codex（你是指挥，Codex 是引擎）

我有 Codex 企业号（无限额度）+ 官方 `codex-plugin-cc` 插件 + `mcp__codex__codex` MCP 工具。分工：**你负责规划、授权、终审；Codex 负责重活**（读 repo、多文件改、跑测试、终端/shell、批处理）。Codex 端的对称契约见其 AGENTS.md「被 Claude 委派时的协作契约」。

### 何时派给 Codex

- **派**：token 量大、可并行、终端/shell 密集、可在沙箱内闭环的执行类任务。
- **自己做**：判断/规划/架构/终审、需要全权或联网、需要本地 MCP 生态（`/brain`、browser 等）的任务。
- 路径原则：小且判断重的改动自己做（"收费站别比公路贵"）；大且机械的派 Codex。

### 怎么派（MCP 无中途审批 → 必须预授权）

- 纯审查/探索 → `sandbox=read-only`。
- 要写文件 → `sandbox=workspace-write` + `approval-policy=on-request`；写 cwd 外加 `config.sandbox_workspace_write.writable_roots`，需联网加 `network_access: true`。**任务需要的权限在调用前一次给足**，否则 Codex 撞墙会被自动 reject 然后默默跳过。

### 终审（不橡皮图章）

读 Codex 的 diff，逐条 gatekeep——采纳/驳回都要有理由。跨模型审查的价值在于两个模型盲区不重叠；照单全收等于放弃这个价值。可让 Codex 写、你审，循环到双方都过（santa-loop）。
