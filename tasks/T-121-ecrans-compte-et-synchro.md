---
id: T-121
title: Écrans compte AC-01 à AC-04 et fin d'abonnement
status: todo
phase: 12 Synchronisation
depends_on: [T-120, T-43]
manual: false
estimate: M
model: fable
done_at:
---

# T-121 · Écrans compte AC-01 à AC-04 et fin d'abonnement

## Objectif

Après un achat, AC-01 propose Apple, Google ou e-mail ; AC-02 et AC-03 gèrent le lien magique ; AC-04 affiche l'identité, la dernière synchro, la déconnexion, la suppression de compte, et la bannière de fin d'abonnement avec la date de purge.

## Contexte

- brief F-17
- docs/design-tokens.md (AC-01 à AC-04)
- docs/architecture.md section 2 (account)
- `.claude/rules/` applicables et `CLAUDE.md`.
- Tâche marquée `model: fable` : une erreur y est coûteuse ou silencieuse ; Fable 5.1 conseillé.

## Étapes

1. `AccountViewModel` : identité, `lastSyncAt`, `syncState`, `purgeDate`, commandes `linkApple` (iOS seulement), `linkGoogle`, `sendMagicLink`, `signOut` (nouvelle session anonyme, `Purchases.logIn` du nouvel uid), `deleteAccount` (confirmation, puis choix garder ou effacer le local).
2. Écrans AC-01 (boutons officiels Apple et Google, Plus tard), AC-02, AC-03 (Renvoyer), AC-04 et confirmation de suppression, bannière « Tes données restent sur ce téléphone. La copie en ligne sera supprimée le [date]. » ; bannière « Reconnecte-toi » si la session est révoquée.
3. Profil > Compte et synchro verrouillé pour les gratuits (paywall `sync`).

## Tests

| Test (comportement vérifié) | Fichier | Commande |
|---|---|---|
| AccountViewModel : transitions lien magique, déconnexion crée une nouvelle session, suppression demande confirmation puis choix local | `test/ui/account/view_models/account_view_model_test.dart` | `flutter test test/ui/account/view_models/account_view_model_test.dart` |

## Sécurité

- [ ] Aucun secret ni valeur réelle dans le diff
- [ ] Aucune dépendance hors de la liste de docs/architecture.md section 10
- [ ] Suppression de compte accessible en 3 taps depuis le profil
- [ ] Apple proposé partout où Google l'est sur iOS

## Definition of Done

- [ ] Étapes réalisées
- [ ] Tests du tableau écrits et verts, aucun test superflu
- [ ] Checklist sécurité cochée (ou n/a)
- [ ] `make check` vert (plus `make test-db` et `make test-functions` si `supabase/` est touché)
- [ ] Revue `code-reviewer` : OK ou OK avec réserves consignées
- [ ] Statut `done` avec date dans ce fichier et dans `tasks/INDEX.md`
- [ ] Commit unique `feat(T-121): Écrans compte AC-01 à AC-04 et fin d'abonnement` sur `dev`, sans push (ou rien à committer pour une tâche purement manuelle)

## Notes de revue
