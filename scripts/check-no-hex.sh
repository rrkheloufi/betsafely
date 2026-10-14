#!/usr/bin/env bash
# Aucune couleur en dur dans lib/ hors lib/ui/core/theme/.
# Détecte Color(0x...), Colors.<nom>, Color.fromARGB, Color.fromRGBO et les littéraux #RRGGBB dans les .dart.
set -u
cd "$(dirname "$0")/.."
[ -d lib ] || { echo "check-no-hex : lib/ absent, rien à vérifier"; exit 0; }
found=0
while IFS= read -r f; do
  if grep -nE 'Color\(0x[0-9A-Fa-f]{6,8}\)|Colors\.[a-zA-Z]+|Color\.from(ARGB|RGBO)\(|#[0-9A-Fa-f]{6}\b' "$f" | grep -vE 'Colors\.transparent|// hex-ok' ; then
    found=1
    echo "  dans $f" >&2
  fi
done < <(find lib -name '*.dart' -not -path 'lib/ui/core/theme/*' -not -name '*.g.dart' -not -name '*.freezed.dart')
if [ "$found" = 1 ]; then
  echo "check-no-hex : couleurs en dur trouvées hors lib/ui/core/theme/." >&2
  exit 1
fi
echo "check-no-hex : OK"
