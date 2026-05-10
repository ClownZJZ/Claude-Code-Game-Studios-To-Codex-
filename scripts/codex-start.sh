#!/usr/bin/env bash
set -euo pipefail

echo "== Codex Game Studios Adapter =="

if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "Repository: $(basename "$(git rev-parse --show-toplevel)")"
  echo "Branch: $(git branch --show-current 2>/dev/null || echo unknown)"
  echo
  echo "Recent commits:"
  git log --oneline -5 2>/dev/null || true
  echo
  echo "Working tree:"
  git status --short 2>/dev/null || true
else
  echo "Not inside a git repository."
fi

echo
printf '%s\n' "Codex boot prompt:"
printf '%s\n' "Read AGENTS.md, CODEX.md, CLAUDE.md, and .codex/adapter-manifest.json. Then follow the Codex adapter protocol."
