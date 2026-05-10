Write-Output "== Codex Game Studios Adapter =="

git rev-parse --is-inside-work-tree *> $null
if ($LASTEXITCODE -eq 0) {
  $root = git rev-parse --show-toplevel
  Write-Output "Repository: $(Split-Path -Leaf $root)"
  $branch = git branch --show-current 2>$null
  if (-not $branch) { $branch = "unknown" }
  Write-Output "Branch: $branch"
  Write-Output ""
  Write-Output "Recent commits:"
  git log --oneline -5 2>$null
  Write-Output ""
  Write-Output "Working tree:"
  git status --short 2>$null
} else {
  Write-Output "Not inside a git repository."
}

Write-Output ""
Write-Output "Codex boot prompt:"
Write-Output "Read AGENTS.md, CODEX.md, CLAUDE.md, and .codex/adapter-manifest.json. Then follow the Codex adapter protocol."
