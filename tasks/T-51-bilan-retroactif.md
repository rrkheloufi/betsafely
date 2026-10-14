---
id: T-51
title: Bilan rétroactif (ON-04 à ON-06, Profil > Mon bilan initial)
status: todo
phase: 5 Onboarding
depends_on: [T-50, T-09, T-30]
manual: false
estimate: M
model: opus
done_at:
---

# T-51 · Bilan rétroactif (ON-04 à ON-06, Profil > Mon bilan initial)

## Objectif

L'utilisateur saisit 1 à N bookmakers avec dépôts, retraits, solde et date de début, voit le résultat C-09 avec un équivalent et la phrase du pays, et peut le modifier depuis le profil.

## Contexte

- brief F-02, C-09
- docs/design-tokens.md (ON-04 à ON-06)
- docs/architecture.md section 2 (retro)
- `.claude/rules/` applicables et `CLAUDE.md`.

## Étapes

1. `RetroBalanceRepositoryImpl` sur drift (`retro_balances`, `dirty`).
2. `lib/domain/logic/equivalent_picker.dart` : unité où le montant fait 1 à 12 unités, pertes et mises seulement, jamais un gain.
3. `RetroViewModel` : lignes, total (C-09, au centime), équivalent, phrase `market_facts` du pays ; validation : montants ≥ 0, solde 0 accepté.
4. Écrans ON-04, ON-05 (formulaire et état liste), ON-06 (variante positive en text-primary) ; route `/profile/retro` réutilisant ON-05 et ON-06.
5. Carte « Fais le point » sur l'accueil (HO-02) tant que le bilan n'est pas fait ou masqué (`settings.retro_card_hidden`).

## Tests

| Test (comportement vérifié) | Fichier | Commande |
|---|---|---|
| C-09 : retraits + solde − dépôts par bookmaker et total, montants négatifs refusés | `test/domain/logic/retro_math_test.dart` | `flutter test test/domain/logic/retro_math_test.dart` |
| EquivalentPicker choisit l'unité entre 1 et 12 et refuse un gain | `test/domain/logic/equivalent_picker_test.dart` | `flutter test test/domain/logic/equivalent_picker_test.dart` |

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
- [ ] Commit unique `feat(T-51): Bilan rétroactif (ON-04 à ON-06, Profil > Mon bilan initial)` sur `dev`, sans push (ou rien à committer pour une tâche purement manuelle)

## Notes de revue
