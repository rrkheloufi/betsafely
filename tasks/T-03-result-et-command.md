---
id: T-03
title: Result<T> et Command
status: todo
phase: 0 Socle
depends_on: [T-01]
manual: false
estimate: S
model: opus
done_at:
---

# T-03 · Result<T> et Command

## Objectif

`lib/utils/result.dart` et `lib/utils/command.dart` existent, testés, et servent de base à toutes les couches.

## Contexte

- .claude/rules/architecture.md (patron Command)
- docs.flutter.dev/app-architecture/design-patterns/result et /command
- `.claude/rules/` applicables et `CLAUDE.md`.

## Étapes

1. `Result<T>` sealed : `Ok<T>(value)` et `Error<T>(AppError error)` ; `AppError` sealed avec les cas de .claude/rules/data.md (network, timeout, unauthorized, quotaExceeded, conflict, notFound, validation(message key), unknown(cause)).
2. `Command0<T>` et `Command1<T, A>` : `running`, `error`, `completed`, `result`, `execute()`, `clearResult()`, refus d'exécution concurrente, `ChangeNotifier`.
3. Extensions utilitaires : `Result.map`, `Result.when`.

## Tests

| Test (comportement vérifié) | Fichier | Commande |
|---|---|---|
| Ok et Error se construisent et se pattern-matchent | `test/utils/result_test.dart` | `flutter test test/utils/result_test.dart` |
| Command passe par running puis completed ou error, et ignore un second execute pendant l'exécution | `test/utils/command_test.dart` | `flutter test test/utils/command_test.dart` |

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
- [ ] Commit unique `feat(T-03): Result<T> et Command` sur `dev`, sans push (ou rien à committer pour une tâche purement manuelle)

## Notes de revue
