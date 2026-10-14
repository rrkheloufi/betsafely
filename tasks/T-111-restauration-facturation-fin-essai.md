---
id: T-111
title: Restauration, abonnement dans le profil, erreur de facturation, N-04
status: todo
phase: 11 Monétisation
depends_on: [T-110, T-81]
manual: false
estimate: M
model: opus
done_at:
---

# T-111 · Restauration, abonnement dans le profil, erreur de facturation, N-04

## Objectif

« Restaurer les achats » et « Gérer l'abonnement » sont accessibles depuis le profil, un problème de facturation affiche une bannière avec lien de gestion, et N-04 est programmée 2 jours avant la fin de l'essai.

## Contexte

- docs/monetisation.md sections 2 et 3
- brief F-20 (Abonnement), N-04
- cadrage décisions 26, 27
- `.claude/rules/` applicables et `CLAUDE.md`.

## Étapes

1. Carte d'abonnement PR-01 (gratuit : Passer à Premium ; Premium : type et date de renouvellement), lignes Gérer l'abonnement (`managementURL`), Restaurer les achats (résultat en Toast).
2. Bannière de facturation (profil et accueil) quand `billingIssueAt` est non nul ; aucun droit sans entitlement actif (pas de grâce).
3. `NotificationPlanner` : N-04 à `expiresAt − 2 jours` quand `isTrial`, annulée si l'essai se convertit ou expire.
4. AC-01 proposé après un achat si l'utilisateur est anonyme (écran en T-121 ; ici la navigation).

## Tests

| Test (comportement vérifié) | Fichier | Commande |
|---|---|---|
| N-04 programmée à expiresAt − 2 j seulement en essai et annulée hors essai | `test/domain/logic/notification_planner_trial_test.dart` | `flutter test test/domain/logic/notification_planner_trial_test.dart` |

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
- [ ] Commit unique `feat(T-111): Restauration, abonnement dans le profil, erreur de facturation, N-04` sur `dev`, sans push (ou rien à committer pour une tâche purement manuelle)

## Notes de revue
