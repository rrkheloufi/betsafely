#!/usr/bin/env bash
# Hook PreToolUse sur Bash : bloque les commandes interdites par CLAUDE.md avec un message explicite.
# Sortie 2 = commande bloquée, le message sur stderr est lu par Claude.
set -u
input=$(cat)
cmd=$(printf '%s' "$input" | jq -r '.tool_input.command // empty')
[ -z "$cmd" ] && exit 0

block() {
  echo "Commande bloquée par .claude/hooks/block-forbidden.sh : $1" >&2
  echo "Raison : $2" >&2
  exit 2
}

case "$cmd" in
  *"git push"*"--force"*|*"git push -f"*|*"git push"*"--force-with-lease"*)
    block "git push --force" "l'historique partagé ne se réécrit jamais." ;;
  *"git push"*)
    block "git push" "le push est fait par Rayan lui-même, jamais par Claude." ;;
  *"git reset --hard"*)
    block "git reset --hard" "perte de travail non commité ; utilise git stash ou git restore sur un fichier précis." ;;
  *"git clean"*)
    block "git clean" "suppression de fichiers non suivis ; nettoie à la main fichier par fichier." ;;
  *"supabase db reset"*"--linked"*)
    block "supabase db reset --linked" "réinitialise une base distante ; interdit sur tout projet lié." ;;
  *"supabase projects delete"*)
    block "supabase projects delete" "suppression d'un projet Supabase." ;;
  *"rm -rf /"*|*"rm -rf ~"*|*"rm -rf ."*|*"rm -rf *"*|*"rm -fr "*|*"rm -r "*)
    block "rm récursif" "seul build/ peut être effacé, avec flutter clean." ;;
  *"xcrun altool"*|*"xcrun notarytool"*|*"fastlane"*|*"gradlew publish"*|*"gradle publish"*|*"supply"*"--track"*)
    block "envoi vers les stores" "la soumission aux stores reste manuelle (docs/manual-setup.md)." ;;
  *"--skip"*"flutter test"*|*"flutter test"*"--skip"*)
    block "flutter test --skip" "aucun test n'est ignoré." ;;
  *"cat env/"*".json"*|*"cat "*".keystore"*|*"cat "*"key.properties"*|*"cat "*".p8"*|*"cat "*".p12"*)
    case "$cmd" in
      *".example.json"*) ;;
      *) block "lecture d'un secret" "env/*.json (hors exemples), keystores, key.properties, .p8 et .p12 ne se lisent pas." ;;
    esac ;;
esac
exit 0
