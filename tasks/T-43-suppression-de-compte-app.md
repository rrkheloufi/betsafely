---
id: T-43
title: Suppression de compte et effacement local
status: todo
phase: 4 Authentification et compte
depends_on: [T-42, T-26]
manual: false
estimate: M
model: fable
done_at:
---

# T-43 · Suppression de compte et effacement local

## Objectif

`AuthRepository.deleteAccount` appelle `delete-account`, déconnecte, propose de garder ou d'effacer les données locales, et l'effacement local des utilisateurs gratuits supprime aussi l'utilisateur anonyme côté serveur.

## Contexte

- brief F-17, F-20 (Données)
- cadrage décisions 14, 15
- docs/architecture.md section 6
- `.claude/rules/` applicables et `CLAUDE.md`.
- Tâche marquée `model: fable` : une erreur y est coûteuse ou silencieuse ; Fable 5.1 conseillé.

## Étapes

1. `AuthRepositoryImpl.deleteAccount()` : `functions.invoke('delete-account')` ; succès → `signOut()` ; hors ligne → `AppError.network`.
2. `DataViewModel.wipeLocal` : double confirmation (écran en T-130), efface toutes les tables locales et `settings` sauf `age_confirmed`, appelle `deleteAccount` si une session existe, reprogramme les notifications (vide), rafraîchit le widget.
3. Après suppression : nouvelle session anonyme au prochain lancement en ligne (T-40).

## Tests

| Test (comportement vérifié) | Fichier | Commande |
|---|---|---|
| deleteAccount invoque la fonction puis signOut, et wipeLocal vide les tables puis appelle deleteAccount | `test/data/repositories/auth/delete_account_test.dart` | `flutter test test/data/repositories/auth/delete_account_test.dart` |

## Sécurité

- [ ] Aucun secret ni valeur réelle dans le diff
- [ ] Aucune dépendance hors de la liste de docs/architecture.md section 10
- [ ] Aucune suppression distante sans session valide

## Definition of Done

- [ ] Étapes réalisées
- [ ] Tests du tableau écrits et verts, aucun test superflu
- [ ] Checklist sécurité cochée (ou n/a)
- [ ] `make check` vert (plus `make test-db` et `make test-functions` si `supabase/` est touché)
- [ ] Revue `code-reviewer` : OK ou OK avec réserves consignées
- [ ] Statut `done` avec date dans ce fichier et dans `tasks/INDEX.md`
- [ ] Commit unique `feat(T-43): Suppression de compte et effacement local` sur `dev`, sans push (ou rien à committer pour une tâche purement manuelle)

## Notes de revue
