#!/usr/bin/env bash
# Hook PostToolUse sur Edit et Write : formate le fichier .dart modifié.
set -u
input=$(cat)
file=$(printf '%s' "$input" | jq -r '.tool_input.file_path // empty')
[ -z "$file" ] && exit 0
case "$file" in
  *.dart)
    if [ -f "$file" ]; then
      if command -v fvm >/dev/null 2>&1 && [ -f "${CLAUDE_PROJECT_DIR:-.}/.fvmrc" ]; then
        fvm dart format "$file" >/dev/null 2>&1 || dart format "$file" >/dev/null 2>&1 || true
      else
        dart format "$file" >/dev/null 2>&1 || true
      fi
    fi ;;
esac
exit 0
