#!/usr/bin/env bash
# Aucun Text avec un littéral dans lib/ui/ : tous les textes passent par l10n.
# Détecte Text('...'), Text("..."), Text.rich(TextSpan(text: '...')), hintText: '...', labelText: '...', label: Text('...').
# Un littéral vide, un symbole seul (devise, signe) ou une ligne marquée // l10n-ok sont tolérés.
set -u
cd "$(dirname "$0")/.."
[ -d lib/ui ] || { echo "check-strings : lib/ui absent, rien à vérifier"; exit 0; }
pattern="(Text|SelectableText|TextSpan|Tooltip|Semantics)\((label: |message: |text: )?['\"][^'\"]{2,}['\"]|(hintText|labelText|helperText|errorText|semanticsLabel|tooltip|title|subtitle): ['\"][^'\"]{2,}['\"]"
if find lib/ui -name '*.dart' -not -name '*.g.dart' -exec grep -nE "$pattern" {} + | grep -v '// l10n-ok' ; then
  echo "check-strings : littéraux affichés trouvés dans lib/ui/ (utiliser context.l10n)." >&2
  exit 1
fi
echo "check-strings : OK"
