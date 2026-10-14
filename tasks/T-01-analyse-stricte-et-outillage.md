---
id: T-01
title: Analyse stricte, FVM, hooks et scripts branchés
status: todo
phase: 0 Socle
depends_on: [T-00]
manual: true
estimate: S
model: opus
done_at:
---

# T-01 · Analyse stricte, FVM, hooks et scripts branchés

## Objectif

L'analyse Dart est stricte, les hooks Claude Code et les scripts de contrôle tournent sur le projet réel.

## Contexte

- .claude/rules/architecture.md
- scripts/*.sh
- .claude/settings.json
- `.claude/rules/` applicables et `CLAUDE.md`.

## Étape manuelle

**Actions**
1. Installer Xcode depuis le Mac App Store, l'ouvrir une fois et accepter la licence (seule étape sans ligne de commande ; voir docs/manual-setup.md, T-01)

- [ ] Confirmé par Rayan (date : )

**Vérifications automatisables**
- `xcodebuild -version` répond
- `scripts/ops/bootstrap-macos.sh --check` est vert (FVM, Flutter de .fvmrc, CLI Supabase, Docker, Deno, CocoaPods, fastlane, jq, Android SDK)

## Étapes

1. Écrire `scripts/ops/bootstrap-macos.sh` (Homebrew : fvm, supabase/tap/supabase, deno, jq, cocoapods, fastlane, `--cask docker android-studio android-commandlinetools` ; `fvm install` depuis .fvmrc ; `sdkmanager` pour platform-tools, platforms;android-36, build-tools ; `flutter doctor --android-licenses` ; option `--check` qui vérifie sans installer) et l'exécuter.
2. `analysis_options.yaml` : `include: package:flutter_lints/flutter.yaml`, `language: strict-casts: true, strict-inference: true, strict-raw-types: true`, règles supplémentaires `prefer_const_constructors`, `prefer_final_locals`, `avoid_print`, `always_declare_return_types`, `unawaited_futures`, `cancel_subscriptions`, `close_sinks`, `public_member_api_docs: false` ; exclusion de `**/*.g.dart`, `**/*.freezed.dart`.
3. Vérifier que le hook Stop lance `flutter analyze` (créer `.dart_tool` est fait par pub get).
4. Vérifier `scripts/check-architecture.sh` et `check-strings.sh` sur un fichier de test volontairement fautif (temporaire, non commité) puis le retirer.
5. `make check` vert.

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
- [ ] Commit unique `chore(T-01): Analyse stricte, FVM, hooks et scripts branchés` sur `dev`, sans push (ou rien à committer pour une tâche purement manuelle)

## Notes de revue
