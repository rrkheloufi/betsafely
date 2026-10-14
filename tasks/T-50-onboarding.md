---
id: T-50
title: Onboarding ON-01 à ON-03, ON-07, ON-08 et reprise
status: todo
phase: 5 Onboarding
depends_on: [T-31, T-05, T-06, T-07]
manual: false
estimate: L
model: opus
done_at:
---

# T-50 · Onboarding ON-01 à ON-03, ON-07, ON-08 et reprise

## Objectif

L'onboarding se parcourt en moins de 2 minutes, l'âge refusé mène à l'écran de sortie définitif, les réglages sont préremplis, la reprise se fait à l'étape mémorisée.

## Contexte

- brief F-01
- docs/design-tokens.md (ON-01 à ON-03, ON-07, ON-08, ON-02b)
- docs/architecture.md section 2 (onboarding)
- `.claude/rules/` applicables et `CLAUDE.md`.

## Étapes

1. `OnboardingViewModel` : étape courante persistée (`settings.onboarding_step`), commandes `confirmAge`, `declineAge` (persiste `age_declined`, redirection `/blocked` sans retour), `saveSettings`, `skip`, `requestNotifications` (délégué à NotificationRepository, stub jusqu'à T-80), `finish` (marque `done`, puis paywall placement `onboarding` via SubscriptionRepository, stub jusqu'à T-110).
2. Écrans ON-01, ON-02, ON-02b (ressource d'aide du pays depuis ReferenceRepository, boutons Appeler et Site web via url_launcher), ON-03 (PickerField pays, devise, SegmentedControl format de cote), ON-07 (MoneyField, ChoiceChip 50/100/200/300, budget global du mois via BudgetRepository stub jusqu'à T-70), ON-08 (aperçu de notification, bouton Activer).
3. `ProgressDots` : 6 points (âge, réglages, bilan, budget, notifications, paywall) ; ON-04 à ON-06 branchés en T-51.
4. Gardes du routeur : `/blocked` terminal, reprise à l'étape mémorisée.

## Tests

| Test (comportement vérifié) | Fichier | Commande |
|---|---|---|
| confirmAge avance, declineAge persiste le refus ; finish marque l'onboarding terminé | `test/ui/onboarding/view_models/onboarding_view_model_test.dart` | `flutter test test/ui/onboarding/view_models/onboarding_view_model_test.dart` |
| ON-02 : le tap sur « J'ai moins de 18 ans » appelle declineAge (widget) | `test/ui/onboarding/widgets/age_screen_test.dart` | `flutter test test/ui/onboarding/widgets/age_screen_test.dart` |

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
- [ ] Commit unique `feat(T-50): Onboarding ON-01 à ON-03, ON-07, ON-08 et reprise` sur `dev`, sans push (ou rien à committer pour une tâche purement manuelle)

## Notes de revue
