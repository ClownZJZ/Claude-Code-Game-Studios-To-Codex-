$ErrorActionPreference = "Stop"

$errors = 0
$warnings = 0

function Check-Required {
  param([string]$Path)
  if (Test-Path $Path) {
    Write-Output "OK   $Path"
  } else {
    Write-Output "ERR  missing $Path"
    $script:errors += 1
  }
}

function Check-Optional {
  param([string]$Path)
  if (Test-Path $Path) {
    Write-Output "OK   $Path"
  } else {
    Write-Output "WARN missing $Path"
    $script:warnings += 1
  }
}

Write-Output "== Codex Game Studios readiness check =="

@(
  "AGENTS.md",
  "CODEX.md",
  "CLAUDE.md",
  ".codex/adapter-manifest.json",
  ".codex/commands.md",
  ".codex/hooks.md",
  ".codex/skill-index.json",
  ".codex/agent-index.json",
  ".codex-plugin/plugin.json",
  "skills/claude-game-studios/SKILL.md",
  ".claude/agents",
  ".claude/skills",
  ".claude/hooks",
  ".claude/rules",
  ".claude/docs/workflow-catalog.yaml"
) | ForEach-Object { Check-Required $_ }

@(
  "scripts/codex-start.sh",
  "scripts/codex-start.ps1",
  "scripts/codex-run-skill.sh",
  "scripts/codex-run-skill.ps1",
  "scripts/codex-session-check.sh",
  "scripts/codex-session-check.ps1",
  "scripts/codex-validate-commit.sh",
  "scripts/codex-validate-commit.ps1",
  "scripts/codex-validate-assets.sh",
  "scripts/codex-validate-assets.ps1",
  "docs/CODEX_COMPATIBILITY.md",
  "docs/CODEX_MIGRATION_MAP.md"
) | ForEach-Object { Check-Optional $_ }

@(
  ".codex/adapter-manifest.json",
  ".codex/skill-index.json",
  ".codex/agent-index.json",
  ".codex-plugin/plugin.json"
) | ForEach-Object {
  try {
    Get-Content -Raw $_ | ConvertFrom-Json | Out-Null
    Write-Output "OK   JSON parses: $_"
  } catch {
    Write-Output "ERR  invalid JSON: $_"
    $script:errors += 1
  }
}

if (Test-Path ".claude/skills") {
  $skillCount = (Get-ChildItem -Path ".claude/skills" -Recurse -Filter "SKILL.md" -File | Measure-Object).Count
  Write-Output "INFO source skill files: $skillCount"
  if ($skillCount -lt 72) {
    Write-Output "WARN expected 72 source skills; found $skillCount"
    $warnings += 1
  }
}

if (Test-Path ".claude/agents") {
  $agentCount = (Get-ChildItem -Path ".claude/agents" -Filter "*.md" -File | Measure-Object).Count
  Write-Output "INFO source agent files: $agentCount"
  if ($agentCount -lt 49) {
    Write-Output "WARN expected 49 source agents; found $agentCount"
    $warnings += 1
  }
}

Write-Output ""
Write-Output "Summary: $errors error(s), $warnings warning(s)"

if ($errors -gt 0) {
  exit 1
}

exit 0
