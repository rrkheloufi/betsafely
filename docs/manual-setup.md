# Actions manuelles et jetons

Principe : Rayan fournit une fois les jetons d'accès (fichiers dans `secrets/`, jamais versionnés, jamais lus par Claude) et crée les seules ressources qu'aucune API ne sait créer. Tout le reste est fait par les scripts de `scripts/ops/` que Claude écrit et exécute (voir `.claude/skills/ops/SKILL.md`). Les scripts sont idempotents : relançables sans doublon ni perte.

Les vérifications listées sont celles que `/manual-done T-XX` exécute. Aucune valeur secrète n'est écrite dans ce document, dans le dépôt ni dans la conversation.

## T-01 · Xcode

**Action** : installer Xcode depuis le Mac App Store, l'ouvrir une fois, accepter la licence, installer la plateforme iOS proposée. Tout le reste (FVM, Flutter, CLI Supabase, Docker, Deno, CocoaPods, fastlane, jq, Android Studio et SDK) est installé par `scripts/ops/bootstrap-macos.sh`.

**Vérifications** : `xcodebuild -version` ; `scripts/ops/bootstrap-macos.sh --check`.

## T-10 · Jetons des services

Déposer un fichier par service dans `secrets/` (modèles dans `secrets/README.md`). Où créer chaque jeton :

| Fichier | Clés | Où le créer | Portée |
|---|---|---|---|
| `secrets/supabase.env` | `SUPABASE_ACCESS_TOKEN`, `SUPABASE_ORG_SLUG` | supabase.com/dashboard/account/tokens | jeton d'accès personnel (création de projets, config auth, clés, secrets, fonctions, base) |
| `secrets/revenuecat.env` | `REVENUECAT_API_KEY_V2` et, si possible, `REVENUECAT_SUBSCRIBERS_API_KEY` | Project settings > API keys > New, version V2 | la première : `project_configuration` projects, apps, offerings, integrations en lecture et écriture ; la seconde : abonnés en lecture et suppression (posée sur Supabase pour `delete-account`) |
| `secrets/sentry.env` | `SENTRY_AUTH_TOKEN`, `SENTRY_ORG`, `SENTRY_TEAM` | Settings > Developer Settings > Custom Integrations (interne), ou jeton utilisateur | `project:write`, `project:read` |
| `secrets/posthog.env` | `POSTHOG_PERSONAL_API_KEY`, `POSTHOG_ORG_ID` | Settings > Personal API keys (projet UE) | `project:read`, `project:write` |
| `secrets/brevo.env` | `BREVO_API_KEY`, `BREVO_SENDER_EMAIL`, `BREVO_DOMAIN` | SMTP & API > API keys | clé v3 |
| `secrets/anthropic.env` | `ANTHROPIC_API_KEY` | console.anthropic.com, clé avec plafond de dépense | fonction `scan-ticket` |
| `secrets/turnstile.env` | `TURNSTILE_SITE_KEY`, `TURNSTILE_SECRET_KEY` | Cloudflare > Turnstile > Add widget (invisible) | CAPTCHA des connexions anonymes |

**Vérifications** : `scripts/ops/check-secrets.sh services` (présence des fichiers et des clés, aucune valeur affichée) ; `git check-ignore secrets/supabase.env`.

## T-12 · Fiches app et clés des stores

Aucune API ne crée la fiche d'une app, un Services ID, une clé Sign in with Apple, n'accepte un accord ni ne crée un testeur sandbox. C'est la seule session de console des stores.

**App Store Connect et portail développeur**
1. Users and Access > Integrations > App Store Connect API : clé **d'équipe** (pas individuelle), rôle Admin. Télécharger le `.p8` dans `secrets/apple/`, noter Key ID et Issuer ID dans `secrets/apple.env` (`ASC_KEY_ID`, `ASC_ISSUER_ID`, `ASC_KEY_PATH`, `APPLE_TEAM_ID`).
2. Apps > + : « BetSafely », bundle `fr.rsquare.betsafely` (l'identifiant est créé par T-15 si T-15 tourne avant ; sinon le créer ici avec la capacité Sign in with Apple), SKU `betsafely`, langue principale français. Catégories, classification et abonnements sont posés par script.
3. Certificates, Identifiers & Profiles > Identifiers > Services IDs : `fr.rsquare.betsafely.signin`, Sign in with Apple activé, domaine et URL de retour de Supabase (`https://<ref>.supabase.co/auth/v1/callback`, pour dev et prod). Keys > + : clé Sign in with Apple, `.p8` dans `secrets/apple/`, `secrets/apple-signin.env` (`SIGNIN_KEY_ID`, `SIGNIN_KEY_PATH`, `SIGNIN_SERVICES_ID`).
4. Business > Agreements : accord Paid Apps signé, coordonnées bancaires et fiscales.
5. Users and Access > Sandbox : un testeur sandbox.
6. Apps > BetSafely > App Information : Shared Secret de l'app, dans `secrets/apple-store.env` (`APP_SHARED_SECRET`).

**Google Play Console et Google Cloud**
1. Play Console > Create app : « BetSafely », application, gratuite, package `fr.rsquare.betsafely` (fixé par le premier envoi). Accepter les déclarations.
2. Google Cloud : projet `betsafely`, API « Google Play Android Developer » activée, compte de service `betsafely-ops`, clé JSON dans `secrets/google-play.json`.
3. Play Console > Users and permissions > Invite : l'email du compte de service, droits sur l'app : releases (toutes pistes), store listing, « Manage orders and subscriptions », « View financial data ».
4. Settings > License testing : un compte Google de test.
5. Google Cloud > APIs > Credentials : clients OAuth iOS (`fr.rsquare.betsafely` et `.dev`), Android (empreinte SHA-1 du keystore, affichée par `scripts/ops/android-signing.sh --sha1` après T-16) et Web ; `secrets/google-oauth.env` (`GOOGLE_WEB_CLIENT_ID`, `GOOGLE_WEB_CLIENT_SECRET`, `GOOGLE_IOS_CLIENT_ID`, `GOOGLE_ANDROID_CLIENT_ID`).

**Vérifications** : `scripts/ops/check-secrets.sh stores`.

## T-13 · Brevo : DNS et clé SMTP

Après `scripts/ops/brevo-provision.sh` : poser chez le registrar du domaine R-Square les enregistrements affichés (code Brevo, DKIM, DMARC), cliquer le lien de vérification reçu sur `noreply@`, puis SMTP & API > SMTP > Generate a new SMTP key dans `secrets/brevo-smtp.env` (`SMTP_HOST=smtp-relay.brevo.com`, `SMTP_PORT=587`, `SMTP_USER`, `SMTP_PASS`). Relancer `scripts/ops/brevo-provision.sh --verify` puis `scripts/ops/supabase-provision.sh prod`.

## T-112 · Vérifications sur appareils réels

Les builds internes sont envoyés par `scripts/ops/store-upload.sh ios testflight` et `android internal`. Si Play refuse le tout premier envoi par API, déposer une fois le `.aab` indiqué dans Play Console > Testing > Internal testing (c'est aussi là que Play App Signing est accepté), puis relancer le script.

Sur iPhone (compte sandbox) et Android (testeur de licence) : essai, conversion, renouvellement, expiration, restauration sur un second appareil, remboursement ; scan d'un ticket réel, d'une capture, d'une image sans ticket, hors ligne. Claude relit `entitlements` et les abonnés RevenueCat par script après chaque étape.

## T-136 · Relecture native

Claude produit `docs/review/<lang>.md` (ES, PT-BR, IT, DE) avec les textes sensibles et ses propres doutes. Les faire relire par un natif, écrire les corrections dans ces fichiers et ajouter la ligne `Relu le : AAAA-MM-JJ`. Claude intègre ensuite.

## T-142 · Recette sur appareils réels

Parcours complet sur un iPhone et un Android physiques (onboarding, saisie, scan, notification N-01 avec actions en arrière-plan, règlement, budget, pause, récap et partage, paywall, synchro sur deux appareils, verrouillage, widget, hors ligne, texte à 200 %, VoiceOver et TalkBack). Dicter les anomalies à Claude, qui crée les tâches `fix`.

## T-143 · Formulaires des consoles

Avant `scripts/ops/store-submit.sh` : App Store Connect > App Privacy (réponses dans `docs/architecture.md` section 13, non couvert par l'API) ; Play Console > Policy > App content : questionnaire de contenu, public cible 18+, « pas de jeu d'argent réel », Data safety (réponses de la section 13 ; exporter ensuite le CSV dans `ops/store-metadata/play/data-safety.csv` pour que le script le repousse aux versions suivantes). Fiches, captures, classification, envoi des builds et soumission sont faits par script ; la soumission attend la phrase `oui, soumets X.Y.Z`.

## Résidu manuel (tenu à jour par les scripts)

Les scripts ajoutent ici toute étape qu'une API a refusée, avec la date et le message. Vide au départ.

## Rappels à échéance

- Secret client Apple pour Supabase (JWT de 6 mois) : régénérer par `scripts/ops/apple-signin-secret.sh` avant la date notée ici par T-12.
- Certificat de distribution Apple (1 an) : `scripts/ops/apple-provision.sh --renew-signing`.
