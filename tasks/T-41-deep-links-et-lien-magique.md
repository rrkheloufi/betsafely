---
id: T-41
title: Liens profonds et lien magique
status: todo
phase: 4 Authentification et compte
depends_on: [T-40, T-05]
manual: false
estimate: M
model: fable
done_at:
---

# T-41 · Liens profonds et lien magique

## Objectif

Le schéma `fr.rsquare.betsafely[.dev]://auth-callback` est enregistré sur iOS et Android, `sendMagicLink` envoie un lien et son ouverture lie l'e-mail à la session en cours.

## Contexte

- docs/architecture.md section 1 (liens profonds)
- brief F-17
- cadrage décisions 12, 13
- `.claude/rules/` applicables et `CLAUDE.md`.
- Tâche marquée `model: fable` : une erreur y est coûteuse ou silencieuse ; Fable 5.1 conseillé.

## Étapes

1. Android : `intent-filter` avec le schéma par flavor (manifestPlaceholders) ; iOS : `CFBundleURLTypes` par xcconfig.
2. `AuthRepositoryImpl.sendMagicLink(email)` : utilisateur anonyme → `updateUser(UserAttributes(email))` puis `signInWithOtp(email, emailRedirectTo: Env.authRedirectUrl, shouldCreateUser: false)` ; e-mail validé (regexp simple, longueur).
3. `SupabaseService` gère le retour PKCE (`supabase_flutter` traite l'URL entrante) ; `watchUser` émet l'utilisateur lié ; `Purchases.logIn` déclenché en T-110 si l'uid change.
4. Validation du lien entrant : schéma et hôte attendus seulement, sinon ignoré.

## Tests

| Test (comportement vérifié) | Fichier | Commande |
|---|---|---|
| sendMagicLink refuse un e-mail invalide et appelle updateUser puis signInWithOtp pour un anonyme | `test/data/repositories/auth/magic_link_test.dart` | `flutter test test/data/repositories/auth/magic_link_test.dart` |

## Sécurité

- [ ] Aucun secret ni valeur réelle dans le diff
- [ ] Aucune dépendance hors de la liste de docs/architecture.md section 10
- [ ] Lien entrant validé (schéma, hôte)
- [ ] Aucun e-mail dans les logs

## Definition of Done

- [ ] Étapes réalisées
- [ ] Tests du tableau écrits et verts, aucun test superflu
- [ ] Checklist sécurité cochée (ou n/a)
- [ ] `make check` vert (plus `make test-db` et `make test-functions` si `supabase/` est touché)
- [ ] Revue `code-reviewer` : OK ou OK avec réserves consignées
- [ ] Statut `done` avec date dans ce fichier et dans `tasks/INDEX.md`
- [ ] Commit unique `feat(T-41): Liens profonds et lien magique` sur `dev`, sans push (ou rien à committer pour une tâche purement manuelle)

## Notes de revue
