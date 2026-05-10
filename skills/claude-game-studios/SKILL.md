---
name: claude-game-studios
description: Use when the user wants to run Claude Code Game Studios inside Codex, including /start, /setup-engine, /dev-story, /code-review, studio role emulation, game design workflows, engine specialist guidance, or adapter validation.
---

# Claude Game Studios For Codex

This skill is the Codex entry point for the full Claude Code Game Studios
template. The original `.claude/` tree remains the source of truth. This skill
loads the right original agent, skill, hook, rule, or template files and applies
them through Codex-compatible workflows.

## Required Boot Order

When this skill is triggered:

1. Read `AGENTS.md`.
2. Read `CODEX.md`.
3. Read `CLAUDE.md`.
4. Read `.codex/adapter-manifest.json`.
5. Read `.codex/skill-index.json` and `.codex/agent-index.json` only when
   routing commands or roles.
6. Read only the specific `.claude/` files needed for the current task.

Do not bulk-load all agents or all skills. Keep context focused.

## Supported Requests

Handle these as first-class Codex workflows:

- `Run /start`
- `Run /setup-engine godot 4.5`
- `Run /dev-story production/epics/...`
- `Run /code-review src/...`
- `Act as producer`
- `Act as godot-specialist`
- `Use the team-ui workflow`
- `Check whether this project is ready for Codex`

## Slash Command Routing

When the user invokes a Claude slash command:

1. Normalize `/command-name` to `command-name`.
2. Look it up in `.codex/skill-index.json`.
3. Read `.claude/skills/<command-name>/SKILL.md`.
4. Read `.claude/docs/workflow-catalog.yaml` if the command affects phase or
   next-step routing.
5. If the source skill declares an `agent:` or describes delegation, read the
   matching `.claude/agents/<agent-name>.md` files.
6. Execute the workflow interactively in Codex.

Codex does not have Claude Code's native slash command UI. Be honest: this is
workflow emulation using the original source instructions.

## Studio Role Routing

When the user asks for a role:

1. Normalize the role to the closest `name` in `.codex/agent-index.json`.
2. Read `.claude/agents/<agent-name>.md`.
3. Adopt that role's responsibilities, boundaries, and escalation rules.
4. Do not claim to have spawned a native Claude Code subagent.

If Codex subagents are explicitly requested in the active Codex environment,
use Codex's native delegation tools according to the current system policy.
Otherwise, emulate the role directly in the main session.

## Hook Equivalents

Claude Code hooks are not automatic in Codex. Use the adapter wrappers:

- Session orientation on Windows: `powershell -ExecutionPolicy Bypass -File scripts/codex-start.ps1`
- Readiness check on Windows: `powershell -ExecutionPolicy Bypass -File scripts/codex-session-check.ps1`
- Commit validation on Windows: `powershell -ExecutionPolicy Bypass -File scripts/codex-validate-commit.ps1`
- Asset validation on Windows: `powershell -ExecutionPolicy Bypass -File scripts/codex-validate-assets.ps1 <path>`
- Bash equivalents: `bash scripts/codex-start.sh`, `bash scripts/codex-session-check.sh`, `bash scripts/codex-validate-commit.sh`, `bash scripts/codex-validate-assets.sh <path>`

Read `.codex/hooks.md` before changing hook behavior.

## Path-Scoped Rule Handling

Before editing:

1. Infer the file domain from the target path.
2. Read the matching `.claude/rules/` file when present.
3. Keep edits scoped to the requested workflow.
4. Preserve the original collaborative protocol from `CLAUDE.md`.

Common domains:

- `src/gameplay/**`
- `src/core/**`
- `src/ai/**`
- `src/networking/**`
- `src/ui/**`
- `design/gdd/**`
- `tests/**`
- `assets/**`
- `prototypes/**`
- `.claude/skills/**`
- `.codex/**`

## Collaboration Contract

Preserve the original "user-driven collaboration" model:

1. Ask when direction is ambiguous.
2. Offer 2-4 options for design decisions.
3. Let the user decide.
4. Draft before large writes.
5. Ask before writing unless the user already explicitly requested the exact
   edit.
6. Never commit unless explicitly asked.

## Output

For command workflows, report:

- command invoked
- source skill files read
- relevant agent files read
- current phase or context
- proposed action
- files to create or edit
- validation steps

For implementation work, end with changed files, tests or checks run, and any
remaining risk.
