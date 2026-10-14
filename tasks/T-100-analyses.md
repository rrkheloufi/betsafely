---
id: T-100
title: Analyses AN-01 et AN-02
status: todo
phase: 10 Analyses et récap
depends_on: [T-73, T-65]
manual: false
estimate: L
model: opus
done_at:
---

# T-100 · Analyses AN-01 et AN-02

## Objectif

L'écran Analyses calcule les indicateurs et graphiques de F-13 sur 5 périodes pour les abonnés, et s'affiche flouté avec incitation pour les gratuits.

## Contexte

- brief F-13, C-05, C-06
- docs/design-tokens.md (AN-01, AN-02, section 1.8 visualisation)
- `.claude/rules/` applicables et `CLAUDE.md`.

## Étapes

1. `lib/domain/logic/analytics_calculator.dart` : total misé, net, ROI, taux réel et nécessaire, cote moyenne (systèmes sans cote exclus), mise moyenne et médiane, plus grosse perte, plus longue série de pertes, signaux ; courbe cumulée ; barres par type, sport, bookmaker, live/avant-match, tranche de cote (< 1,50 ; 1,50 à 1,99 ; 2,00 à 2,99 ; 3,00 à 4,99 ; ≥ 5,00), nombre de sélections.
2. `AnalyticsViewModel` : périodes Mois, 3 mois, 12 mois, Année, Tout ; `AnalyticsReport`.
3. Écran AN-01 avec `fl_chart` (courbe 2 px brand-600, zone brand-100 à 40 %, ligne zéro pointillée ; barres négatives `negative`, positives `positive-chart`, 6 max puis « Voir tout »), carte Signaux ; AN-02 `LockedOverlay` → paywall `analytics`.

## Tests

| Test (comportement vérifié) | Fichier | Commande |
|---|---|---|
| AnalyticsCalculator sur le jeu de données (ROI −43,3 %, cote moyenne 2,13, médiane 8,00 €, barres par sport totalisant −64,50 €) | `test/domain/logic/analytics_calculator_test.dart` | `flutter test test/domain/logic/analytics_calculator_test.dart` |

## Sécurité

- [ ] Aucun secret ni valeur réelle dans le diff
- [ ] Aucune dépendance hors de la liste de docs/architecture.md section 10
- [ ] Droits vérifiés par entitlement

## Definition of Done

- [ ] Étapes réalisées
- [ ] Tests du tableau écrits et verts, aucun test superflu
- [ ] Checklist sécurité cochée (ou n/a)
- [ ] `make check` vert (plus `make test-db` et `make test-functions` si `supabase/` est touché)
- [ ] Revue `code-reviewer` : OK ou OK avec réserves consignées
- [ ] Statut `done` avec date dans ce fichier et dans `tasks/INDEX.md`
- [ ] Commit unique `feat(T-100): Analyses AN-01 et AN-02` sur `dev`, sans push (ou rien à committer pour une tâche purement manuelle)

## Notes de revue
