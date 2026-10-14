---
id: T-63
title: Liste des paris BE-01, filtres et recherche
status: todo
phase: 6 Paris
depends_on: [T-61, T-06]
manual: false
estimate: M
model: opus
done_at:
---

# T-63 · Liste des paris BE-01, filtres et recherche

## Objectif

La liste affiche les paris groupés par jour avec « À régler » en tête, les filtres Tous, En cours, Réglés, les filtres par bookmaker et sport, la recherche, le balayage Gagné et Perdu, et la ligne « N paris plus anciens » pour les gratuits.

## Contexte

- brief F-11, F-05
- docs/design-tokens.md (BE-01, BetRow, ToSettleRow, DayHeader, StatusChip)
- `.claude/rules/` applicables et `CLAUDE.md`.

## Étapes

1. `BetListViewModel` : flux filtré, groupes par jour (fuseau local), section à régler, nombre de paris hors fenêtre gratuite (mois courant et 2 précédents) via `SubscriptionRepository.watchStatus` (stub gratuit jusqu'à T-110), `quickSettle` (use case settle_bet de T-64 ; en attendant BetRepository.settle).
2. Composants `BetRow`, `ToSettleRow`, `DayHeader` collant, `Dismissible` avec actions Gagné et Perdu.
3. Ligne verrouillée → paywall placement `history`.

## Tests

| Test (comportement vérifié) | Fichier | Commande |
|---|---|---|
| Filtres, recherche et groupement par jour sur le jeu de données ; la ligne verrouillée compte les paris hors fenêtre | `test/ui/bets/view_models/bet_list_view_model_test.dart` | `flutter test test/ui/bets/view_models/bet_list_view_model_test.dart` |

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
- [ ] Commit unique `feat(T-63): Liste des paris BE-01, filtres et recherche` sur `dev`, sans push (ou rien à committer pour une tâche purement manuelle)

## Notes de revue
