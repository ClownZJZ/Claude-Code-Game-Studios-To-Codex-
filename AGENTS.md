# AGENTS.md — Codex Adapter for Claude Code Game Studios

This repository originally targets Claude Code. This file is the Codex-compatible entry point.

Codex must treat the existing `.claude/` tree as the source-of-truth studio template and this file as the compatibility layer that explains how to use it from Codex.

## Compatibility Goal

Preserve the complete studio workflow semantics:

- 49 specialized studio agents
- 72 skill / command workflows
- 12 hook behaviors
- 11 path-scoped rule groups
- 39 document templates
- collaborative review protocol
- game development phase gates
- engine specialist workflows for Godot, Unity, and Unreal

Codex cannot natively execute Claude Code subagents, slash commands, status lines, or hook events. Therefore this adapter preserves the same responsibilities, prompts, quality gates, and workflow order through Codex-readable instructions, wrapper scripts, and command templates.

## Source of Truth

Use these original files first:

- `CLAUDE.md` — original master configuration
- `.claude/settings.json` — original Claude hook and permission policy
- `.claude/agents/` — original agent definitions
- `.claude/skills/` — original skill / slash command workflows
- `.claude/hooks/` — original hook scripts
- `.claude/rules/` — original path-scoped coding rules
- `.claude/docs/workflow-catalog.yaml` — original phase workflow catalog
- `.claude/docs/templates/` — original documentation templates

Use these Codex adapter files second:

- `CODEX.md` — human-facing Codex usage guide
- `.codex/adapter-manifest.json` — machine-readable mapping from Claude concepts to Codex concepts
- `.codex/commands.md` — Codex command/skill invocation index
- `.codex/hooks.md` — hook behavior mapping
- `scripts/codex-start.sh` — session-start orientation script
- `scripts/codex-run-skill.sh` — skill prompt loader for Codex sessions
- `scripts/codex-session-check.sh` — repository readiness check
- `scripts/codex-validate-commit.sh` — commit safety check wrapper
- `docs/CODEX_COMPATIBILITY.md` — compatibility notes and limits
- `docs/CODEX_MIGRATION_MAP.md` — Claude-to-Codex mapping

## Codex Operating Protocol

Every Codex session must follow this order:

1. Read `AGENTS.md`.
2. Read `CLAUDE.md`.
3. Read `.codex/adapter-manifest.json`.
4. If the user invokes a command-like workflow, read `.codex/commands.md` and the matching `.claude/skills/<skill>/` content.
5. If editing files, read any matching `.claude/rules/` path-scoped rule.
6. Before edits, present the intended files and smallest safe change.
7. Do not write or commit without explicit user approval.
8. After edits, summarize changes, test steps, risks, and next step.

## Collaboration Protocol

The original project requires user-driven collaboration, not autonomous execution. Codex must preserve this protocol:

1. Ask clarifying questions only when necessary.
2. Present 2–4 options when design direction is ambiguous.
3. Let the user decide.
4. Draft the change.
5. Ask approval before writing files.
6. Never commit unless explicitly requested.

## Agent Emulation

Codex must emulate agents by role selection, not by claiming to spawn real Claude subagents.

When the user says:

```text
Act as gameplay-programmer
Act as producer
Run /start
Run /design-system
Use the Godot specialist
```

Codex must:

1. Find the corresponding agent or skill under `.claude/`.
2. Read its instructions.
3. Adopt that role for the current response.
4. Respect escalation and domain boundaries from the original studio hierarchy.

## Slash Command Emulation

Claude slash commands are not native Codex commands. Treat them as workflow names.

Examples:

```text
/start
/brainstorm
/setup-engine godot 4.5
/create-architecture
/dev-story production/epics/core/STORY.md
/code-review
/story-done
```

Codex must translate these into:

1. Read matching `.claude/skills/<command>/`.
2. Read `.claude/docs/workflow-catalog.yaml` when command relates to project phase.
3. Execute the workflow interactively through normal Codex reasoning.
4. Ask before writing any artifact.

## Hook Emulation

Claude Code hooks are not automatic in Codex. Codex must emulate their intent manually or via scripts.

Before commits:

```bash
bash scripts/codex-validate-commit.sh
```

At session start:

```bash
bash scripts/codex-start.sh
bash scripts/codex-session-check.sh
```

When editing assets:

```bash
bash scripts/codex-validate-assets.sh <changed-file>
```

## Safety Rules

Codex must not run or propose dangerous commands unless explicitly requested and explained.

Deny by default:

- `rm -rf`
- `git push --force`
- `git push -f`
- `git reset --hard`
- `git clean -f`
- `sudo`
- `chmod 777`
- reading or writing `.env` files

Prefer safe commands:

- `git status`
- `git diff`
- `git log --oneline`
- `git branch`
- `python -m json.tool`
- project-specific test commands

## Path-Scoped Rule Handling

Before editing files, Codex must infer the domain:

- `src/gameplay/**` — gameplay rules
- `src/core/**` — core engine rules
- `src/ai/**` — AI rules
- `src/networking/**` — networking rules
- `src/ui/**` — UI rules
- `design/gdd/**` — design document rules
- `tests/**` — testing rules
- `prototypes/**` — prototype rules
- `assets/**` — asset naming and validation rules
- `.claude/skills/**` — skill-change validation rules
- `.codex/**` — adapter consistency rules

Then read the nearest applicable `.claude/rules/` file before editing.

## Output Format for Codex Work

When analyzing:

```markdown
## Findings
## Relevant source files
## Options
## Recommended smallest step
## Approval needed
```

When implementing:

```markdown
## Changed files
## What changed
## How to test
## Risks
## Next step
```

## Engine Handling

When an engine is selected, Codex must use the matching engine specialist instructions:

- Godot 4 → Godot specialist + GDScript / shader / GDExtension sub-specialists
- Unity → Unity specialist + DOTS / shaders / Addressables / UI Toolkit sub-specialists
- Unreal Engine 5 → Unreal specialist + GAS / Blueprints / Replication / UMG specialists

Do not mix engine assumptions without asking.

## Default Behavior

If the user simply asks Codex to start, run this logical flow:

1. Read `CLAUDE.md`.
2. Read `.claude/docs/workflow-catalog.yaml`.
3. Check whether engine and concept are configured.
4. If not configured, emulate `/start`.
5. If configured, detect current project phase.
6. Recommend one next action.

## Important Honesty Note

This adapter preserves Claude Code Game Studios for Codex at the workflow, instruction, and documentation level. It does not make Codex support Claude Code-only runtime features natively. Where exact runtime behavior is impossible, Codex must say so and use the documented wrapper/manual equivalent.
