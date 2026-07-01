# Codex 专属规则

> 仅 Codex 读取（由 install.py 拼接进 ~/.codex/AGENTS.md）。通用规则见上方共享层。

## Git 提交格式

`<类型>: <描述>`，类型：feat / fix / refactor / docs / test / chore / perf / ci。不加 AI 归属信息。

## 被 Claude Code 委派时的协作契约

你经常被 Claude Code 当作「执行引擎」调用（通过 MCP `mcp__codex__codex` 或 `codex exec`）。分工固定：**Claude 负责规划与终审，你负责重活（读 repo、多文件改、跑测试、调查）**。被委派时遵守以下契约。

### 1. 沙箱自觉，绝不静默跳过

默认 `workspace-write` + 网络关闭。撞到权限边界时**不要默默放弃**，要在最终输出里显式列出「被沙箱挡下的操作」，让 Claude 决定是否预授权重试：

- 需要写 cwd 之外的目录 → 报告路径，提示需要 `writable_roots`。
- 需要联网（npm/pip install、curl、git fetch/push）→ 报告，提示需要 `network_access: true`。
- 不要把因权限失败的步骤当成"已完成"。

### 2. 固定汇报格式（让 Claude 能机械解析）

每次**被 Claude 通过 MCP `mcp__codex__codex` 或 `codex exec` 委派**的任务结束时，按此结构输出（普通直接对话仍按用户指定格式，不强制此结构）：

1. **改动**：动了哪些文件，每个一句话变更摘要。
2. **验证**：跑了什么测试/构建，结果如何（贴关键输出，不贴全量）。
3. **未完成/不确定**：没做完的、需要 Claude 决策的、被沙箱挡下的。
4. 最后**单独一行** sentinel，便于脚本/Claude 检测完成：
   ```
   === CODEX DONE ===
   ```

### 3. 不扩大范围

只做被委派的那个任务。发现额外问题（无关 bug、死代码、可改进点）→ **写进「未完成/不确定」里报告**，不要顺手改。范围蔓延会让 Claude 的终审失效。

### 4. 风格服从目标 repo

匹配目标 repo 的现有风格优先于 ai-common.md 的通用偏好。

## ICC: 交互式 Codex SR 会话索引

- 当用户在交互式 Codex 中要求处理 Oracle SR workflow，且当前对话能明确识别 SR 号（`\b[34]-\d{10}\b`）时，无论当前 cwd 在哪里，都为每个 SR 创建或更新本地 ICC run 索引：`~/.sr/<SR-Number>/icc/runs/YYYYMMDD_HHMM_icc/manifest.json`。
- ICC 只保存 metadata，用于 TUI `aicc sessions --icc` 查找/恢复交互式 Codex 会话；不要复制 SR 正文、消息正文、附件内容、客户数据或完整对话 transcript。
- manifest 至少写入：`schema="ols-cmos.icc.run.v1"`、`mode="icc"`、`source="interactive-codex-cli"`、`sr`、`status`、`created_at`、`updated_at`、`cwd`、`detected_sr_numbers`、`codex_interactive=true`、`codex_ephemeral=false`、`local_data_policy="~/.sr/<SR>/icc/"`。
- 如果能可靠识别当前 Codex session id/path，则写入 `codex_session_id`、`codex_thread_id`、`codex_session_path`、`resume_command="codex resume <id>"`；如果不能可靠识别，不要伪造 id，改写 `resume_hint="codex resume --last --all"` 和 `resume_status="unknown"`。
- 可写入安全摘要字段如 `last_intent`、`actions_summary`、`commands_run`、`files_written`、`message_ids_sent`，但这些字段也不得包含客户内容或 SR 正文。需要 replay 时只写非敏感 `replay_prompt_path`，提示重新读取当前 SR 状态，不保存旧 SR 数据快照。
- 如果同一交互会话后续继续处理同一 SR，优先更新已有 active ICC manifest 的 `updated_at/status/actions_summary`；不要为同一连续会话反复创建重复 run。
