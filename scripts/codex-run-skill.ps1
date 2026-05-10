param(
  [Parameter(Mandatory = $true, Position = 0)]
  [string]$Skill,

  [Parameter(ValueFromRemainingArguments = $true)]
  [string[]]$Args
)

$normalizedSkill = $Skill.TrimStart("/")
$argText = ($Args -join " ")

@"
Run /$normalizedSkill using the Codex adapter.

Arguments: $argText

Instructions for Codex:
1. Read AGENTS.md.
2. Read CODEX.md.
3. Read .codex/adapter-manifest.json.
4. Read skills/claude-game-studios/SKILL.md if available.
5. Look up /$normalizedSkill in .codex/skill-index.json.
6. Read the matching source skill under .claude/skills/.
7. Read .claude/docs/workflow-catalog.yaml if the skill affects project phase.
8. Read relevant .claude/agents/ files if the skill delegates to studio roles.
9. Execute the workflow interactively.
10. Ask before writing files unless the user already explicitly requested edits.
"@
