---
id: T-62
title: Formulaire de saisie AD-01 à AD-04
status: todo
phase: 6 Paris
depends_on: [T-61, T-30, T-31, T-06, T-07]
manual: false
estimate: L
model: opus
done_at:
---

# T-62 · Formulaire de saisie AD-01 à AD-04

## Objectif

Un pari simple s'enregistre en moins de 10 secondes (bookmaker, mise, cote, Enregistrer), les combinés et systèmes se saisissent avec sélections, et le retour potentiel s'affiche en direct.

## Contexte

- brief F-03, 9.1, C-07, C-08
- docs/design-tokens.md (AD-01 à AD-04)
- docs/architecture.md section 2 (bet_form), 9 (use case record_bet)
- `.claude/rules/` applicables et `CLAUDE.md`.

## Étapes

1. `lib/domain/use_cases/record_bet.dart` : valide, enregistre via BetRepository, puis déclenche (par des interfaces, stubs jusqu'aux tâches dédiées) pause (T-72), budget (T-70), chasse (T-73), notifications (T-80), widget (T-132), analytics `bet_created(method)`.
2. `BetFormViewModel` : champs avec valeurs par défaut (dernier bookmaker, dernier sport, aujourd'hui, maintenant), validation (mise > 0, cote décimale ≥ 1,01 ou américaine ≥ +100 ou ≤ −100, 80 et 200 caractères), retour potentiel (C-02 gagné), heure de notification prévue (NotificationPlanner, T-80 ; en attendant 22:00), mode Combiné avec sélections (C-07, cote modifiable, nombre de sélections, `same_event`), mode Système (cote facultative), « Plus d'options ».
3. Écrans AD-01 (feuille avec compteur de scans, stub « 3 scans offerts » jusqu'à T-90), AD-02 (erreur sous le champ), AD-03 (feuille bookmaker : recherche, récents, liste du pays, ajout libre), AD-04 (sélections), feuille Marché, mode édition (`/bets/:id/edit`) et duplication (`?from=`).
4. Retour haptique léger à l'enregistrement.

## Tests

| Test (comportement vérifié) | Fichier | Commande |
|---|---|---|
| Validation des champs, retour potentiel, cote de combiné recalculée et modifiable, commande save appelle le use case | `test/ui/bet_form/view_models/bet_form_view_model_test.dart` | `flutter test test/ui/bet_form/view_models/bet_form_view_model_test.dart` |
| AD-02 : une cote 0,90 affiche le message d'erreur et désactive l'enregistrement (widget) | `test/ui/bet_form/widgets/bet_form_screen_test.dart` | `flutter test test/ui/bet_form/widgets/bet_form_screen_test.dart` |

## Sécurité

- [ ] Aucun secret ni valeur réelle dans le diff
- [ ] Aucune dépendance hors de la liste de docs/architecture.md section 10
- [ ] Longueurs et bornes validées avant écriture

## Definition of Done

- [ ] Étapes réalisées
- [ ] Tests du tableau écrits et verts, aucun test superflu
- [ ] Checklist sécurité cochée (ou n/a)
- [ ] `make check` vert (plus `make test-db` et `make test-functions` si `supabase/` est touché)
- [ ] Revue `code-reviewer` : OK ou OK avec réserves consignées
- [ ] Statut `done` avec date dans ce fichier et dans `tasks/INDEX.md`
- [ ] Commit unique `feat(T-62): Formulaire de saisie AD-01 à AD-04` sur `dev`, sans push (ou rien à committer pour une tâche purement manuelle)

## Notes de revue
