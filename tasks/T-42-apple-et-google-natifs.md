---
id: T-42
title: Connexion Apple et Google par jeton natif
status: todo
phase: 4 Authentification et compte
depends_on: [T-41]
manual: false
estimate: L
model: fable
done_at:
---

# T-42 · Connexion Apple et Google par jeton natif

## Objectif

`linkWithApple` (iOS) et `linkWithGoogle` rattachent l'identité à la session anonyme par `linkIdentityWithIdToken` ; si l'identité appartient déjà à un compte, l'app se connecte à ce compte et conserve les données locales pour fusion.

## Contexte

- docs/architecture.md section 6 (activation de la synchro)
- cadrage décisions 9, 10, 11
- supabase.com/docs/reference/dart/auth-linkidentitywithidtoken
- `.claude/rules/` applicables et `CLAUDE.md`.
- Tâche marquée `model: fable` : une erreur y est coûteuse ou silencieuse ; Fable 5.1 conseillé.

## Étapes

1. `AppleSignInService` (`sign_in_with_apple`, nonce brut et haché), `GoogleSignInService` (`google_sign_in`, clients iOS, Android et web depuis `env`, idToken et accessToken).
2. `AuthRepositoryImpl.linkWithApple/linkWithGoogle` : `linkIdentityWithIdToken(provider, idToken, accessToken, nonce)` ; erreur « identity already exists » → `signInWithIdToken` avec le même jeton, et marquage `sync_state.needsMerge = true` ; annulation utilisateur → `AppError.validation` silencieuse.
3. Capacité Sign in with Apple dans les deux identifiants iOS (manual-setup T-12) ; Android : `google_sign_in` configuré sans Firebase.
4. Si la liaison native d'un anonyme est refusée par Supabase, repli `linkIdentity(OAuthProvider.apple|google)` par navigateur avec `redirectTo` (vérifié à l'implémentation, documenté dans Notes de revue).

## Tests

| Test (comportement vérifié) | Fichier | Commande |
|---|---|---|
| linkWithGoogle appelle linkIdentityWithIdToken et bascule sur signInWithIdToken quand l'identité existe déjà (mocktail) | `test/data/repositories/auth/link_identity_test.dart` | `flutter test test/data/repositories/auth/link_identity_test.dart` |

## Sécurité

- [ ] Aucun secret ni valeur réelle dans le diff
- [ ] Aucune dépendance hors de la liste de docs/architecture.md section 10
- [ ] Nonce Apple aléatoire par tentative
- [ ] Aucun jeton stocké hors SDK

## Definition of Done

- [ ] Étapes réalisées
- [ ] Tests du tableau écrits et verts, aucun test superflu
- [ ] Checklist sécurité cochée (ou n/a)
- [ ] `make check` vert (plus `make test-db` et `make test-functions` si `supabase/` est touché)
- [ ] Revue `code-reviewer` : OK ou OK avec réserves consignées
- [ ] Statut `done` avec date dans ce fichier et dans `tasks/INDEX.md`
- [ ] Commit unique `feat(T-42): Connexion Apple et Google par jeton natif` sur `dev`, sans push (ou rien à committer pour une tâche purement manuelle)

## Notes de revue
