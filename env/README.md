# env/

Fichiers de configuration par flavor, passés avec `--dart-define-from-file=env/<flavor>.json`.

- `dev.example.json` et `prod.example.json` sont versionnés, sans valeur réelle.
- `dev.json` et `prod.json` sont créés à partir des exemples (voir `docs/manual-setup.md`, T-10 à T-13) et ne sont jamais versionnés ni lus par Claude.
- Seules des clés publiques y figurent (URL Supabase, clé publishable, clés publiques RevenueCat, DSN Sentry, clé PostHog). Les secrets serveur vont dans `supabase secrets`.
