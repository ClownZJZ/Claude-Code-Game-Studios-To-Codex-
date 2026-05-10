# CODEX.md - Using Claude Code Game Studios With Codex

This repository is a Codex-compatible adaptation layer for Claude Code Game
Studios.

The original `.claude/` directory remains intact and is treated as source
material. Codex uses `AGENTS.md`, `.codex/`, `.codex-plugin/`, `skills/`, and
`scripts/` to understand and emulate the same studio workflows.

## As A Codex Plugin

The repository includes:

- `.codex-plugin/plugin.json`
- `skills/claude-game-studios/SKILL.md`
- `assets/game-studios.svg`

When installed as a local Codex plugin, use the `claude-game-studios` skill for
all Game Studios workflows.

Starter prompts:

```text
Run /start using the Codex adapter.
Act as godot-specialist and review this project.
Create a sprint plan with Game Studios.
```

## Quick Start From A Repository

From the repository root on Windows / PowerShell:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/codex-start.ps1
powershell -ExecutionPolicy Bypass -File scripts/codex-session-check.ps1
codex
```

From the repository root on macOS/Linux or Git Bash:

```bash
bash scripts/codex-start.sh
bash scripts/codex-session-check.sh
codex
```

Inside Codex, start with:

```text
Read AGENTS.md, CLAUDE.md, and .codex/adapter-manifest.json. Then run the /start workflow in Codex-compatible mode.
```

## Running A Skill

Claude slash commands are mapped to Codex workflow prompts.

Example:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/codex-run-skill.ps1 start
powershell -ExecutionPolicy Bypass -File scripts/codex-run-skill.ps1 setup-engine godot 4.5
powershell -ExecutionPolicy Bypass -File scripts/codex-run-skill.ps1 create-architecture
```

Or with Bash:

```bash
bash scripts/codex-run-skill.sh start
bash scripts/codex-run-skill.sh setup-engine godot 4.5
bash scripts/codex-run-skill.sh create-architecture
```

Then paste the emitted prompt into Codex, or tell Codex directly:

```text
Run /setup-engine godot 4.5 using the Codex adapter.
```

Codex should route through `.codex/skill-index.json` and then read the matching
`.claude/skills/<command>/SKILL.md`.

## Running An Agent Role

Example prompts:

```text
Act as producer. Read the workflow catalog and tell me the next project phase.
```

```text
Act as godot-specialist. Review the Godot project setup and propose the smallest safe next step.
```

```text
Act as qa-lead. Create a smoke-check plan for the current vertical slice.
```

Codex should route through `.codex/agent-index.json`, then read the corresponding
`.claude/agents/<agent>.md` definition before acting.

## Workflow Equivalence

| Claude Code feature | Codex adapter equivalent |
|---|---|
| `CLAUDE.md` | `AGENTS.md` + `CODEX.md` + original `CLAUDE.md` |
| `.claude/agents/` | Codex role emulation through source agent prompts |
| `.claude/skills/` slash commands | `skills/claude-game-studios/SKILL.md`, `.codex/skill-index.json`, `.codex/commands.md`, and `scripts/codex-run-skill.sh` |
| `.claude/hooks/` automatic events | manual/wrapper scripts in `scripts/` |
| `.claude/settings.json` permissions | adapter safety policy in `AGENTS.md` |
| status line | `scripts/codex-start.sh` |
| subagent audit hooks | adapter documentation and optional session logs |

## Recommended Codex Prompt Prefix

Use this at the beginning of important sessions:

```text
You are operating inside the Codex adapter for Claude Code Game Studios. Read AGENTS.md first, then CLAUDE.md, then .codex/adapter-manifest.json. Preserve the original studio workflow semantics. Do not claim native Claude Code subagent/hook support. Use Codex-compatible role emulation and wrapper scripts.
```

## Development Rules

- Do not delete `.claude/`.
- Do not rename original Claude files unless explicitly requested.
- Codex adapter files must live in `.codex/`, `.codex-plugin/`, `skills/`,
`scripts/`, `docs/`, `AGENTS.md`, or `CODEX.md`.
- Keep compatibility notes explicit.
- When changing a skill, also update `.codex/commands.md` and
  `.codex/skill-index.json` if command behavior changes.
- When changing a role, also update `.codex/agent-index.json`.
- When changing a hook, also update `.codex/hooks.md`.

## Commit Safety

Before committing adapter changes:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/codex-session-check.ps1
powershell -ExecutionPolicy Bypass -File scripts/codex-validate-commit.ps1
```

Or with Bash:

```bash
bash scripts/codex-session-check.sh
bash scripts/codex-validate-commit.sh
```

## Known Limitation

This adapter cannot make Codex natively support Claude Code-specific hook events,
slash command UI, or Claude Code subagent spawning. It provides prompt-level,
file-level, plugin-level, and script-level compatibility so Codex can directly
use the same workflows.

## Full Manual

See `docs/CODEX_OPERATION_MANUAL.md` for the practical Chinese operating manual.
