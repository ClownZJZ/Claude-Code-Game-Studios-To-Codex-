#!/usr/bin/env bash
set -euo pipefail

errors=0
warnings=0

fail() {
  printf 'ERR  %s\n' "$1"
  errors=$((errors + 1))
}

warn() {
  printf 'WARN %s\n' "$1"
  warnings=$((warnings + 1))
}

ok() {
  printf 'OK   %s\n' "$1"
}

echo "== Codex Game Studios commit validation =="

for path in \
  "AGENTS.md" \
  "CODEX.md" \
  ".codex/adapter-manifest.json" \
  ".codex/commands.md" \
  ".codex/hooks.md" \
  ".codex/skill-index.json" \
  ".codex/agent-index.json" \
  ".codex-plugin/plugin.json" \
  "skills/claude-game-studios/SKILL.md"; do
  if [ -e "$path" ]; then
    ok "$path present"
  else
    fail "$path missing"
  fi
done

if command -v python >/dev/null 2>&1; then
  for json in \
    ".codex/adapter-manifest.json" \
    ".codex/skill-index.json" \
    ".codex/agent-index.json" \
    ".codex-plugin/plugin.json"; do
    if [ -f "$json" ]; then
      python -m json.tool "$json" >/dev/null || fail "$json is invalid JSON"
    fi
  done
  ok "JSON syntax checked"
else
  warn "python not found; skipped JSON syntax checks"
fi

if command -v git >/dev/null 2>&1 && git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  if git diff --cached --name-only | grep -E '(^|/)\.env($|\.)' >/dev/null 2>&1; then
    fail "staged .env file detected"
  fi
  if git diff --cached --name-only | grep -E '^\.claude/skills/|^skills/' >/dev/null 2>&1; then
    warn "skill files changed; run /skill-test or the Codex equivalent"
  fi
  if git diff --cached --name-only | grep -E '^\.codex/|^\.codex-plugin/|^AGENTS.md|^CODEX.md' >/dev/null 2>&1; then
    warn "adapter files changed; run scripts/codex-session-check.sh"
  fi
else
  warn "not inside a git repository; skipped staged-file checks"
fi

printf '\nSummary: %s error(s), %s warning(s)\n' "$errors" "$warnings"

if [ "$errors" -gt 0 ]; then
  exit 1
fi

exit 0
