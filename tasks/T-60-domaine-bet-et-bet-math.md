---
id: T-60
title: Domaine Bet et BetMath (C-01 à C-12)
status: todo
phase: 6 Paris
depends_on: [T-04, T-03]
manual: false
estimate: M
model: opus
done_at:
---

# T-60 · Domaine Bet et BetMath (C-01 à C-12)

## Objectif

Les modèles `Bet`, `Selection`, `Settlement` et `BetMath` implémentent C-01 à C-12 et les conversions de cote, couverts par des tests paramétrés.

## Contexte

- brief section 10 (C-01 à C-12), 9.1, 9.2
- docs/architecture.md section 3.3
- `.claude/rules/` applicables et `CLAUDE.md`.

## Étapes

1. `lib/domain/models/bet.dart` (freezed) : champs de docs/database.md `bets` ; `BetType`, `BetStatus`, `BetSource`, `Odds` (valeur ×10000), `Money`.
2. `lib/domain/logic/bet_math.dart` : `realStake` (C-01), `returnFor(status, stake, odds, isFreeBet, custom)` (C-02), `net` (C-03), `monthOf(placedAt, timezone)` (C-04), `roi` (C-05), `winRate` et `requiredWinRate` (C-06), `multiOdds` (C-07), `americanToDecimal` et `decimalToAmerican` (C-08, exemples 1,85 = −118 ; 2,50 = +150 ; −110 = 1,9091), `allTimeTotal` (C-09 avec retro), `pauseEstimate` (C-10), `monthProjection` (C-11), arrondis demi vers le haut en unités mineures (C-12).
3. Pari Système : cote facultative, exclu des moyennes de cote et du taux nécessaire quand elle est absente (décision 18).

## Tests

| Test (comportement vérifié) | Fichier | Commande |
|---|---|---|
| C-01 à C-12 avec les valeurs du brief et du jeu de données (tests paramétrés) | `test/domain/logic/bet_math_test.dart` | `flutter test test/domain/logic/bet_math_test.dart` |
| Conversions de cote dans les deux sens, bornes +100 et −100, arrondis | `test/domain/logic/odds_conversion_test.dart` | `flutter test test/domain/logic/odds_conversion_test.dart` |

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
- [ ] Commit unique `feat(T-60): Domaine Bet et BetMath (C-01 à C-12)` sur `dev`, sans push (ou rien à committer pour une tâche purement manuelle)

## Notes de revue
