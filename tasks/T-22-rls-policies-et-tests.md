---
id: T-22
title: Policies RLS et tests pgTAP
status: todo
phase: 2 Backend
depends_on: [T-21]
manual: false
estimate: L
model: fable
done_at:
---

# T-22 · Policies RLS et tests pgTAP

## Objectif

Toutes les policies de docs/database.md section 2 existent et chaque policy a son test pgTAP prouvant les refus.

## Contexte

- docs/database.md section 2
- .claude/rules/supabase.md
- .claude/rules/tests.md
- `.claude/rules/` applicables et `CLAUDE.md`.
- Tâche marquée `model: fable` : une erreur y est coûteuse ou silencieuse ; Fable 5.1 conseillé.

## Étapes

1. `supabase/tests/helpers.sql` : schéma `tests` avec `create_supabase_user(identifier, is_anonymous)`, `authenticate_as(identifier)` (pose `request.jwt.claims` avec `sub`, `role`, `is_anonymous`), `clear_authentication()`, `grant_premium(identifier, active)` (insère dans entitlements).
2. `supabase migration new 0003_rls_policies` : fonctions `has_active_premium`, `is_admin`, tables `entitlements`, `revenuecat_events`, `scan_counters` (nécessaires aux policies ; fonctions de quota en T-23), policies `ref_read`, `ref_admin_write`, `own_read`, `own_insert`, `own_update`, `entitlements.own_read`.
3. Un test par table utilisateur : propriétaire lit ; autre utilisateur ne lit rien ; anonyme Supabase ne lit rien ; propriétaire sans entitlement ne peut ni insérer ni modifier ; propriétaire avec entitlement expiré lit encore ; aucune suppression possible.
4. Un test pour les référentiels : lecture par anon, écriture refusée à authenticated, refusée à un admin tant que roles_enabled est faux.

## Tests

| Test (comportement vérifié) | Fichier | Commande |
|---|---|---|
| Une policy par table, refus à autre utilisateur, anonyme et sans entitlement | `supabase/tests/<table>_rls_test.sql (9 fichiers)` | `make test-db` |
| Référentiels : lecture publique, écriture refusée | `supabase/tests/reference_rls_test.sql` | `make test-db` |

## Sécurité

- [ ] Aucun secret ni valeur réelle dans le diff
- [ ] Aucune dépendance hors de la liste de docs/architecture.md section 10
- [ ] Aucune policy delete côté client
- [ ] Fonctions security definer avec search_path fixé

## Definition of Done

- [ ] Étapes réalisées
- [ ] Tests du tableau écrits et verts, aucun test superflu
- [ ] Checklist sécurité cochée (ou n/a)
- [ ] `make check` vert (plus `make test-db` et `make test-functions` si `supabase/` est touché)
- [ ] Revue `code-reviewer` : OK ou OK avec réserves consignées
- [ ] Statut `done` avec date dans ce fichier et dans `tasks/INDEX.md`
- [ ] Commit unique `feat(T-22): Policies RLS et tests pgTAP` sur `dev`, sans push (ou rien à committer pour une tâche purement manuelle)

## Notes de revue
