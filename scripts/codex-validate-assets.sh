#!/usr/bin/env bash
set -euo pipefail

if [ $# -lt 1 ]; then
  echo "Usage: bash scripts/codex-validate-assets.sh <path>" >&2
  exit 2
fi

path="$1"

case "$path" in
  assets/*|./assets/*) ;;
  *)
    printf 'OK   %s is outside assets/; no asset validation needed\n' "$path"
    exit 0
    ;;
esac

base=$(basename "$path")
ext="${base##*.}"

case "$base" in
  *" "*)
    echo "ERR  asset filename contains spaces: $base" >&2
    exit 1
    ;;
esac

if ! printf '%s' "$base" | grep -Eq '^[a-z0-9][a-z0-9_./-]*$'; then
  echo "ERR  asset filename should be lowercase snake/kebab style: $base" >&2
  exit 1
fi

case "$ext" in
  png|jpg|jpeg|webp|svg|ogg|wav|mp3|glb|gltf|json|tres|res|gdshader|import)
    printf 'OK   recognized asset extension: .%s\n' "$ext"
    ;;
  *)
    printf 'WARN uncommon asset extension: .%s\n' "$ext"
    ;;
esac

if [ -f "$path" ] && [ "$ext" = "json" ] && command -v python >/dev/null 2>&1; then
  python -m json.tool "$path" >/dev/null
  printf 'OK   JSON asset parses\n'
fi

exit 0
