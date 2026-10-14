---
id: T-138
title: Mise à jour obligatoire et écran de démarrage
status: todo
phase: 13 Profil et finitions
depends_on: [T-137, T-30]
manual: false
estimate: S
model: opus
done_at:
---

# T-138 · Mise à jour obligatoire et écran de démarrage

## Objectif

Au lancement en ligne, si la version installée est inférieure à `app_config.min_version_<plateforme>`, un écran bloquant renvoie vers le store ; hors ligne, l'app démarre normalement.

## Contexte

- cadrage décision 35
- docs/database.md (app_config)
- docs/architecture.md section 1 (ordre des redirections)
- `.claude/rules/` applicables et `CLAUDE.md`.

## Étapes

1. `StartupViewModel` : amorçage ordonné (préférences, référentiel, session, RevenueCat, notifications, synchro), comparaison de version (`package_info_plus`, semver), redirection `/update-required`.
2. Écran `/update-required` avec lien vers le store (`url_launcher`).

## Tests

| Test (comportement vérifié) | Fichier | Commande |
|---|---|---|
| La comparaison semver bloque 1.0.0 < 1.1.0 et laisse passer 1.1.0 et hors ligne | `test/ui/startup/view_models/startup_view_model_test.dart` | `flutter test test/ui/startup/view_models/startup_view_model_test.dart` |

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
- [ ] Commit unique `feat(T-138): Mise à jour obligatoire et écran de démarrage` sur `dev`, sans push (ou rien à committer pour une tâche purement manuelle)

## Notes de revue
