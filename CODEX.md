# CODEX.md — Using Claude Code Game Studios with Codex

This repository is a Codex-compatible adaptation layer for Claude Code Game Studios.

The original `.claude/` directory remains intact and is treated as source material. Codex uses `AGENTS.md`, `.codex/`, and `scripts/` to understand and emulate the same studio workflows.

## Quick Start

From the repository root:

```bash
bash scripts/codex-start.sh
bash scripts/codex-session-check.sh
codex
```

Inside Codex, start with:

```text
Read AGENTS.md, CLAUDE.md, and .codex/adapter-manifest.json. Then run the /start workflow in Codex-compatible mode.
```

## Running a Skill

Claude slash commands are mapped to Codex workflow prompts.

Example:

```bash
bash scripts/codex-run-skill.sh start
bash scripts/codex-run-skill.sh setup-engine godot 4.5
bash scripts/codex-run-skill.sh create-architecture
```

Then paste the emitted prompt into Codex, or tell Codex directly:

```text
Run /setup-engine godot 4.5 using the Codex adapter.
```

## Running an Agent Role

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

Codex should read the corresponding `.claude/agents/` definition before acting.

## Workflow Equivalence

Codex-compatible equivalents:

| Claude Code feature | Codex adapter equivalent |
|---|---|
| `CLAUDE.md` | `AGENTS.md` + `CODEX.md` + original `CLAUDE.md` |
| `.claude/agents/` | Codex role emulation through source agent prompts |
| `.claude/skills/` slash commands | `.codex/commands.md` + `scripts/codex-run-skill.sh` |
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
- Codex adapter files must live in `.codex/`, `scripts/`, `docs/`, `AGENTS.md`, or `CODEX.md`.
- Keep compatibility notes explicit.
- When changing a skill, also update `.codex/commands.md` if command behavior changes.
- When changing a hook, also update `.codex/hooks.md`.

## Commit Safety

Before committing adapter changes:

```bash
bash scripts/codex-session-check.sh
bash scripts/codex-validate-commit.sh
```

## Known Limitation

This adapter cannot make Codex natively support Claude Code-specific hook events, slash command UI, or subagent spawning. It provides prompt-level, file-level, and script-level compatibility so Codex can directly use the same workflows.