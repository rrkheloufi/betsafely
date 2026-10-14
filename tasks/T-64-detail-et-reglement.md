---
id: T-64
title: Détail BE-02, règlement BE-03 et use case settle_bet
status: todo
phase: 6 Paris
depends_on: [T-63]
manual: false
estimate: M
model: opus
done_at:
---

# T-64 · Détail BE-02, règlement BE-03 et use case settle_bet

## Objectif

Le détail affiche toutes les valeurs du pari, le règlement propose les 5 statuts avec montant saisi pour Cash out et Autre, et un pari réglé reste modifiable.

## Contexte

- brief F-05, C-02, C-03
- docs/design-tokens.md (BE-02, BE-03)
- docs/architecture.md section 9 (use case settle_bet)
- `.claude/rules/` applicables et `CLAUDE.md`.

## Étapes

1. `lib/domain/use_cases/settle_bet.dart` : applique le règlement via BetRepository, puis budget N-02 (T-70), replanification des notifications (T-80), widget (T-132), analytics `bet_settled(source)` ; utilisé par le détail, l'accueil, la liste, la notification et le widget.
2. `BetDetailViewModel` : pari, retour potentiel, heure de notification prévue, commandes `settle`, `duplicate` (navigation vers `/bets/new?from=`), `delete` avec confirmation.
3. Écrans BE-02 (grille de valeurs, menu Modifier, Dupliquer, Supprimer, bannière de notification) et feuille BE-03 (ChoiceChip 44 de haut, MoneyField conditionnel, ligne de résultat signée).
4. Retour haptique léger au règlement, jamais différent pour un gain.

## Tests

| Test (comportement vérifié) | Fichier | Commande |
|---|---|---|
| settle calcule le résultat selon le statut et exige un montant pour Cash out et Autre | `test/ui/bet_detail/view_models/bet_detail_view_model_test.dart` | `flutter test test/ui/bet_detail/view_models/bet_detail_view_model_test.dart` |
| BE-03 : choisir Cash out affiche le champ montant et Enregistrer appelle settle (widget) | `test/ui/bet_detail/widgets/settle_sheet_test.dart` | `flutter test test/ui/bet_detail/widgets/settle_sheet_test.dart` |

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
- [ ] Commit unique `feat(T-64): Détail BE-02, règlement BE-03 et use case settle_bet` sur `dev`, sans push (ou rien à committer pour une tâche purement manuelle)

## Notes de revue
