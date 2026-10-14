# supabase/

- `config.toml` : base locale et fonctions. Les fournisseurs Apple et Google sont configurés dans le dashboard des projets dev et prod (`docs/manual-setup.md`, T-10).
- `migrations/` : une migration par tâche, dérivée de `docs/database.md`. Créée avec `supabase migration new <slug>` (T-20 à T-27).
- `functions/` : `_shared/`, `scan-ticket/`, `revenuecat-webhook/`, `delete-account/` (T-24 à T-26).
- `tests/` : tests pgTAP, lancés par `make test-db` sur la base locale Docker.
- `seed.sql` : référentiels (T-20).
