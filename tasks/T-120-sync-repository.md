---
id: T-120
title: Synchronisation Premium (envoi, récupération, conflits)
status: todo
phase: 12 Synchronisation
depends_on: [T-110, T-42, T-22]
manual: false
estimate: L
model: fable
done_at:
---

# T-120 · Synchronisation Premium (envoi, récupération, conflits)

## Objectif

Pour un compte Premium lié, les lignes locales `dirty` partent 3 s après écriture, les lignes distantes plus récentes arrivent à l'ouverture et au retour au premier plan, et la fusion « dernière écriture gagne » est testée.

## Contexte

- docs/architecture.md sections 3.4 et 6 (activation, fin d'abonnement)
- brief F-17
- cadrage décisions 11, 22, 23, 36
- `.claude/rules/` applicables et `CLAUDE.md`.
- Tâche marquée `model: fable` : une erreur y est coûteuse ou silencieuse ; Fable 5.1 conseillé.

## Étapes

1. `SyncRepositoryImpl` : `watchState`, `scheduleDebounced` (3 s), `syncNow` : envoi par lots de 200 (`upsert` sur les 9 tables, `dirty = false` à l'accusé), puis récupération `server_updated_at > cursor` par table, application si `remote.updated_at >= local.updated_at`, curseur mis à jour ; `finalPull` ; `needsMerge` (T-42) → envoi complet des lignes locales avant récupération.
2. Conditions : utilisateur non anonyme et entitlement actif ; sinon `SyncState.disabled`. Erreur 403 (RLS, entitlement expiré côté serveur) → `SyncState.error(unauthorized)` sans perte locale.
3. Déclencheurs : `record_bet`, `settle_bet`, préférences, budgets, pauses ; `WidgetsBindingObserver` pour le premier plan.
4. Fin d'abonnement : statut inactif → `finalPull` si en ligne → `disabled` ; date de purge = `expiresAt + 90 j` exposée pour AC-04.

## Tests

| Test (comportement vérifié) | Fichier | Commande |
|---|---|---|
| Fusion : ligne locale plus récente conservée, ligne distante plus récente appliquée, suppression logique propagée, curseur avancé (fakes de service) | `test/data/repositories/sync/sync_repository_test.dart` | `flutter test test/data/repositories/sync/sync_repository_test.dart` |

## Sécurité

- [ ] Aucun secret ni valeur réelle dans le diff
- [ ] Aucune dépendance hors de la liste de docs/architecture.md section 10
- [ ] Aucune donnée envoyée sans compte non anonyme et entitlement actif

## Definition of Done

- [ ] Étapes réalisées
- [ ] Tests du tableau écrits et verts, aucun test superflu
- [ ] Checklist sécurité cochée (ou n/a)
- [ ] `make check` vert (plus `make test-db` et `make test-functions` si `supabase/` est touché)
- [ ] Revue `code-reviewer` : OK ou OK avec réserves consignées
- [ ] Statut `done` avec date dans ce fichier et dans `tasks/INDEX.md`
- [ ] Commit unique `feat(T-120): Synchronisation Premium (envoi, récupération, conflits)` sur `dev`, sans push (ou rien à committer pour une tâche purement manuelle)

## Notes de revue
