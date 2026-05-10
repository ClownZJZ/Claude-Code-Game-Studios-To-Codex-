# Codex Compatibility

This repository preserves Claude Code Game Studios for Codex at the workflow,
instruction, and documentation level.

## What Works In Codex

- Studio role emulation from `.claude/agents/*.md`
- Slash-command workflow emulation from `.claude/skills/*/SKILL.md`
- Phase routing from `.claude/docs/workflow-catalog.yaml`
- Path-scoped rule lookup from `.claude/rules/`
- Template reuse from `.claude/docs/templates/`
- Manual hook equivalents through `scripts/codex-*.sh`
- Plugin discovery through `.codex-plugin/plugin.json`
- Codex skill discovery through `skills/claude-game-studios/SKILL.md`

## What Is Not Native In Codex

Codex does not natively provide Claude Code's:

- slash-command registry UI
- Claude `Task` subagent runtime
- Claude hook events such as `SessionStart` or `PostToolUse`
- Claude `statusLine` runtime
- Claude settings permission engine

The adapter must not pretend those features are native. It maps their intent to
Codex-readable files, wrapper scripts, and explicit session behavior.

## Honest Equivalents

| Claude Code feature | Codex adapter equivalent |
|---|---|
| `CLAUDE.md` | `AGENTS.md`, `CODEX.md`, and original `CLAUDE.md` |
| `.claude/agents/*.md` | Role emulation after reading the source agent file |
| `.claude/skills/*/SKILL.md` | Workflow emulation through the plugin skill and `scripts/codex-run-skill.sh` |
| `.claude/hooks/*.sh` | Manual wrappers in `scripts/codex-*.sh` |
| `.claude/settings.json` | Safety guidance in `AGENTS.md` plus manual validation |
| `.claude/docs/workflow-catalog.yaml` | Phase routing source of truth |
| `.claude/rules/*.md` | Path-scoped rule checks before edits |

## Minimum Files For A Healthy Adapter

- `AGENTS.md`
- `CODEX.md`
- `CLAUDE.md`
- `.codex/adapter-manifest.json`
- `.codex/commands.md`
- `.codex/hooks.md`
- `.codex/skill-index.json`
- `.codex/agent-index.json`
- `.codex-plugin/plugin.json`
- `skills/claude-game-studios/SKILL.md`
- `scripts/codex-start.sh`
- `scripts/codex-run-skill.sh`
- `scripts/codex-session-check.sh`
- `scripts/codex-validate-commit.sh`
- `scripts/codex-validate-assets.sh`

Run:

```bash
bash scripts/codex-session-check.sh
```

## Operating Rule

When exact runtime behavior is impossible, Codex should say so briefly and use
the documented equivalent. The goal is full practical use, not inaccurate
feature claims.
