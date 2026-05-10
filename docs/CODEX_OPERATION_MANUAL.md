# Claude Code Game Studios To Codex 操作手册

本手册说明如何在 Codex 中使用这个从 Claude Code Game Studios 移植来的项目。

## 1. 这个适配层解决什么问题

原项目为 Claude Code 设计，核心资产在 `.claude/`：

- `.claude/agents/`：49 个工作室角色
- `.claude/skills/`：72 个 slash-command 工作流
- `.claude/hooks/`：12 个 Claude Code hook 脚本
- `.claude/rules/`：11 组路径规则
- `.claude/docs/`：流程目录、模板、工程偏好和引擎参考

Codex 不能原生执行 Claude Code 的 slash command UI、Task 子代理、hook 事件和 status line。本适配层把这些能力映射为 Codex 可读取和可执行的形式：

- `.codex-plugin/plugin.json`：Codex 插件入口
- `skills/claude-game-studios/SKILL.md`：Codex skill 入口
- `.codex/skill-index.json`：72 个工作流索引
- `.codex/agent-index.json`：49 个角色索引
- `scripts/*.ps1`：Windows / PowerShell 可运行脚本
- `scripts/*.sh`：Git Bash、macOS、Linux 可运行脚本

## 2. 推荐运行环境

Windows / Codex Desktop 推荐使用 PowerShell：

```powershell
powershell -ExecutionPolicy Bypass -File scripts/codex-start.ps1
powershell -ExecutionPolicy Bypass -File scripts/codex-session-check.ps1
```

如果你使用 Git Bash、macOS 或 Linux，可以使用 Bash 版本：

```bash
bash scripts/codex-start.sh
bash scripts/codex-session-check.sh
```

注意：Windows 自带的 `bash.exe` 可能会跳到 WSL。如果没有安装 WSL 发行版，Bash 命令会失败。此时直接使用 `.ps1` 脚本即可。

## 3. 第一次启动

在仓库根目录运行：

```powershell
powershell -ExecutionPolicy Bypass -File scripts/codex-start.ps1
powershell -ExecutionPolicy Bypass -File scripts/codex-session-check.ps1
```

然后在 Codex 中输入：

```text
Read AGENTS.md, CLAUDE.md, and .codex/adapter-manifest.json. Then run /start using the Codex adapter.
```

Codex 应该按顺序读取：

1. `AGENTS.md`
2. `CLAUDE.md`
3. `.codex/adapter-manifest.json`
4. `skills/claude-game-studios/SKILL.md`
5. `.codex/skill-index.json`
6. 对应的 `.claude/skills/<command>/SKILL.md`

## 4. 使用 slash command 工作流

Claude 原命令：

```text
/setup-engine godot 4.5
```

Codex 中输入：

```text
Run /setup-engine godot 4.5 using the Codex adapter.
```

也可以先生成提示词：

```powershell
powershell -ExecutionPolicy Bypass -File scripts/codex-run-skill.ps1 setup-engine godot 4.5
```

常用命令：

```text
Run /start using the Codex adapter.
Run /brainstorm open using the Codex adapter.
Run /setup-engine godot 4.5 using the Codex adapter.
Run /create-architecture using the Codex adapter.
Run /dev-story production/epics/<epic>/<story>.md using the Codex adapter.
Run /code-review src/... using the Codex adapter.
Run /story-done production/epics/<epic>/<story>.md using the Codex adapter.
```

## 5. 使用工作室角色

Claude Code 原本通过子代理执行角色。Codex 中使用角色模拟：

```text
Act as producer. Read .codex/agent-index.json and the source role file first.
```

```text
Act as godot-specialist. Review the Godot setup and propose the smallest safe next step.
```

Codex 必须读取对应源文件，例如：

```text
.claude/agents/producer.md
.claude/agents/godot-specialist.md
```

不要声称 Codex 原生支持 Claude Code 子代理。需要并行代理时，只有在当前 Codex 环境显式支持并且用户要求时，才使用 Codex 自己的代理能力。

## 6. 提交前检查

提交前运行：

```powershell
powershell -ExecutionPolicy Bypass -File scripts/codex-session-check.ps1
powershell -ExecutionPolicy Bypass -File scripts/codex-validate-commit.ps1
```

如果改了资源文件，可以单独检查：

```powershell
powershell -ExecutionPolicy Bypass -File scripts/codex-validate-assets.ps1 assets/game-studios.svg
```

## 7. 适配层健康标准

`codex-session-check.ps1` 应该确认：

- `AGENTS.md` 存在
- `CODEX.md` 存在
- `CLAUDE.md` 存在
- `.codex-plugin/plugin.json` 存在且 JSON 可解析
- `skills/claude-game-studios/SKILL.md` 存在
- `.codex/skill-index.json` 中有 72 个工作流
- `.codex/agent-index.json` 中有 49 个角色
- `.claude/skills`、`.claude/agents`、`.claude/hooks`、`.claude/rules` 都存在

## 8. 限制说明

这个适配层让 Codex 能完整使用原工作流，但不会让 Codex 获得 Claude Code-only runtime：

- 没有原生 Claude slash command UI
- 没有原生 Claude Task 子代理
- 没有原生 Claude hook event
- 没有原生 Claude status line

遇到这些功能时，Codex 应该说明限制，并使用本适配层的文件、脚本和角色模拟方式完成同等流程。

## 9. 推荐工作流

新项目：

```text
Run /start using the Codex adapter.
Run /brainstorm open using the Codex adapter.
Run /setup-engine godot 4.5 using the Codex adapter.
Run /map-systems using the Codex adapter.
Run /design-system using the Codex adapter.
Run /create-architecture using the Codex adapter.
```

已有项目：

```text
Run /project-stage-detect using the Codex adapter.
Run /adopt using the Codex adapter.
Run /setup-engine godot 4.5 using the Codex adapter.
Run /gate-check using the Codex adapter.
```

生产开发：

```text
Run /sprint-plan using the Codex adapter.
Run /story-readiness <story-path> using the Codex adapter.
Run /dev-story <story-path> using the Codex adapter.
Run /code-review <changed-files> using the Codex adapter.
Run /story-done <story-path> using the Codex adapter.
```
