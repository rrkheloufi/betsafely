---
name: db
description: Gère les migrations Supabase et les tests pgTAP sur le projet dev uniquement, et met à jour les modèles Dart concernés. Usage /db new <slug>, /db test, /db diff, /db push.
argument-hint: "new <slug> | push | test | diff"
disable-model-invocation: true
effort: medium
---

# /db $ARGUMENTS

Sous-commandes :

- **`new <slug>`** : `supabase migration new <slug>`, puis rédige la migration d'après `docs/database.md` (section concernée). Toute nouvelle table reçoit `enable row level security` et ses policies dans la même migration, et un test pgTAP `supabase/tests/<table>_rls_test.sql`. Si des colonnes exposées à l'app changent, mets à jour les DTO dans `lib/data/models/`, les tables drift miroir dans `lib/data/services/database/` et le mapper, puis `make gen`.
- **`test`** : `supabase start` si nécessaire, puis `supabase test db --local` (équivalent `make test-db`). Rapporte les échecs par fichier.
- **`diff`** : `supabase db diff --local` pour comparer la base locale aux migrations ; signale toute dérive, ne corrige pas sans demander.
- **`push`** : vérifie que le projet lié est le projet **dev** (`supabase status` ou `supabase projects list` : le nom contient `dev`), lance `make test-db`, puis `supabase db push` (demande de confirmation par les permissions). Si le projet lié est prod : arrêt, `/deploy prod` est la seule voie.

## Interdits

`supabase db reset --linked`, `supabase db push` vers prod, modification d'une migration déjà commitée, suppression d'une policy sans mise à jour de `docs/database.md` et de son test, lecture de `env/*.json` hors exemples.
