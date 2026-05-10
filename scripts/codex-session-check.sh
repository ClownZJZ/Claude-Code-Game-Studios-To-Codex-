#!/usr/bin/env bash
set -euo pipefail

errors=0
warnings=0

check_required() {
  if [ -e "$1" ]; then
    printf 'OK   %s\n' "$1"
  else
    printf 'ERR  missing %s\n' "$1"
    errors=$((errors + 1))
  fi
}

check_optional() {
  if [ -e "$1" ]; then
    printf 'OK   %s\n' "$1"
  else
    printf 'WARN missing %s\n' "$1"
    warnings=$((warnings + 1))
  fi
}

echo "== Codex Game Studios readiness check =="

check_required "AGENTS.md"
check_required "CODEX.md"
check_required "CLAUDE.md"
check_required ".codex/adapter-manifest.json"
check_required ".codex/commands.md"
check_required ".codex/hooks.md"
check_required ".codex/skill-index.json"
check_required ".codex/agent-index.json"
check_required ".codex-plugin/plugin.json"
check_required "skills/claude-game-studios/SKILL.md"
check_required ".claude/agents"
check_required ".claude/skills"
check_required ".claude/hooks"
check_required ".claude/rules"
check_required ".claude/docs/workflow-catalog.yaml"

check_optional "scripts/codex-start.sh"
check_optional "scripts/codex-run-skill.sh"
check_optional "scripts/codex-validate-commit.sh"
check_optional "scripts/codex-validate-assets.sh"
check_optional "docs/CODEX_COMPATIBILITY.md"
check_optional "docs/CODEX_MIGRATION_MAP.md"

if command -v python >/dev/null 2>&1; then
  python -m json.tool ".codex/adapter-manifest.json" >/dev/null
  python -m json.tool ".codex/skill-index.json" >/dev/null
  python -m json.tool ".codex/agent-index.json" >/dev/null
  python -m json.tool ".codex-plugin/plugin.json" >/dev/null
  printf 'OK   JSON files parse with python\n'
else
  printf 'WARN python not found; skipped JSON parse check\n'
  warnings=$((warnings + 1))
fi

if [ -d ".claude/skills" ]; then
  skill_count=$(find ".claude/skills" -mindepth 1 -maxdepth 1 -type d 2>/dev/null | wc -l | tr -d ' ')
  printf 'INFO source skill directories: %s\n' "$skill_count"
  if [ "$skill_count" -lt 72 ]; then
    printf 'WARN expected 72 source skills; found %s\n' "$skill_count"
    warnings=$((warnings + 1))
  fi
fi

if [ -d ".claude/agents" ]; then
  agent_count=$(find ".claude/agents" -maxdepth 1 -type f -name '*.md' 2>/dev/null | wc -l | tr -d ' ')
  printf 'INFO source agent files: %s\n' "$agent_count"
  if [ "$agent_count" -lt 49 ]; then
    printf 'WARN expected at least 49 source agents; found %s\n' "$agent_count"
    warnings=$((warnings + 1))
  fi
fi

printf '\nSummary: %s error(s), %s warning(s)\n' "$errors" "$warnings"

if [ "$errors" -gt 0 ]; then
  exit 1
fi

exit 0
