---
id: T-21
title: Migration des tables utilisateur et triggers de synchro
status: todo
phase: 2 Backend
depends_on: [T-20]
manual: false
estimate: M
model: opus
done_at:
---

# T-21 · Migration des tables utilisateur et triggers de synchro

## Objectif

Les 9 tables utilisateur existent avec contraintes, index, colonnes de synchro et le trigger `sync_before_write` ; RLS activée (policies en T-22).

## Contexte

- docs/database.md section 1 (tables utilisateur, fonction sync_before_write)
- `.claude/rules/` applicables et `CLAUDE.md`.

## Étapes

1. `supabase migration new 0002_user_tables` avec le SQL de docs/database.md : user_preferences, user_bookmakers, user_sports, bets, selections, retro_balances, budgets, pauses, alerts_log, contraintes check et index.
2. Trigger `sync_before_write` attaché aux 9 tables.
3. Fonction `is_registered()`.

## Tests

| Test (comportement vérifié) | Fichier | Commande |
|---|---|---|
| sync_before_write refuse une mise à jour plus ancienne (updated_at antérieur) et pose server_updated_at | `supabase/tests/sync_trigger_test.sql` | `make test-db` |
| Les contraintes bets refusent stake_minor <= 0, odds < 1.01 pour un single, et un statut open avec return_minor | `supabase/tests/bets_constraints_test.sql` | `make test-db` |

## Sécurité

- [ ] Aucun secret ni valeur réelle dans le diff
- [ ] Aucune dépendance hors de la liste de docs/architecture.md section 10
- [ ] RLS activée sur chaque table

## Definition of Done

- [ ] Étapes réalisées
- [ ] Tests du tableau écrits et verts, aucun test superflu
- [ ] Checklist sécurité cochée (ou n/a)
- [ ] `make check` vert (plus `make test-db` et `make test-functions` si `supabase/` est touché)
- [ ] Revue `code-reviewer` : OK ou OK avec réserves consignées
- [ ] Statut `done` avec date dans ce fichier et dans `tasks/INDEX.md`
- [ ] Commit unique `feat(T-21): Migration des tables utilisateur et triggers de synchro` sur `dev`, sans push (ou rien à committer pour une tâche purement manuelle)

## Notes de revue
