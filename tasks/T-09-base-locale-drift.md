---
id: T-09
title: Base locale drift
status: todo
phase: 0 Socle
depends_on: [T-04]
manual: false
estimate: L
model: opus
done_at:
---

# T-09 · Base locale drift

## Objectif

`LocalDatabase` (drift) contient les tables miroir de docs/database.md plus `settings` et `sync_state`, avec DAO, migrations versionnées et requêtes agrégées testées.

## Contexte

- docs/database.md section 1
- .claude/rules/data.md
- docs/architecture.md section 3.4
- `.claude/rules/` applicables et `CLAUDE.md`.

## Étapes

1. `lib/data/services/database/` : `local_database.dart` (`@DriftDatabase`), tables `bets`, `selections`, `retro_balances`, `budgets`, `pauses`, `alerts_log`, `user_preferences`, `user_bookmakers`, `user_sports`, référentiels (`countries`, `sports`, `country_sports`, `markets`, `bookmakers`, `country_bookmakers`, `help_resources`, `market_facts`, `equivalents`, `notification_durations`, `app_config`, `reference_version`), `settings` (clé-valeur), `sync_state` (curseur, dernière synchro). Colonnes utilisateur : `dirty` bool, `updated_at`, `deleted_at`.
2. Montants en `IntColumn`, dates en `DateTimeColumn` UTC, `odds_decimal` stocké en `IntColumn` ×10000 (4 décimales) ou `RealColumn` avec arrondi documenté (choisir l'entier ×10000).
3. DAO par domaine avec requêtes : paris d'un mois (par `placed_at` local), à régler (`status = open and event_at < now`), filtres et recherche, agrégats du mois (somme Sr, N, comptes), tous les paris non supprimés.
4. `drift_flutter` pour l'ouverture, nom de base par flavor, `schemaVersion = 1`, stratégie de migration avec `MigrationStrategy` et test de schéma.
5. `make gen`.

## Tests

| Test (comportement vérifié) | Fichier | Commande |
|---|---|---|
| Les requêtes de mois et « à régler » renvoient les bons paris sur le jeu de données de docs/design-tokens.md section 6, en mémoire (NativeDatabase.memory) | `test/data/services/database/bet_dao_test.dart` | `flutter test test/data/services/database/bet_dao_test.dart` |
| La suppression logique exclut la ligne des lectures | `test/data/services/database/soft_delete_test.dart` | `flutter test test/data/services/database/soft_delete_test.dart` |

## Sécurité

- [ ] Aucun secret ni valeur réelle dans le diff
- [ ] Aucune dépendance hors de la liste de docs/architecture.md section 10
- [ ] La base est incluse dans la sauvegarde système (pas d'exclusion), la session Supabase exclue (T-40)

## Definition of Done

- [ ] Étapes réalisées
- [ ] Tests du tableau écrits et verts, aucun test superflu
- [ ] Checklist sécurité cochée (ou n/a)
- [ ] `make check` vert (plus `make test-db` et `make test-functions` si `supabase/` est touché)
- [ ] Revue `code-reviewer` : OK ou OK avec réserves consignées
- [ ] Statut `done` avec date dans ce fichier et dans `tasks/INDEX.md`
- [ ] Commit unique `feat(T-09): Base locale drift` sur `dev`, sans push (ou rien à committer pour une tâche purement manuelle)

## Notes de revue
