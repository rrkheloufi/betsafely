# env/

Fichiers de configuration par flavor, passés avec `--dart-define-from-file=env/<flavor>.json`.

- `dev.example.json` et `prod.example.json` sont versionnés, sans valeur réelle.
- `dev.json` et `prod.json` sont écrits par les scripts de `scripts/ops/` (T-11, T-13, T-14) à partir des exemples et ne sont jamais versionnés ni lus par Claude.
- Seules des clés publiques y figurent (URL Supabase, clé publishable, clés publiques RevenueCat, DSN Sentry, clé PostHog). Les secrets serveur vont dans `supabase secrets`.
