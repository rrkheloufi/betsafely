# scripts/ops/

Scripts d'exploitation écrits par les tâches de la phase 1 et de la mise en production, exécutés par Claude via `/ops` ou directement. Règles communes (`lib/common.sh`) :

- Chargement des jetons par `set -a; source secrets/<service>.env` ; `require_var` échoue avec le nom de la variable manquante.
- Appels HTTP par `api()` : curl silencieux, en-tête Bearer, sortie jq, échec explicite sur code non 2xx ; un corps de réponse contenant un jeton n'est jamais affiché.
- Idempotence : chercher avant de créer, mettre à jour sinon ; aucune suppression (`DELETE`) dans les scripts de provisionnement.
- `OPS_DRY_RUN=1` : aucun appel réseau, journal des appels prévus (utilisé par les tests `scripts/ops/tests/`).
- Les scripts d'envoi (`store-upload.sh`) refusent toute piste autre que celles passées en argument et exigent un build du flavor `prod` ; `store-submit.sh` exige la phrase `oui, soumets X.Y.Z`.
- Toute étape refusée par une API est consignée dans `docs/manual-setup.md`, section Résidu manuel, avec la date et le message.

| Script | Tâche | Rôle |
|---|---|---|
| `bootstrap-macos.sh [--check]` | T-01 | Outillage local par Homebrew et sdkmanager |
| `check-secrets.sh <groupe>` | T-10, T-12 | Présence des fichiers et clés de `secrets/` |
| `supabase-provision.sh <dev\|prod> [--secrets-only]` | T-11 | Projets, Auth, clés, secrets, pg_cron, link |
| `supabase-query.sh <dev\|prod> "<sql>"` | T-28, T-112 | Requête SQL par l'API de gestion (lecture) |
| `observability-provision.sh`, `brevo-provision.sh [--verify]` | T-13 | Sentry, PostHog, Brevo |
| `revenuecat-provision.sh`, `revenuecat-test-event.sh`, `revenuecat-customer.sh` | T-14, T-28, T-112 | Projet, apps, produits, offering, paywall, webhooks ; test ; lecture d'un client |
| `apple-signin-secret.sh` | T-12 | Secret client Sign in with Apple (JWT 6 mois) |
| `apple-provision.sh [--renew-signing]` | T-15 | Bundle IDs, capacités, certificat, profils, abonnements, prix |
| `android-signing.sh [--sha1]`, `play-provision.sh` | T-16 | Keystore, key.properties ; abonnement Play |
| `store-upload.sh <ios testflight\|ios appstore\|android internal\|android production [--rollout r]>` | T-112, T-143 | Build prod puis envoi (fastlane pilot et supply) |
| `store-metadata.sh` | T-143 | Fiches, captures, classification, data safety |
| `store-submit.sh X.Y.Z` | T-143 | Soumission après la phrase de confirmation |
| `lib/asc-token.ts`, `lib/google-token.ts` | T-15, T-16 | JWT App Store Connect (ES256) et Google (RS256) en Deno |
