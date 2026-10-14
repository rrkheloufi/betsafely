#!/usr/bin/env bash
# Hook Stop : lance flutter analyze si le projet Flutter est initialisé (.dart_tool présent).
# Ne bloque jamais la fin du tour : le résultat est remonté à Claude via stderr.
set -u
root="${CLAUDE_PROJECT_DIR:-.}"
input=$(cat)
# Évite la boucle : si un hook Stop a déjà relancé Claude, on ne refait rien.
active=$(printf '%s' "$input" | jq -r '.stop_hook_active // false')
[ "$active" = "true" ] && exit 0
[ -d "$root/.dart_tool" ] || exit 0
cd "$root" || exit 0
if command -v fvm >/dev/null 2>&1 && [ -f .fvmrc ]; then
  out=$(fvm flutter analyze --no-pub 2>&1) || { echo "flutter analyze a signalé des problèmes :" >&2; echo "$out" | tail -40 >&2; exit 2; }
else
  out=$(flutter analyze --no-pub 2>&1) || { echo "flutter analyze a signalé des problèmes :" >&2; echo "$out" | tail -40 >&2; exit 2; }
fi
exit 0
