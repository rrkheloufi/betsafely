---
id: T-02
title: Flavors dev et prod
status: todo
phase: 0 Socle
depends_on: [T-01]
manual: false
estimate: M
model: opus
done_at:
---

# T-02 · Flavors dev et prod

## Objectif

`make run-dev` lance l'app « BetSafely Dev » avec l'identifiant `fr.rsquare.betsafely.dev`, et `make build-prod` produit un build `fr.rsquare.betsafely`.

## Contexte

- docs/architecture.md section 11 (environnements)
- env/dev.example.json
- Makefile
- `.claude/rules/` applicables et `CLAUDE.md`.

## Étapes

1. Android : `productFlavors` `dev` (applicationIdSuffix `.dev`, `resValue app_name`) et `prod` dans `android/app/build.gradle.kts`, `flavorDimensions`, `minSdk 26`, `targetSdk` courant, lecture de `key.properties` si présent pour la signature release (sinon debug).
2. iOS : schémas `dev` et `prod`, xcconfig par flavor (`Flavors/dev.xcconfig`, `Flavors/prod.xcconfig`) définissant `PRODUCT_BUNDLE_IDENTIFIER`, `PRODUCT_NAME`, `APP_DISPLAY_NAME` ; `IPHONEOS_DEPLOYMENT_TARGET = 16.0`.
3. `lib/config/env.dart` : classe `Env` immuable construite depuis `String.fromEnvironment` pour chaque clé de `env/*.example.json`, avec `isDev`, `isProd`, validation au démarrage (clé vide en prod = exception).
4. `main_dev.dart` et `main_prod.dart` appellent `bootstrap(Env.fromDefines())`.
5. Documenter dans README.md toute commande ajoutée.

## Tests

| Test (comportement vérifié) | Fichier | Commande |
|---|---|---|
| Env refuse une configuration prod incomplète et accepte dev | `test/config/env_test.dart` | `flutter test test/config/env_test.dart` |

## Sécurité

- [ ] Aucun secret ni valeur réelle dans le diff
- [ ] Aucune dépendance hors de la liste de docs/architecture.md section 10
- [ ] Les fichiers env/dev.json et env/prod.json restent ignorés par git

## Definition of Done

- [ ] Étapes réalisées
- [ ] Tests du tableau écrits et verts, aucun test superflu
- [ ] Checklist sécurité cochée (ou n/a)
- [ ] `make check` vert (plus `make test-db` et `make test-functions` si `supabase/` est touché)
- [ ] Revue `code-reviewer` : OK ou OK avec réserves consignées
- [ ] Statut `done` avec date dans ce fichier et dans `tasks/INDEX.md`
- [ ] Commit unique `chore(T-02): Flavors dev et prod` sur `dev`, sans push (ou rien à committer pour une tâche purement manuelle)

## Notes de revue
