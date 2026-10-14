---
id: T-27
title: Jobs planifiés de purge
status: todo
phase: 2 Backend
depends_on: [T-25]
manual: false
estimate: S
model: fable
done_at:
---

# T-27 · Jobs planifiés de purge

## Objectif

Les quatre jobs `pg_cron` de docs/database.md existent et une fonction `purge_expired_sync()` testée fait le travail du premier.

## Contexte

- docs/database.md section 1 (jobs planifiés)
- brief F-17 (90 jours)
- cadrage décision 16
- `.claude/rules/` applicables et `CLAUDE.md`.
- Tâche marquée `model: fable` : une erreur y est coûteuse ou silencieuse ; Fable 5.1 conseillé.

## Étapes

1. `supabase migration new 0005_cron_purges` : fonctions `purge_expired_sync()`, `purge_tombstones()`, `purge_inactive_anonymous()`, `purge_revenuecat_events()` (security definer, search_path fixé), puis `cron.schedule` pour chacune.
2. Test : un utilisateur avec `purge_after` passé perd ses lignes, un autre non ; une ligne `deleted_at` de 91 jours disparaît, de 89 jours reste.

## Tests

| Test (comportement vérifié) | Fichier | Commande |
|---|---|---|
| purge_expired_sync et purge_tombstones ne touchent que les lignes attendues | `supabase/tests/purges_test.sql` | `make test-db` |

## Sécurité

- [ ] Aucun secret ni valeur réelle dans le diff
- [ ] Aucune dépendance hors de la liste de docs/architecture.md section 10
- [ ] Les fonctions de purge ne sont pas exécutables par authenticated

## Definition of Done

- [ ] Étapes réalisées
- [ ] Tests du tableau écrits et verts, aucun test superflu
- [ ] Checklist sécurité cochée (ou n/a)
- [ ] `make check` vert (plus `make test-db` et `make test-functions` si `supabase/` est touché)
- [ ] Revue `code-reviewer` : OK ou OK avec réserves consignées
- [ ] Statut `done` avec date dans ce fichier et dans `tasks/INDEX.md`
- [ ] Commit unique `feat(T-27): Jobs planifiés de purge` sur `dev`, sans push (ou rien à committer pour une tâche purement manuelle)

## Notes de revue
