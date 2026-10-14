---
id: T-71
title: Paliers, budgets détaillés et projection (BU-02, AL-02)
status: todo
phase: 7 Budget, alertes et pause
depends_on: [T-70]
manual: false
estimate: M
model: opus
done_at:
---

# T-71 · Paliers, budgets détaillés et projection (BU-02, AL-02)

## Objectif

En Premium, les paliers 50 et 80 % affichent une bannière, les budgets par bookmaker et par sport ont les mêmes paliers, et la projection C-11 s'affiche dès le 5e jour.

## Contexte

- brief F-08, C-11
- docs/design-tokens.md (BU-02, AL-02)
- `.claude/rules/` applicables et `CLAUDE.md`.

## Étapes

1. `BudgetEvaluator` : budgets `scope` bookmaker et sport, projection (C-11, jours écoulés, jour d'atteinte estimé).
2. `BudgetViewModel` : paliers activables, ajout et suppression de budgets détaillés, projection ; tout gardé par l'entitlement (sinon paywall `alerts` ou `budgets`).
3. AL-02 : `Banner` d'avertissement fermable en haut de l'accueil ; `alerts_log` type `budget_50`, `budget_80`, `projection`.

## Tests

| Test (comportement vérifié) | Fichier | Commande |
|---|---|---|
| Projection C-11 et jour d'atteinte ; paliers par bookmaker et par sport | `test/domain/logic/budget_projection_test.dart` | `flutter test test/domain/logic/budget_projection_test.dart` |
| Sans entitlement, setScopedBudget et toggleThreshold renvoient une erreur et ouvrent le paywall | `test/ui/budget/view_models/budget_view_model_test.dart` | `flutter test test/ui/budget/view_models/budget_view_model_test.dart` |

## Sécurité

- [ ] Aucun secret ni valeur réelle dans le diff
- [ ] Aucune dépendance hors de la liste de docs/architecture.md section 10
- [ ] Droits vérifiés par entitlement uniquement

## Definition of Done

- [ ] Étapes réalisées
- [ ] Tests du tableau écrits et verts, aucun test superflu
- [ ] Checklist sécurité cochée (ou n/a)
- [ ] `make check` vert (plus `make test-db` et `make test-functions` si `supabase/` est touché)
- [ ] Revue `code-reviewer` : OK ou OK avec réserves consignées
- [ ] Statut `done` avec date dans ce fichier et dans `tasks/INDEX.md`
- [ ] Commit unique `feat(T-71): Paliers, budgets détaillés et projection (BU-02, AL-02)` sur `dev`, sans push (ou rien à committer pour une tâche purement manuelle)

## Notes de revue
