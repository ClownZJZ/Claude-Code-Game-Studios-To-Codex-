# Codex Hook Mapping

Claude Code Game Studios uses Claude Code hook events configured in `.claude/settings.json`. Codex does not execute those events natively. This document maps each hook intent to a Codex-compatible manual/script workflow.

## SessionStart

Claude source:

- `.claude/hooks/session-start.sh`
- `.claude/hooks/detect-gaps.sh`

Codex equivalent on Windows / PowerShell:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/codex-start.ps1
powershell -ExecutionPolicy Bypass -File scripts/codex-session-check.ps1
```

Codex equivalent on macOS/Linux or Git Bash:

```bash
bash scripts/codex-start.sh
bash scripts/codex-session-check.sh
```

Intent:

- Show branch and recent git context.
- Detect missing concept/engine/design docs.
- Recommend `/start` or current phase continuation.

## PreToolUse: Bash

Claude source:

- `.claude/hooks/validate-commit.sh`
- `.claude/hooks/validate-push.sh`

Codex equivalent before commit/push on Windows / PowerShell:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/codex-validate-commit.ps1
```

Codex equivalent before commit/push on macOS/Linux or Git Bash:

```bash
bash scripts/codex-validate-commit.sh
```

Intent:

- Warn on dangerous git operations.
- Check obvious JSON validity issues.
- Encourage design and test evidence before commits.

## PostToolUse: Write/Edit

Claude source:

- `.claude/hooks/validate-assets.sh`
- `.claude/hooks/validate-skill-change.sh`

Codex equivalent on Windows / PowerShell:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/codex-validate-assets.ps1 <path>
```

Codex equivalent on macOS/Linux or Git Bash:

```bash
bash scripts/codex-validate-assets.sh <path>
```

If editing `.claude/skills/**` or `.codex/commands.md`, Codex must recommend running:

```text
/skill-test
```

or the Codex equivalent:

```text
Run /skill-test using the Codex adapter.
```

## Notification

Claude source:

- `.claude/hooks/notify.sh`

Codex equivalent:

- Not automatic.
- Optional user shell/OS notification script.

## PreCompact / PostCompact

Claude source:

- `.claude/hooks/pre-compact.sh`
- `.claude/hooks/post-compact.sh`

Codex equivalent:

- Codex should summarize session state before long context transitions.
- Save notes to `production/session/active.md` if the project uses that convention.

## Stop

Claude source:

- `.claude/hooks/session-stop.sh`

Codex equivalent:

- Before ending a major session, summarize changed files, git status, next command, and unresolved decisions.

## SubagentStart / SubagentStop

Claude source:

- `.claude/hooks/log-agent.sh`
- `.claude/hooks/log-agent-stop.sh`

Codex equivalent:

- Codex does not spawn native Claude subagents.
- When adopting a role, Codex should state which source agent file was read.
- Optional session logs may record role usage manually.

## Required Honesty

Codex must not claim these hooks are natively automatic. They are compatibility equivalents that preserve hook intent through explicit scripts, manual checks, or CI integration.
