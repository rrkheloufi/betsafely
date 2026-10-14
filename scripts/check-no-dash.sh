#!/usr/bin/env bash
# Aucun tiret cadratin (U+2014) ni demi-cadratin (U+2013) dans le dépôt.
# Les octets UTF-8 sont construits avec printf pour que ce script ne se détecte pas lui-même.
set -u
cd "$(dirname "$0")/.."
em=$(printf '\342\200\224')
en=$(printf '\342\200\223')
excludes=(--exclude-dir=.git --exclude-dir=build --exclude-dir=.dart_tool --exclude-dir=node_modules --exclude-dir=.fvm --exclude-dir=ios/Pods --exclude-dir=coverage)
if grep -rIn "${excludes[@]}" -e "$em" -e "$en" . ; then
  echo "check-no-dash : tirets cadratins ou demi-cadratins trouvés (voir ci-dessus)." >&2
  exit 1
fi
echo "check-no-dash : OK"
