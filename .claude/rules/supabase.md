---
paths:
  - supabase/**
---

# Règles Supabase

## Migrations

- Une migration par tâche, créée avec `supabase migration new <slug>` (horodatée, jamais renommée après commit). Jamais de modification d'une migration déjà poussée : une nouvelle migration corrige.
- `docs/database.md` est la source de vérité ; une migration qui s'en écarte met d'abord le document à jour.
- Toute table a `created_at`, `updated_at`, et pour les tables utilisateur `user_id`, `deleted_at`, `server_updated_at` et le trigger `sync_before_write`.
- Les référentiels ont des identifiants texte stables ; les tables utilisateur des `uuid` fournis par le client ; les tables serveur `gen_random_uuid()`.
- Les montants sont des entiers d'unités mineures, jamais `numeric` sauf `odds_decimal numeric(8,4)`.

## RLS

- `alter table ... enable row level security` dans la même migration que la table. Aucune table sans RLS, y compris les tables serveur (sans policy = service_role seul).
- Policies nommées `own_read`, `own_insert`, `own_update`, `ref_read`, `ref_admin_write`. Jamais de policy `delete` côté client.
- Condition propriétaire : `user_id = auth.uid() and is_registered()` ; écriture : `and has_active_premium(auth.uid())`.
- Chaque policy a un test pgTAP dans `supabase/tests/` qui prouve le refus à un autre utilisateur et à l'anonyme Supabase, et le refus d'écriture sans entitlement. Les tests utilisent `tests.create_supabase_user` et `tests.authenticate_as` (helpers de `supabase/tests/helpers.sql`).
- Les fonctions `security definer` fixent `set search_path = public` et révoquent `execute` à `anon` et `authenticated` quand elles sont réservées au serveur.

## Storage

- Aucun bucket en V1. Toute proposition de stockage de fichier (image de ticket, export) est refusée : P-08 et F-04.

## Edge Functions (Deno)

- Une fonction par dossier `supabase/functions/<name>/index.ts`, code partagé dans `supabase/functions/_shared/`.
- Chaque fonction vérifie l'authentification en premier : session utilisateur via le JWT (`scan-ticket`, `delete-account`) ou secret partagé en comparaison à temps constant (`revenuecat-webhook`). Réponse 401 sinon.
- Validation stricte des entrées (taille d'image, type MIME, schéma JSON) avant tout traitement. Sortie JSON typée.
- Le webhook est idempotent : `revenuecat_events.event_id` est inséré avant tout effet ; conflit = 200 sans effet.
- Clés et secrets via `Deno.env.get` alimentés par `supabase secrets set`, jamais en dur, jamais dans `config.toml`.
- Aucune image, aucun contenu de pari, aucune adresse e-mail dans `console.log`.
- Tests dans `supabase/functions/<name>/index_test.ts` avec `deno test` : chemin nominal et rejet principal.

## Commandes

- Tests : `make test-db` (base locale Docker) et `make test-functions`.
- Déploiement : uniquement via `/deploy dev` ou `/deploy prod`. `supabase db reset --linked` est interdit.
