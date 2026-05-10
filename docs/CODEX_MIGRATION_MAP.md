# Claude To Codex Migration Map

This map explains how the original Claude Code Game Studios files are used by
Codex.

## Root Entry Points

| Source | Codex use |
|---|---|
| `CLAUDE.md` | Original studio constitution and imported source docs |
| `AGENTS.md` | Codex operating rules and adapter boot sequence |
| `CODEX.md` | Human-facing usage guide |
| `.codex-plugin/plugin.json` | Codex plugin manifest |
| `skills/claude-game-studios/SKILL.md` | Installable Codex skill |

## Source Trees

| Source tree | Keep? | Codex handling |
|---|---:|---|
| `.claude/agents/` | yes | Read matching agent file before role emulation |
| `.claude/skills/` | yes | Read matching skill file before command emulation |
| `.claude/hooks/` | yes | Preserve as source behavior; map to manual scripts |
| `.claude/rules/` | yes | Read matching path rule before edits |
| `.claude/docs/` | yes | Workflow catalog, templates, standards, and phase docs |

## Adapter Trees

| Adapter path | Purpose |
|---|---|
| `.codex/adapter-manifest.json` | Machine-readable compatibility summary |
| `.codex/commands.md` | Human-readable command index |
| `.codex/hooks.md` | Hook behavior mapping |
| `.codex/skill-index.json` | Machine-readable 72-command index |
| `.codex/agent-index.json` | Machine-readable 49-role index |
| `scripts/codex-start.sh` | Session orientation |
| `scripts/codex-run-skill.sh` | Emits command workflow prompt |
| `scripts/codex-session-check.sh` | Adapter health check |
| `scripts/codex-validate-commit.sh` | Commit-time adapter validation |
| `scripts/codex-validate-assets.sh` | Asset naming and JSON check |

## Command Migration

Claude command:

```text
/setup-engine godot 4.5
```

Codex equivalent:

```text
Run /setup-engine godot 4.5 using the Codex adapter.
```

Codex then reads:

1. `skills/claude-game-studios/SKILL.md`
2. `.codex/skill-index.json`
3. `.claude/skills/setup-engine/SKILL.md`
4. `.claude/docs/workflow-catalog.yaml` if phase routing matters
5. Relevant `.claude/agents/*.md` files

## Role Migration

Claude subagent request:

```text
Use godot-specialist.
```

Codex equivalent:

```text
Act as godot-specialist. Read the source role file first.
```

Codex then reads `.claude/agents/godot-specialist.md` and follows that role's
responsibilities and boundaries.

## Hook Migration

| Claude hook | Codex equivalent |
|---|---|
| `SessionStart` | `bash scripts/codex-start.sh` and `bash scripts/codex-session-check.sh` |
| `PreToolUse` for commit/push | `bash scripts/codex-validate-commit.sh` |
| `PostToolUse` for assets | `bash scripts/codex-validate-assets.sh <path>` |
| `Notification` | no native equivalent; optional OS script only |
| `PreCompact` and `PostCompact` | manual session summary and `production/session-state/active.md` |
| `SubagentStart` and `SubagentStop` | role-use note in Codex summary |

## Validation Checklist

- The plugin manifest parses as JSON.
- The Codex skill has frontmatter and routing instructions.
- All 72 source command names are listed in `.codex/skill-index.json`.
- All 49 current source roles are listed in `.codex/agent-index.json`.
- `AGENTS.md` references only files that exist.
- `CODEX.md` quick-start commands exist.
- Scripts are POSIX shell and fail gracefully when optional tools are missing.
