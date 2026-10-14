---
id: T-61
title: BetRepository sur drift
status: todo
phase: 6 Paris
depends_on: [T-60, T-09]
manual: false
estimate: M
model: opus
done_at:
---

# T-61 · BetRepository sur drift

## Objectif

`BetRepository` lit et écrit les paris et sélections localement, avec `watchMonth`, `watchToSettle`, `watchFiltered`, `save`, `saveAll`, `settle`, `delete`, `firstMonth`.

## Contexte

- docs/architecture.md section 3.2
- .claude/rules/data.md
- `.claude/rules/` applicables et `CLAUDE.md`.

## Étapes

1. `BetRepositoryImpl` : mapping drift ↔ domaine (`bet_mapper.dart`), transactions pour pari + sélections, `dirty = true`, `updated_at = now` UTC, `settle` applique C-02 via BetMath et pose `settled_at`.
2. `watchToSettle(now)` : `status = open and event_at <= now` (pari sans date exclu).
3. `watchFiltered(BetFilter)` : statut, bookmaker, sport, texte (événement, note, bookmaker), ordre `placed_at desc`.

## Tests

| Test (comportement vérifié) | Fichier | Commande |
|---|---|---|
| save puis settle renvoient un pari réglé avec le retour C-02 ; delete le retire des flux | `test/data/repositories/bet/bet_repository_test.dart` | `flutter test test/data/repositories/bet/bet_repository_test.dart` |

## Sécurité

- [ ] Aucun secret ni valeur réelle dans le diff
- [ ] Aucune dépendance hors de la liste de docs/architecture.md section 10

## Definition of Done

- [ ] Étapes réalisées
- [ ] Tests du tableau écrits et verts, aucun test superflu
- [ ] Checklist sécurité cochée (ou n/a)
- [ ] `make check` vert (plus `make test-db` et `make test-functions` si `supabase/` est touché)
- [ ] Revue `code-reviewer` : OK ou OK avec réserves consignées
- [ ] Statut `done` avec date dans ce fichier et dans `tasks/INDEX.md`
- [ ] Commit unique `feat(T-61): BetRepository sur drift` sur `dev`, sans push (ou rien à committer pour une tâche purement manuelle)

## Notes de revue
