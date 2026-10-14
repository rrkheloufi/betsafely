---
id: T-70
title: Budget mensuel, jauge et alerte 100 % (BU-01, AL-01)
status: todo
phase: 7 Budget, alertes et pause
depends_on: [T-65]
manual: false
estimate: M
model: opus
done_at:
---

# T-70 · Budget mensuel, jauge et alerte 100 % (BU-01, AL-01)

## Objectif

Le budget global du mois se règle, la jauge suit les paliers de couleur, l'alerte à 100 % s'affiche sans bloquer l'enregistrement, et l'historique des budgets est visible.

## Contexte

- brief F-07, C-04
- docs/design-tokens.md (BU-01, AL-01, BudgetGauge)
- `.claude/rules/` applicables et `CLAUDE.md`.

## Étapes

1. `BudgetRepositoryImpl` sur drift ; `setGlobal` écrit le mois courant (chaque mois garde sa valeur).
2. `lib/domain/logic/budget_evaluator.dart` : consommation (Σ Sr du mois), pourcentage, palier franchi par un enregistrement (50, 80, 100 selon activation), couleur.
3. `record_bet` : après écriture, évalue et renvoie l'alerte à afficher ; `BetFormViewModel` expose `pendingAlert` ; AL-01 (AlertModal) avec Voir mon mois, Activer une pause (T-72), OK, Besoin d'aide.
4. `BudgetViewModel` et écran BU-01 (jauge, MoneyField, bloc verrouillé → paywall `budgets`, historique).
5. Analytics `budget_set`, `alert_shown(type)`.

## Tests

| Test (comportement vérifié) | Fichier | Commande |
|---|---|---|
| BudgetEvaluator : paliers franchis exactement une fois, couleurs, paris gratuits exclus | `test/domain/logic/budget_evaluator_test.dart` | `flutter test test/domain/logic/budget_evaluator_test.dart` |

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
- [ ] Commit unique `feat(T-70): Budget mensuel, jauge et alerte 100 % (BU-01, AL-01)` sur `dev`, sans push (ou rien à committer pour une tâche purement manuelle)

## Notes de revue
