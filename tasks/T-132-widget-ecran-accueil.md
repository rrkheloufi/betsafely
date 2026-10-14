---
id: T-132
title: Widget d'écran d'accueil iOS et Android
status: todo
phase: 13 Profil et finitions
depends_on: [T-110, T-70]
manual: false
estimate: L
model: opus
done_at:
---

# T-132 · Widget d'écran d'accueil iOS et Android

## Objectif

Les widgets petit et moyen (iOS) et 2×2, 4×2 (Android) affichent le mois, le résultat net (masqué par défaut), la jauge et le nombre de paris à régler, s'ouvrent sur l'app, et affichent « Disponible avec Premium » pour les gratuits.

## Contexte

- brief F-19
- docs/design-tokens.md (WI-01, WI-02)
- docs/architecture.md section 1 (liens profonds)
- `.claude/rules/` applicables et `CLAUDE.md`.

## Étapes

1. `HomeWidgetService` (`home_widget`) : App Group `group.fr.rsquare.betsafely` (et `.dev`), clés `month`, `net`, `budgetPercent`, `toSettleCount`, `toSettleTitle`, `amountsHidden`, `premium`.
2. iOS : extension WidgetKit `BetSafelyWidget` (SwiftUI, tailles small et medium, tokens du design, deep link `betsafely://bets/<id>?settle=1` vers `/home` sinon). Android : `AppWidgetProvider` avec layouts 2×2 et 4×2.
3. `WidgetRepositoryImpl.refresh()` appelé par `record_bet`, `settle_bet`, le changement de budget et de statut Premium ; action « Régler » ouvre la feuille de règlement.
4. Pas de couleur en dur côté natif hors d'un fichier de tokens dédié (`WidgetTokens.swift`, `colors.xml`).

## Tests

| Test (comportement vérifié) | Fichier | Commande |
|---|---|---|
| WidgetRepository écrit les clés attendues et masque les montants par défaut (fake du service) | `test/data/repositories/widget/widget_repository_test.dart` | `flutter test test/data/repositories/widget/widget_repository_test.dart` |

## Sécurité

- [ ] Aucun secret ni valeur réelle dans le diff
- [ ] Aucune dépendance hors de la liste de docs/architecture.md section 10
- [ ] Le widget ne contient jamais un montant si l'option masquer est active

## Definition of Done

- [ ] Étapes réalisées
- [ ] Tests du tableau écrits et verts, aucun test superflu
- [ ] Checklist sécurité cochée (ou n/a)
- [ ] `make check` vert (plus `make test-db` et `make test-functions` si `supabase/` est touché)
- [ ] Revue `code-reviewer` : OK ou OK avec réserves consignées
- [ ] Statut `done` avec date dans ce fichier et dans `tasks/INDEX.md`
- [ ] Commit unique `feat(T-132): Widget d'écran d'accueil iOS et Android` sur `dev`, sans push (ou rien à committer pour une tâche purement manuelle)

## Notes de revue
