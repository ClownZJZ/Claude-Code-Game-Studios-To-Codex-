$ErrorActionPreference = "Stop"

$errors = 0
$warnings = 0

function Fail-Check {
  param([string]$Message)
  Write-Output "ERR  $Message"
  $script:errors += 1
}

function Warn-Check {
  param([string]$Message)
  Write-Output "WARN $Message"
  $script:warnings += 1
}

function Ok-Check {
  param([string]$Message)
  Write-Output "OK   $Message"
}

Write-Output "== Codex Game Studios commit validation =="

@(
  "AGENTS.md",
  "CODEX.md",
  ".codex/adapter-manifest.json",
  ".codex/commands.md",
  ".codex/hooks.md",
  ".codex/skill-index.json",
  ".codex/agent-index.json",
  ".codex-plugin/plugin.json",
  "skills/claude-game-studios/SKILL.md"
) | ForEach-Object {
  if (Test-Path $_) {
    Ok-Check "$_ present"
  } else {
    Fail-Check "$_ missing"
  }
}

@(
  ".codex/adapter-manifest.json",
  ".codex/skill-index.json",
  ".codex/agent-index.json",
  ".codex-plugin/plugin.json"
) | ForEach-Object {
  if (Test-Path $_) {
    try {
      Get-Content -Raw $_ | ConvertFrom-Json | Out-Null
      Ok-Check "JSON parses: $_"
    } catch {
      Fail-Check "$_ is invalid JSON"
    }
  }
}

git rev-parse --is-inside-work-tree *> $null
if ($LASTEXITCODE -eq 0) {
  $staged = @(git diff --cached --name-only)
  if ($staged | Where-Object { $_ -match "(^|/)\.env($|\.)" }) {
    Fail-Check "staged .env file detected"
  }
  if ($staged | Where-Object { $_ -match "^\.claude/skills/|^skills/" }) {
    Warn-Check "skill files changed; run /skill-test or the Codex equivalent"
  }
  if ($staged | Where-Object { $_ -match "^\.codex/|^\.codex-plugin/|^AGENTS\.md$|^CODEX\.md$" }) {
    Warn-Check "adapter files changed; run scripts/codex-session-check.ps1"
  }
} else {
  Warn-Check "not inside a git repository; skipped staged-file checks"
}

Write-Output ""
Write-Output "Summary: $errors error(s), $warnings warning(s)"

if ($errors -gt 0) {
  exit 1
}

exit 0
