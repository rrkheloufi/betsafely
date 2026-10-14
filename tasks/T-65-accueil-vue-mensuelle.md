---
id: T-65
title: Accueil HO-01 à HO-05 et constats
status: todo
phase: 6 Paris
depends_on: [T-64, T-51]
manual: false
estimate: L
model: opus
done_at:
---

# T-65 · Accueil HO-01 à HO-05 et constats

## Objectif

L'accueil affiche le mois (navigation, balayage), le résultat net, les tuiles, la jauge (sans projection avant T-71), le constat, « À régler », « Depuis le début », la bannière de récap (stub avant T-101) et le verrouillage des mois anciens.

## Contexte

- brief F-10, F-12, C-04, C-06, C-09
- docs/design-tokens.md (HO-01 à HO-05, NetAmountCard, StatTile, BudgetGauge, InsightCard, LockedOverlay)
- `.claude/rules/` applicables et `CLAUDE.md`.

## Étapes

1. `lib/domain/logic/month_summary_builder.dart` : total misé, net, nombre, gagnés/perdus, taux réel et nécessaire, engagé ; `insight_selector.dart` : I-01 à I-07, au moins 5 paris réglés, un seul constat (écart absolu max) en gratuit, tous en Premium.
2. `HomeViewModel` : mois courant, bornes (premier mois = premier pari, pas de futur), `MonthSummary`, jauge depuis BudgetRepository (stub jusqu'à T-70), à régler, total depuis le début (C-09), pause (T-72), bannière récap (T-101), verrou si mois < courant − 2 et non Premium.
3. Écrans HO-01, HO-02 (vide + carte Fais le point), HO-03 (LockedOverlay → paywall `history`), HO-05 (bannière), glissement horizontal 250 ms (fondu si mouvement réduit), bouton Aide (bouée) vers `/help`.

## Tests

| Test (comportement vérifié) | Fichier | Commande |
|---|---|---|
| MonthSummaryBuilder et InsightSelector sur le jeu de données d'octobre (−64,50 €, 40 %, 47 %, constat combinés) | `test/domain/logic/month_summary_test.dart` | `flutter test test/domain/logic/month_summary_test.dart` |
| HomeViewModel verrouille les mois anciens en gratuit et borne la navigation | `test/ui/home/view_models/home_view_model_test.dart` | `flutter test test/ui/home/view_models/home_view_model_test.dart` |

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
- [ ] Commit unique `feat(T-65): Accueil HO-01 à HO-05 et constats` sur `dev`, sans push (ou rien à committer pour une tâche purement manuelle)

## Notes de revue
