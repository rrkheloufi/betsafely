---
id: T-20
title: Migration des référentiels et seed
status: todo
phase: 2 Backend
depends_on: [T-11]
manual: false
estimate: M
model: opus
done_at:
---

# T-20 · Migration des référentiels et seed

## Objectif

La première migration crée les types, les 10 tables de référence, `app_config`, `user_roles`, leurs triggers de version et `seed.sql` les remplit d'après le brief.

## Contexte

- docs/database.md section 1 (extensions, types, référentiels, triggers bump_reference_version et touch_updated_at)
- brief sections 5, 9, F-14, F-16, N-01
- `.claude/rules/` applicables et `CLAUDE.md`.

## Étapes

1. `supabase start` puis `supabase migration new 0001_reference` ; écrire le SQL de docs/database.md pour cette partie, RLS activée sur chaque table (policies en T-22).
2. `supabase/seed.sql` : countries (7), sports (17, labels fr et en, icon), country_sports (ordre 9.3), markets (9.4, génériques avec sport_id null), bookmakers et country_bookmakers (9.5, catégorie prediction pour Kalshi, Polymarket, PrizePicks, Underdog), help_resources (F-16, sans FEJAR), market_facts (F-14, FR, US, générique), equivalents (par locale, prix indicatifs cohérents avec les maquettes), notification_durations (N-01), app_config, reference_version.
3. `supabase db reset` (local uniquement) pour valider migration et seed.
4. Script `scripts/export-reference-snapshot.sh` qui exporte le référentiel de la base locale en `assets/reference/snapshot.json` (utilisé en T-30).

## Tests

| Test (comportement vérifié) | Fichier | Commande |
|---|---|---|
| La migration s'applique et le seed charge 7 pays, 17 sports, les bookmakers FR et US attendus | `supabase/tests/reference_seed_test.sql` | `make test-db` |

## Sécurité

- [ ] Aucun secret ni valeur réelle dans le diff
- [ ] Aucune dépendance hors de la liste de docs/architecture.md section 10
- [ ] RLS activée sur chaque table créée
- [ ] Aucun bucket Storage

## Definition of Done

- [ ] Étapes réalisées
- [ ] Tests du tableau écrits et verts, aucun test superflu
- [ ] Checklist sécurité cochée (ou n/a)
- [ ] `make check` vert (plus `make test-db` et `make test-functions` si `supabase/` est touché)
- [ ] Revue `code-reviewer` : OK ou OK avec réserves consignées
- [ ] Statut `done` avec date dans ce fichier et dans `tasks/INDEX.md`
- [ ] Commit unique `feat(T-20): Migration des référentiels et seed` sur `dev`, sans push (ou rien à committer pour une tâche purement manuelle)

## Notes de revue
