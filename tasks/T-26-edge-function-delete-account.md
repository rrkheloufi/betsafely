---
id: T-26
title: Edge Function delete-account
status: todo
phase: 2 Backend
depends_on: [T-25]
manual: false
estimate: M
model: fable
done_at:
---

# T-26 · Edge Function delete-account

## Objectif

`delete-account` supprime toutes les données en ligne de l'utilisateur appelant, son client RevenueCat et son compte Auth, et répond 200 même si l'utilisateur était anonyme.

## Contexte

- docs/database.md section 3
- brief F-17 (suppression de compte)
- docs/architecture.md section 6 (suppression de compte)
- `.claude/rules/` applicables et `CLAUDE.md`.
- Tâche marquée `model: fable` : une erreur y est coûteuse ou silencieuse ; Fable 5.1 conseillé.

## Étapes

1. `delete-account/index.ts` : JWT obligatoire ; `uid = auth.uid()` ; dans l'ordre avec le client service_role : suppression des 9 tables utilisateur (`delete where user_id = uid`, suppression physique), `scan_counters`, `entitlements` ; `DELETE /v2/projects/{project}/customers/{uid}` sur l'API RevenueCat (échec non bloquant mais journalisé sans identifiant) ; `auth.admin.deleteUser(uid)` ; 200 `{ deleted: true }`.
2. `index_test.ts` : 401 sans JWT ; 200 nominal avec clients factices appelés dans l'ordre ; 200 si RevenueCat répond 404.

## Tests

| Test (comportement vérifié) | Fichier | Commande |
|---|---|---|
| 401 sans session, suppression nominale dans l'ordre, tolérance 404 RevenueCat | `supabase/functions/delete-account/index_test.ts` | `make test-functions` |

## Sécurité

- [ ] Aucun secret ni valeur réelle dans le diff
- [ ] Aucune dépendance hors de la liste de docs/architecture.md section 10
- [ ] L'uid vient du JWT, jamais du corps de la requête
- [ ] Clé service_role via Deno.env uniquement

## Definition of Done

- [ ] Étapes réalisées
- [ ] Tests du tableau écrits et verts, aucun test superflu
- [ ] Checklist sécurité cochée (ou n/a)
- [ ] `make check` vert (plus `make test-db` et `make test-functions` si `supabase/` est touché)
- [ ] Revue `code-reviewer` : OK ou OK avec réserves consignées
- [ ] Statut `done` avec date dans ce fichier et dans `tasks/INDEX.md`
- [ ] Commit unique `feat(T-26): Edge Function delete-account` sur `dev`, sans push (ou rien à committer pour une tâche purement manuelle)

## Notes de revue
