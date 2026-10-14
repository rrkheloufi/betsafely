# ops/

Données versionnées, non secrètes, consommées par `scripts/ops/` :

- `paywall.json` : définition du paywall RevenueCat (textes PW-01, tokens, liens), poussé par `revenuecat-provision.sh` (T-14).
- `play-prices.json` : prix régionaux des plans de base Play d'après le brief 7.2 (T-16). Les prix App Store sont dérivés des price points de l'API dans `apple-provision.sh` (T-15).
- `store-metadata/appstore/<locale>/` et `store-metadata/play/<locale>/` : fiches au format `fastlane deliver` et `supply`, captures sous `screenshots/` (T-143).
- `store-metadata/play/data-safety.csv` : export de la console, repoussé par `store-metadata.sh`.

Rien dans ce dossier ne contient de jeton, d'identifiant de projet réel ni de clé.
