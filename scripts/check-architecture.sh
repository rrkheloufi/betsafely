#!/usr/bin/env bash
# Règles d'imports de l'architecture MVVM (.claude/rules/architecture.md).
set -u
cd "$(dirname "$0")/.."
[ -d lib ] || { echo "check-architecture : lib/ absent, rien à vérifier"; exit 0; }
fail=0
report() { echo "  $1" >&2; fail=1; }

# Expression des imports de SDK confinés
sdk_re='package:(supabase_flutter|supabase|purchases_flutter|purchases_ui_flutter|drift|drift_flutter|flutter_local_notifications|local_auth|home_widget|image_picker|share_plus|sign_in_with_apple|google_sign_in|sentry_flutter|posthog_flutter|url_launcher|package_info_plus|in_app_review|csv|pdf|path_provider|flutter_secure_storage)/'

# 1. lib/ui/ n'importe ni lib/data/services/ ni un SDK (sauf purchases_ui_flutter, interdit aussi car le paywall est présenté par le service)
while IFS= read -r f; do
  grep -nE "import '(package:betsafely/data/services/|\.\./.*data/services/)" "$f" | sed "s|^|$f:|" | while read -r l; do report "ui importe un service : $l"; done
  grep -nE "import '$sdk_re" "$f" | sed "s|^|$f:|" | while read -r l; do report "ui importe un SDK : $l"; done
done < <(find lib/ui -name '*.dart' 2>/dev/null)

# 2. Les widgets n'importent rien de lib/data/
while IFS= read -r f; do
  grep -nE "import '(package:betsafely/data/|\.\./.*/data/)" "$f" | sed "s|^|$f:|" | while read -r l; do report "widget importe lib/data : $l"; done
done < <(find lib/ui -path '*/widgets/*' -name '*.dart' 2>/dev/null)

# 3. lib/domain/ n'importe ni package:flutter/ ni lib/data/
while IFS= read -r f; do
  grep -nE "import '(package:flutter/|package:betsafely/data/|\.\./.*/data/)" "$f" | sed "s|^|$f:|" | while read -r l; do report "domain importe Flutter ou data : $l"; done
done < <(find lib/domain -name '*.dart' 2>/dev/null)

# 4. supabase_flutter et purchases_flutter uniquement dans lib/data/services/ et lib/config/
while IFS= read -r f; do
  case "$f" in lib/data/services/*|lib/config/*) continue;; esac
  grep -nE "import 'package:(supabase_flutter|supabase|purchases_flutter|purchases_ui_flutter)/" "$f" | sed "s|^|$f:|" | while read -r l; do report "SDK hors services/config : $l"; done
done < <(find lib -name '*.dart' 2>/dev/null)

# 5. purchases_ui_flutter uniquement dans lib/data/services/purchases/
while IFS= read -r f; do
  case "$f" in lib/data/services/purchases/*) continue;; esac
  grep -nE "import 'package:purchases_ui_flutter/" "$f" | sed "s|^|$f:|" | while read -r l; do report "purchases_ui_flutter hors du service d'achat : $l"; done
done < <(find lib -name '*.dart' 2>/dev/null)

# 6. Aucun gestionnaire d'état autre que provider
if grep -rnE "package:(flutter_riverpod|riverpod|hooks_riverpod|flutter_bloc|bloc|get|get_it|mobx|flutter_mobx)/" lib 2>/dev/null; then
  report "gestionnaire d'état interdit (Riverpod, BLoC, GetX, MobX, get_it)"
fi
if [ -f pubspec.yaml ] && grep -nE '^\s+(flutter_riverpod|riverpod|hooks_riverpod|flutter_bloc|bloc|get|get_it|mobx|flutter_mobx):' pubspec.yaml; then
  report "dépendance de gestion d'état interdite dans pubspec.yaml"
fi

# Les sous-shells de while masquent fail : on recompte via un second passage simple
count=$( { find lib/ui -name '*.dart' -exec grep -lE "import '(package:betsafely/data/services/|$sdk_re)" {} + 2>/dev/null;
           find lib/ui -path '*/widgets/*' -name '*.dart' -exec grep -lE "import '(package:betsafely/data/)" {} + 2>/dev/null;
           find lib/domain -name '*.dart' -exec grep -lE "import '(package:flutter/|package:betsafely/data/)" {} + 2>/dev/null;
           find lib -name '*.dart' -not -path 'lib/data/services/*' -not -path 'lib/config/*' -exec grep -lE "import 'package:(supabase_flutter|supabase|purchases_flutter|purchases_ui_flutter)/" {} + 2>/dev/null;
           grep -rlE "package:(flutter_riverpod|riverpod|hooks_riverpod|flutter_bloc|bloc|get|get_it|mobx|flutter_mobx)/" lib 2>/dev/null; } | sort -u | wc -l)
if [ "$count" -gt 0 ] || [ "$fail" = 1 ]; then
  echo "check-architecture : violations d'imports (voir ci-dessus)." >&2
  exit 1
fi
echo "check-architecture : OK"
