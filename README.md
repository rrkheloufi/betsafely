# BetSafely

Application mobile iOS et Android (Flutter) qui aide les parieurs sportifs à faire attention à ce qu'ils misent : suivi des paris, budget, alertes, pause, aide jeu responsable. Freemium avec abonnement Premium. Éditeur : R-Square.

## Démarrage

1. Installer FVM puis `fvm install` (Flutter `3.47.0`, voir `.fvmrc`), le CLI Supabase, Docker, Deno.
2. `make setup`.
3. Copier `env/dev.example.json` en `env/dev.json` et renseigner les valeurs (`docs/manual-setup.md`).
4. `make run-dev`.

Le projet Flutter lui-même est créé par la tâche T-00 (`/task T-00` dans Claude Code).

## Commandes

| Commande | Rôle |
|---|---|
| `make setup` | Dépendances et scripts exécutables |
| `make gen` | Génération de code (freezed, json_serializable, drift, l10n) |
| `make format`, `make analyze`, `make test` | Formatage, analyse stricte, tests |
| `make test-db`, `make test-functions`, `make test-integration` | pgTAP (base locale), Edge Functions, parcours critique |
| `make check` | Format en vérification, analyse, scripts de contrôle, tests. À lancer avant tout commit |
| `make run-dev`, `make build-dev`, `make build-prod` | Exécution et builds par flavor |

## Structure

```
lib/            application (config, routing, data, domain, ui, l10n, utils)
test/           tests, miroir de lib/ ; test/testing/fakes/
integration_test/  parcours critique
supabase/       config, migrations, functions, tests, seed
site/           site légal et support (GitHub Pages)
docs/           architecture, base de données, monétisation, design tokens, workflow, actions manuelles
tasks/          index et spécifications des tâches
scripts/        scripts de contrôle lancés par make check
.claude/        CLAUDE.md, settings, rules, skills, agents, hooks
env/            exemples de configuration par flavor
```

## Flavors

`dev` (`fr.rsquare.betsafely.dev`, projet Supabase dev, Test Store RevenueCat) et `prod` (`fr.rsquare.betsafely`). Configuration par `--dart-define-from-file=env/<flavor>.json`, points d'entrée `lib/main_dev.dart` et `lib/main_prod.dart`.

## Branches

`dev` : développement, un commit par tâche. `main` : production, avancée en fast-forward depuis `dev` par `/deploy prod`, taguée `vX.Y.Z`.

## Documentation

- [Architecture](docs/architecture.md), [Base de données](docs/database.md), [Monétisation](docs/monetisation.md), [Design tokens](docs/design-tokens.md)
- [Workflow Claude Code](docs/workflow.md), [Actions manuelles](docs/manual-setup.md)
- [Tâches](tasks/INDEX.md)
