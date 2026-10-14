---
id: T-04
title: Injection des dépendances et bootstrap
status: todo
phase: 0 Socle
depends_on: [T-02, T-03]
manual: false
estimate: M
model: opus
done_at:
---

# T-04 · Injection des dépendances et bootstrap

## Objectif

`lib/config/dependencies.dart` fournit tous les repositories (implémentations ou stubs) via provider, et `lib/config/bootstrap.dart` initialise l'app sans SDK encore branché.

## Contexte

- docs/architecture.md sections 2, 3 et 9
- .claude/rules/architecture.md
- `.claude/rules/` applicables et `CLAUDE.md`.

## Étapes

1. `bootstrap.dart` : `WidgetsFlutterBinding.ensureInitialized`, `Env`, orientation portrait, `runApp(App(dependencies))`. Les SDK seront ajoutés par leurs tâches.
2. `dependencies.dart` : fonction `List<SingleChildWidget> providers(Env env)` avec `Provider<XRepository>` pour chaque interface de docs/architecture.md section 3.2, pointant pour l'instant sur des implémentations `Unimplemented` qui renvoient `Result.error(AppError.unknown)` (remplacées tâche par tâche).
3. Créer les interfaces abstraites de docs/architecture.md section 3.2 dans `lib/data/repositories/<feature>/` avec les types de domaine minimaux en freezed dans `lib/domain/models/` (`Money`, `YearMonth`, `Bet`, `Selection`, `Budget`, `Pause`, `RetroBalance`, `AlertEvent`, `UserPreferences`, `PremiumStatus`, `AppUser`, `SyncState`, ...). Champs d'après docs/database.md.
4. `App` : `MultiProvider` puis `MaterialApp.router` (routeur ajouté en T-05).

## Tests

| Test (comportement vérifié) | Fichier | Commande |
|---|---|---|
| YearMonth : navigation précédent/suivant, bornes, parsing AAAA-MM | `test/domain/models/year_month_test.dart` | `flutter test test/domain/models/year_month_test.dart` |

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
- [ ] Commit unique `feat(T-04): Injection des dépendances et bootstrap` sur `dev`, sans push (ou rien à committer pour une tâche purement manuelle)

## Notes de revue
