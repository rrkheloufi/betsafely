---
id: T-31
title: PreferencesRepository et réglages locaux
status: todo
phase: 3 Référentiel et préférences
depends_on: [T-09, T-07]
manual: false
estimate: M
model: opus
done_at:
---

# T-31 · PreferencesRepository et réglages locaux

## Objectif

Les préférences (langue, pays, devise, format de cote, onboarding, bookmakers et sports favoris, réglages de notifications et de confidentialité) sont lues et écrites localement et la langue de l'app suit la préférence.

## Contexte

- docs/architecture.md section 3.2
- brief 5.2, F-20
- `.claude/rules/` applicables et `CLAUDE.md`.

## Étapes

1. `PreferencesRepositoryImpl` sur `settings` (clé-valeur) et `user_preferences`, `user_bookmakers`, `user_sports` locales ; valeurs par défaut depuis la région du téléphone (`PlatformDispatcher.locale`) et `countries`.
2. Changement de devise : aucun avertissement, aucune conversion (décision 17).
3. `App` écoute la langue préférée pour `locale`.
4. Réglages de notifications et de confidentialité exposés (consommés en T-81, T-131).

## Tests

| Test (comportement vérifié) | Fichier | Commande |
|---|---|---|
| Les valeurs par défaut suivent la région (fr-FR → France, EUR, décimal ; en-US → US, USD, américain) et les écritures sont relues | `test/data/repositories/preferences/preferences_repository_test.dart` | `flutter test test/data/repositories/preferences/preferences_repository_test.dart` |

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
- [ ] Commit unique `feat(T-31): PreferencesRepository et réglages locaux` sur `dev`, sans push (ou rien à committer pour une tâche purement manuelle)

## Notes de revue
