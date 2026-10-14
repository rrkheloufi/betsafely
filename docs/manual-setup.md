# Actions manuelles

Chaque action est rattachée à une tâche. Les vérifications automatisables sont celles que `/manual-done T-XX` exécute. Aucune valeur secrète n'est écrite dans ce document ni dans le dépôt : elles vont dans `env/dev.json`, `env/prod.json` (non versionnés) ou dans les secrets Supabase.

## T-01 · Outillage local

**Actions**
1. Installer FVM, puis `fvm install` à la racine (version de `.fvmrc`).
2. Installer le CLI Supabase, Docker Desktop (base locale pour pgTAP), Deno (Edge Functions), Xcode et CocoaPods (macOS), Android Studio avec un SDK API 36 ou plus et un émulateur.
3. `flutter doctor` sans erreur bloquante.

**Vérifications** : `fvm flutter --version` correspond à `.fvmrc` ; `supabase --version` ; `deno --version` ; `docker info`.

## T-10 · Projets Supabase

**Actions**
1. Créer deux projets dans l'organisation R-Square, région `eu-central-1` (Francfort) : `betsafely-dev` et `betsafely-prod`.
2. Dans chaque projet, Authentication : activer Anonymous sign-ins ; activer Manual linking ; activer Apple (Services ID, Team ID, Key ID, clé `.p8`) et Google (client iOS, client Android, client web) ; Email avec OTP par lien magique ; ajouter les URL de redirection `fr.rsquare.betsafely.dev://auth-callback` (dev) et `fr.rsquare.betsafely://auth-callback` (prod) ; activer la protection CAPTCHA invisible (Turnstile) sur les connexions anonymes ; durée de session par défaut.
3. Prod uniquement : SMTP personnalisé Brevo (expéditeur `noreply@` du domaine R-Square, domaine authentifié SPF et DKIM dans Brevo).
4. Copier `env/dev.example.json` en `env/dev.json` et renseigner `SUPABASE_URL` et `SUPABASE_PUBLISHABLE_KEY` du projet dev ; idem `env/prod.json`.
5. Lier le CLI au projet dev : `supabase link --project-ref <ref dev>`.

**Vérifications** : `env/dev.json` existe et contient les clés `SUPABASE_URL`, `SUPABASE_PUBLISHABLE_KEY` (sans lecture des valeurs) ; `supabase status` répond ; le nom du projet lié contient `dev`.

## T-11 · RevenueCat

**Actions**
1. Créer le projet RevenueCat « BetSafely ». Ajouter les apps App Store (bundle `fr.rsquare.betsafely`) et Play Store (package `fr.rsquare.betsafely`), puis un Test Store pour le développement.
2. Entitlement `premium`. Offering `default` avec les packages `$rc_monthly` et `$rc_annual`.
3. Produits : App Store `betsafely_premium_monthly` et `betsafely_premium_annual` ; Play `betsafely_premium` avec les plans `monthly` et `annual` et l'offre `annual-trial-7d` ; Test Store : un produit mensuel et un annuel équivalents. Rattacher chaque produit à `premium` et aux packages.
4. Paywall : créer le paywall « BetSafely » dans le dashboard d'après `docs/monetisation.md` (textes de PW-01, tokens de `docs/design-tokens.md`, mentions légales, Restaurer, liens Conditions et Confidentialité vers le site), dans les 6 langues (FR et EN d'abord), rattaché à l'offering `default`.
5. Clés : copier la clé Test Store dans `env/dev.json` (`RC_API_KEY_IOS` et `RC_API_KEY_ANDROID` reçoivent la même valeur en dev), les clés App Store et Play Store dans `env/prod.json`.
6. Webhook : Integrations > Webhooks, URL `https://<ref dev>.supabase.co/functions/v1/revenuecat-webhook`, Authorization header = un secret de 32 octets aléatoires en base64url (généré avec `openssl rand -base64 32`), même chose pour prod avec un autre secret. Poser le secret : `supabase secrets set REVENUECAT_WEBHOOK_SECRET=<valeur>` sur chaque projet. Poser aussi `REVENUECAT_SECRET_API_KEY` (clé secrète v2, portée lecture et suppression d'abonnés).
7. App Store Connect : Shared Secret de l'app copié dans RevenueCat. Play : compte de service avec accès à l'API Google Play Developer, JSON importé dans RevenueCat, notifications temps réel configurées.

**Vérifications** : `env/dev.json` contient `RC_API_KEY_IOS` et `RC_API_KEY_ANDROID` ; `supabase secrets list` liste `REVENUECAT_WEBHOOK_SECRET` et `REVENUECAT_SECRET_API_KEY`.

## T-12 · Comptes stores, identifiants, signature

**Actions**
1. App Store Connect : créer l'app « BetSafely », bundle `fr.rsquare.betsafely`, catégorie principale Finance, secondaire Sports, classification 18+ volontaire. Dans le portail développeur : identifiant d'app avec les capacités Sign in with Apple, App Groups (`group.fr.rsquare.betsafely`) et Push désactivé ; identifiant `fr.rsquare.betsafely.dev` avec les mêmes capacités ; Services ID pour Sign in with Apple côté Supabase ; clé `.p8` Sign in with Apple ; certificats et profils de distribution (gérés par Xcode automatic signing avec le compte d'équipe).
2. Google Play Console : créer l'app « BetSafely », package `fr.rsquare.betsafely`, catégorie Finance, public cible 18+. Générer le keystore de signature d'envoi : `keytool -genkey -v -keystore android/app/upload.jks -alias upload -keyalg RSA -keysize 2048 -validity 10000`, renseigner `android/key.properties` (jamais versionné). Activer Play App Signing. Créer les abonnements `betsafely_premium` (plans `monthly`, `annual`, offre `annual-trial-7d`, essai 7 jours) et accepter les accords de paiement.
3. App Store Connect : créer les abonnements `betsafely_premium_monthly` (3,99 €) et `betsafely_premium_annual` (24,99 €, offre d'introduction 7 jours gratuits) dans le groupe « BetSafely Premium », avec les prix par zone du brief (section 7.2). Accepter les accords Paid Apps.
4. Testeurs sandbox : un compte sandbox Apple, une liste de testeurs de licence Play.

**Vérifications** : `android/key.properties` existe ; `android/app/upload.jks` existe ; `ios/Runner.xcodeproj` contient les deux identifiants (`fr.rsquare.betsafely` et `.dev`).

## T-13 · Observabilité

**Actions**
1. Sentry : organisation R-Square, projet `betsafely` (plateforme Flutter), région UE, rétention 30 jours, scrubbing des données personnelles activé. DSN dans `env/dev.json` et `env/prod.json` (`SENTRY_DSN`), environnements `dev` et `prod`.
2. PostHog : projet EU, clé dans `env/*.json` (`POSTHOG_API_KEY`, `POSTHOG_HOST=https://eu.i.posthog.com`), autocapture désactivée, session replay désactivée, IP anonymisée.

**Vérifications** : `env/dev.json` contient `SENTRY_DSN`, `POSTHOG_API_KEY`, `POSTHOG_HOST`.

## T-28 · Déploiement dev du backend

**Actions**
1. `supabase secrets set ANTHROPIC_API_KEY=<clé>` sur le projet dev (clé Anthropic avec un plafond de dépense).
2. Vérifier dans Supabase Studio que `pg_cron` est activé pour le projet.

**Vérifications** : `supabase secrets list` liste `ANTHROPIC_API_KEY` ; le projet lié contient `dev`.

## T-112 · Achats sandbox sur appareils réels

**Actions**
1. Construire un build prod interne (`flutter build ipa --flavor prod` vers TestFlight interne ; `flutter build appbundle --flavor prod` vers la piste de test interne Play).
2. Sur iPhone avec compte sandbox : essai, conversion (sandbox accélère les renouvellements), renouvellement, expiration, restauration sur un second appareil, remboursement via le formulaire sandbox ; vérifier `entitlements` dans le projet dev après chaque événement webhook.
3. Même parcours sur Android avec un testeur de licence.
4. Scan : un ticket réel photographié, une capture d'écran importée, une image sans ticket, hors ligne.

**Vérifications** : aucune automatisable ; cocher la confirmation après le parcours complet.

## T-136 · Relecture native

**Actions**
1. Envoyer les ARB `es`, `pt`, `it`, `de` et les textes du paywall, des notifications, des conditions et de la politique de confidentialité à un relecteur natif par langue, avec le glossaire de paris du brief (section 12).
2. Intégrer les corrections dans les ARB.

**Vérifications** : aucune automatisable.

## T-141 · Préparation de la signature release

**Actions**
1. Vérifier que `android/key.properties` pointe vers le keystore et que Xcode signe `Runner` en release avec le profil de distribution.
2. `make build-prod` produit un `.aab` et un `.ipa`.

**Vérifications** : les fichiers `build/app/outputs/bundle/prodRelease/*.aab` et `build/ios/ipa/*.ipa` existent.

## T-142 · Recette sur appareils réels

**Actions** : parcours complet sur un iPhone et un Android physiques (onboarding, saisie, scan, notification N-01 avec actions en arrière-plan, règlement, budget, pause, récap et partage, paywall, synchro sur deux appareils, verrouillage, widget, hors ligne, texte à 200 %, VoiceOver et TalkBack). Consigner les anomalies en tâches `fix`.

**Vérifications** : aucune automatisable.

## T-143 · Fiches stores et soumission

**Actions**
1. Vérifier les ressources d'aide (`help_resources`) et les listes de bookmakers dans la semaine de la soumission ; confirmer FEJAR avant de l'ajouter.
2. App Store Connect : fiches dans les 7 langues (brief 5.3), captures ST-01 à ST-06, URL de confidentialité et de support (site GitHub Pages), déclarations App Privacy cohérentes avec `docs/architecture.md` section 13, note App Review Information du brief (11.4), classification 18+.
3. Play Console : fiches dans les 8 langues, Data safety, public cible 18+, formulaire de contenu, déclaration d'absence de jeu d'argent.
4. Envoyer les builds et soumettre.

**Vérifications** : aucune automatisable.
