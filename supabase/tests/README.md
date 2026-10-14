# Tests pgTAP

Un fichier par table utilisateur (`<table>_rls_test.sql`) et par fonction (`<fonction>_test.sql`). Chaque test prouve le refus à un autre utilisateur et à l'anonyme Supabase, et le refus d'écriture sans entitlement. Les helpers d'authentification sont dans `helpers.sql` (T-22). Lancement : `make test-db`.
