param(
  [Parameter(Mandatory = $true, Position = 0)]
  [string]$Path
)

$normalized = $Path -replace "\\", "/"
if (-not ($normalized -like "assets/*" -or $normalized -like "./assets/*")) {
  Write-Output "OK   $Path is outside assets/; no asset validation needed"
  exit 0
}

$base = Split-Path -Leaf $Path
$ext = [System.IO.Path]::GetExtension($base).TrimStart(".").ToLowerInvariant()

if ($base.Contains(" ")) {
  Write-Error "asset filename contains spaces: $base"
  exit 1
}

if ($base -notmatch "^[a-z0-9][a-z0-9_.-]*$") {
  Write-Error "asset filename should be lowercase snake/kebab style: $base"
  exit 1
}

$known = @("png", "jpg", "jpeg", "webp", "svg", "ogg", "wav", "mp3", "glb", "gltf", "json", "tres", "res", "gdshader", "import")
if ($known -contains $ext) {
  Write-Output "OK   recognized asset extension: .$ext"
} else {
  Write-Output "WARN uncommon asset extension: .$ext"
}

if ((Test-Path $Path) -and $ext -eq "json") {
  Get-Content -Raw $Path | ConvertFrom-Json | Out-Null
  Write-Output "OK   JSON asset parses"
}

exit 0
