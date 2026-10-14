---
id: T-00
title: Création du projet Flutter
status: todo
phase: 0 Socle
depends_on: []
manual: false
estimate: S
model: opus
done_at:
---

# T-00 · Création du projet Flutter

## Objectif

Le projet Flutter `betsafely` existe à la racine, compile en debug et `make check` est vert sur le squelette.

## Contexte

- docs/architecture.md section 9 (structure) et 10 (dépendances)
- README.md
- Makefile
- .fvmrc
- `.claude/rules/` applicables et `CLAUDE.md`.

## Étapes

1. `fvm use 3.47.0` puis `fvm flutter create --org fr.rsquare --project-name betsafely --platforms ios,android --empty .` dans le dossier du dépôt (les fichiers existants sont conservés ; en cas de conflit sur README.md ou .gitignore, garder les versions du dépôt).
2. Dans `pubspec.yaml` : description, `publish_to: none`, contrainte SDK Dart courante, `version: 0.1.0+1`, activer `generate: true` sous `flutter:` pour l10n.
3. Ajouter les dépendances de docs/architecture.md section 10 avec `flutter pub add` (versions majeures à jour sur pub.dev), dev_dependencies : `build_runner`, `freezed`, `json_serializable`, `drift_dev`, `flutter_lints`, `mocktail`, `integration_test` (sdk).
4. Créer `lib/main_dev.dart`, `lib/main_prod.dart` et `lib/app.dart` minimaux (un `MaterialApp` avec un écran vide), `lib/config/env.dart` qui lit `String.fromEnvironment('FLAVOR')` et les clés de `env/dev.example.json`.
5. Créer `l10n.yaml` (`arb-dir: lib/l10n`, `template-arb-file: app_fr.arb`, `output-localization-file: app_localizations.dart`, `nullable-getter: false`) et `lib/l10n/app_fr.arb`, `lib/l10n/app_en.arb` avec la seule clé `appName`.
6. Supprimer le `README.md` de `lib/`, `test/`, `integration_test/` remplacés par du code ; remplacer `test/widget_test.dart` généré par rien (aucun test de rendu).
7. `make setup`, `make gen`, `make check` verts ; `flutter build apk --debug` passe (sans flavor pour l'instant).

## Tests

Aucun test exigé par la politique pour cette tâche (configuration, action manuelle ou relais sans logique). Un test ajouté ici serait superflu.

## Sécurité

- [ ] Aucun secret ni valeur réelle dans le diff
- [ ] Aucune dépendance hors de la liste de docs/architecture.md section 10

## Definition of Done

- [ ] Étapes réalisées
- [ ] Tests du tableau écrits et verts, aucun test superflu
- [ ] Checklist sécurité cochée (ou n/a)
- [ ] `make check` vert (plus `make test-db` et `make test-functions` si `supabase/` est touché)
- [ ] Revue `code-reviewer` : OK ou OK avec réserves consignées
- [ ] Statut `done` avec date dans ce fichier et dans `tasks/INDEX.md`
- [ ] Commit unique `chore(T-00): Création du projet Flutter` sur `dev`, sans push (ou rien à committer pour une tâche purement manuelle)

## Notes de revue
