# Codex Command Mapping

Claude Code Game Studios exposes workflows as Claude slash commands. Codex does not provide the same slash-command registry, so each slash command is treated as a named workflow.

## Invocation

Use either form:

```text
Run /start using the Codex adapter.
Run /setup-engine godot 4.5 using the Codex adapter.
Use skill /create-architecture with args: Godot 4.5, solo developer.
```

Or from shell:

```bash
bash scripts/codex-run-skill.sh start
bash scripts/codex-run-skill.sh setup-engine godot 4.5
```

The emitted prompt should be pasted into Codex.

## Routing Rules

When a command is invoked, Codex must:

1. Normalize `/command` to `command`.
2. Search `.claude/skills/` for a matching skill directory or markdown file.
3. Read the skill instructions.
4. Read `.claude/docs/workflow-catalog.yaml` if the command affects project phase.
5. Read relevant agents from `.claude/agents/` if the skill delegates work.
6. Ask before writing artifacts.

## Core Commands from README

### Onboarding & Navigation

- `/start`
- `/help`
- `/project-stage-detect`
- `/setup-engine`
- `/adopt`

### Game Design

- `/brainstorm`
- `/map-systems`
- `/design-system`
- `/quick-design`
- `/review-all-gdds`
- `/propagate-design-change`

### Art & Assets

- `/art-bible`
- `/asset-spec`
- `/asset-audit`

### UX & Interface Design

- `/ux-design`
- `/ux-review`

### Architecture

- `/create-architecture`
- `/architecture-decision`
- `/architecture-review`
- `/create-control-manifest`

### Stories & Sprints

- `/create-epics`
- `/create-stories`
- `/dev-story`
- `/sprint-plan`
- `/sprint-status`
- `/story-readiness`
- `/story-done`
- `/estimate`

### Reviews & Analysis

- `/design-review`
- `/code-review`
- `/balance-check`
- `/content-audit`
- `/scope-check`
- `/perf-profile`
- `/tech-debt`
- `/gate-check`
- `/consistency-check`

### QA & Testing

- `/qa-plan`
- `/smoke-check`
- `/soak-test`
- `/regression-suite`
- `/test-setup`
- `/test-helpers`
- `/test-evidence-review`
- `/test-flakiness`
- `/skill-test`
- `/skill-improve`

### Production

- `/milestone-review`
- `/retrospective`
- `/bug-report`
- `/bug-triage`
- `/reverse-document`
- `/playtest-report`

### Release

- `/release-checklist`
- `/launch-checklist`
- `/changelog`
- `/patch-notes`
- `/hotfix`

### Creative & Content

- `/prototype`
- `/onboard`
- `/localize`

### Team Orchestration

- `/team-combat`
- `/team-narrative`
- `/team-ui`
- `/team-release`
- `/team-polish`
- `/team-audio`
- `/team-level`
- `/team-live-ops`
- `/team-qa`

## Codex Output Contract

For every command workflow, Codex should produce:

```markdown
## Command
## Source skill files read
## Current phase / context
## Proposed action
## Files to create or edit
## Approval needed
```

After approved edits:

```markdown
## Changed files
## Summary
## Validation steps
## Risks
## Next command
```
