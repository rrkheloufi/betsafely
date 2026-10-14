---
id: T-40
title: SupabaseService et session anonyme
status: todo
phase: 4 Authentification et compte
depends_on: [T-30, T-31, T-11]
manual: false
estimate: M
model: fable
done_at:
---

# T-40 · SupabaseService et session anonyme

## Objectif

L'app initialise Supabase au bootstrap, crée une session anonyme au premier lancement en ligne (nouvelle tentative à chaque lancement sinon) et expose `AuthRepository.watchUser`.

## Contexte

- docs/architecture.md sections 3.1, 6 (premier lancement)
- cadrage décisions 8, 36
- supabase.com/docs/guides/auth/auth-anonymous
- `.claude/rules/` applicables et `CLAUDE.md`.
- Tâche marquée `model: fable` : une erreur y est coûteuse ou silencieuse ; Fable 5.1 conseillé.

## Étapes

1. `SupabaseService` : `Supabase.initialize(url, anonKey: publishableKey, authOptions: FlutterAuthClientOptions(authFlowType: pkce))`, stockage de session par défaut du SDK ; sur Android, exclure le stockage de session de l'Auto Backup (`backup_rules.xml`).
2. `AuthRepositoryImpl.ensureAnonymousSession()` : si aucune session, `signInAnonymously()` ; erreurs réseau → `AppError.network` sans bloquer ; `watchUser` depuis `onAuthStateChange` ; `AppUser(uid, isAnonymous, email, provider)`.
3. `bootstrap` appelle `ensureAnonymousSession` sans attendre (fire and forget, résultat observé).
4. Session révoquée ou invalide : `signOut` local puis nouvelle session anonyme ; bannière gérée en T-121.

## Tests

| Test (comportement vérifié) | Fichier | Commande |
|---|---|---|
| ensureAnonymousSession ne crée une session que s'il n'y en a pas et traduit une panne réseau en AppError.network (mocktail sur le client) | `test/data/repositories/auth/auth_repository_test.dart` | `flutter test test/data/repositories/auth/auth_repository_test.dart` |

## Sécurité

- [ ] Aucun secret ni valeur réelle dans le diff
- [ ] Aucune dépendance hors de la liste de docs/architecture.md section 10
- [ ] Clé publishable uniquement
- [ ] Session exclue de la sauvegarde Android

## Definition of Done

- [ ] Étapes réalisées
- [ ] Tests du tableau écrits et verts, aucun test superflu
- [ ] Checklist sécurité cochée (ou n/a)
- [ ] `make check` vert (plus `make test-db` et `make test-functions` si `supabase/` est touché)
- [ ] Revue `code-reviewer` : OK ou OK avec réserves consignées
- [ ] Statut `done` avec date dans ce fichier et dans `tasks/INDEX.md`
- [ ] Commit unique `feat(T-40): SupabaseService et session anonyme` sur `dev`, sans push (ou rien à committer pour une tâche purement manuelle)

## Notes de revue
