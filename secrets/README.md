# secrets/

Jetons et clés fournis par Rayan, lus uniquement par les scripts de `scripts/ops/` (`set -a; source secrets/<service>.env`). Tout ce dossier est ignoré par git sauf ce fichier ; `.claude/settings.json` interdit sa lecture à Claude et le hook bloque `cat secrets/...`. Les scripts n'affichent jamais une valeur.

Un fichier par service, format `CLE=valeur` sans guillemets ni espace :

```
supabase.env        SUPABASE_ACCESS_TOKEN, SUPABASE_ORG_SLUG
supabase-dev.env    écrit par supabase-provision.sh : SUPABASE_PROJECT_REF, SUPABASE_DB_PASSWORD
supabase-prod.env   idem pour prod
revenuecat.env      REVENUECAT_API_KEY_V2, REVENUECAT_SUBSCRIBERS_API_KEY (optionnelle)
revenuecat-webhook-dev.env, -prod.env   écrits par revenuecat-provision.sh
sentry.env          SENTRY_AUTH_TOKEN, SENTRY_ORG, SENTRY_TEAM
posthog.env         POSTHOG_PERSONAL_API_KEY, POSTHOG_ORG_ID
brevo.env           BREVO_API_KEY, BREVO_SENDER_EMAIL, BREVO_DOMAIN
brevo-smtp.env      SMTP_HOST, SMTP_PORT, SMTP_USER, SMTP_PASS (après authentification du domaine)
anthropic.env       ANTHROPIC_API_KEY
turnstile.env       TURNSTILE_SITE_KEY, TURNSTILE_SECRET_KEY
apple.env           ASC_KEY_ID, ASC_ISSUER_ID, ASC_KEY_PATH=secrets/apple/AuthKey_XXXX.p8, APPLE_TEAM_ID
                    (+ APPLE_OAUTH_CLIENT_ID, APPLE_OAUTH_SECRET écrits par apple-signin-secret.sh)
apple-signin.env    SIGNIN_KEY_ID, SIGNIN_KEY_PATH=secrets/apple/AuthKey_YYYY.p8, SIGNIN_SERVICES_ID
apple-store.env     APP_SHARED_SECRET
apple-signing.env   écrit par apple-provision.sh : chemins des profils de distribution
google-play.json    clé JSON du compte de service Google Cloud
google-oauth.env    GOOGLE_WEB_CLIENT_ID, GOOGLE_WEB_CLIENT_SECRET, GOOGLE_IOS_CLIENT_ID, GOOGLE_ANDROID_CLIENT_ID
android-keystore.env  écrit par android-signing.sh : STORE_PASSWORD, KEY_PASSWORD
```

`scripts/ops/check-secrets.sh <services|stores|supabase|env|all>` vérifie la présence des fichiers et des clés attendues sans rien afficher d'autre que les noms manquants.
