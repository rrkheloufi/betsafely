---
id: T-72
title: Mode Pause (PA-01, PA-02, AL-04, HO-04, historique)
status: todo
phase: 7 Budget, alertes et pause
depends_on: [T-70]
manual: false
estimate: M
model: opus
done_at:
---

# T-72 · Mode Pause (PA-01, PA-02, AL-04, HO-04, historique)

## Objectif

Une pause de 24 h, 7 j, 30 j ou sans fin s'active, s'affiche sur l'accueil avec l'estimation C-10, se termine par un pari (AL-04) ou à la main (PA-02), et entre dans l'historique.

## Contexte

- brief F-15, C-10, N-05
- docs/design-tokens.md (PA-01, PA-02, AL-04, HO-04, PauseCard)
- `.claude/rules/` applicables et `CLAUDE.md`.

## Étapes

1. `PauseRepositoryImpl` sur drift ; `start` refuse si une pause est active ; expiration automatique évaluée à la lecture (`planned_end_at < now` → `end(expired)`).
2. `BetMath.pauseEstimate` (C-10) ; moins de 5 paris → jours seulement.
3. `PauseViewModel`, écrans PA-01 (ChoiceChip 44, interrupteur jalons N-05 → T-81), PA-02, `/profile/pauses` ; `record_bet` : pause active → AL-04 avant écriture ; HO-04 (`PauseCard`).
4. Analytics `pause_started(duration)`.

## Tests

| Test (comportement vérifié) | Fichier | Commande |
|---|---|---|
| C-10 : estimation et seuil de 5 paris ; start/end et expiration automatique | `test/ui/pause/view_models/pause_view_model_test.dart` | `flutter test test/ui/pause/view_models/pause_view_model_test.dart` |

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
- [ ] Commit unique `feat(T-72): Mode Pause (PA-01, PA-02, AL-04, HO-04, historique)` sur `dev`, sans push (ou rien à committer pour une tâche purement manuelle)

## Notes de revue
