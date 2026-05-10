#!/usr/bin/env bash
set -euo pipefail

if [ $# -lt 1 ]; then
  echo "Usage: bash scripts/codex-run-skill.sh <skill-name> [args...]" >&2
  exit 1
fi

SKILL="$1"
shift || true
SKILL="${SKILL#/}"
ARGS="$*"

cat <<EOF
Run /$SKILL using the Codex adapter.

Arguments: $ARGS

Instructions for Codex:
1. Read AGENTS.md.
2. Read CODEX.md.
3. Read .codex/adapter-manifest.json.
4. Find the matching source skill under .claude/skills/ for /$SKILL.
5. Read .claude/docs/workflow-catalog.yaml if the skill affects project phase.
6. Read relevant .claude/agents/ files if the skill delegates to studio roles.
7. Execute the workflow interactively.
8. Ask before writing files unless the user already explicitly requested edits.
EOF
