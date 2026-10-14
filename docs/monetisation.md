# Monétisation BetSafely (RevenueCat)

Source de vérité de la monétisation. Règles de code dans `.claude/rules/monetisation.md`.

## 1. Configuration

- **Entitlement :** `premium`. **Offering :** `default` avec `$rc_monthly` et `$rc_annual`.
- **Produits [25] :** iOS, groupe « BetSafely Premium » : `betsafely_premium_monthly`, `betsafely_premium_annual` (offre d'introduction de 7 jours gratuits). Android : abonnement `betsafely_premium`, plans de base `monthly` et `annual`, offre `annual-trial-7d`.
- **Paywall :** un seul paywall RevenueCat, conçu dans le dashboard d'après PW-01 (tokens, textes, mentions, Restaurer), traduit dans les 6 langues ; présenté avec `presentPaywall` aux placements `onboarding`, `history`, `scan_quota`, `analytics`, `alerts`, `budgets`, `chase`, `export`, `sync`, `widget`, `profile` (le placement ne sert qu'à l'analytics `paywall_viewed`).
- **Liaison :** `Purchases.configure(appUserID: <uid Supabase>)`, `logIn(uid)` si l'uid change, `logOut` jamais (pour que l'abonné anonyme garde ses droits) ; à la déconnexion d'un compte, nouvelle session anonyme puis `logIn` du nouvel uid.
- **Source de vérité :** le SDK (`customerInfo`) pour l'interface, la table `entitlements` pour le serveur (quota du scan, écriture de la synchro).
- **Webhook :** en-tête `Authorization: Bearer <secret>`, comparaison à temps constant ; `event.id` déjà vu → 200 sans effet ; `app_user_id` ou alias qui n'est pas un uuid → ignoré ; types gérés : `INITIAL_PURCHASE`, `RENEWAL`, `PRODUCT_CHANGE`, `UNCANCELLATION`, `CANCELLATION`, `EXPIRATION`, `BILLING_ISSUE`, `TRANSFER`, `REFUND` (via `CANCELLATION` avec raison).
- **Restauration :** dans le paywall et dans Profil > Abonnement. Changement d'appareil sans compte : Restaurer donne Premium, sans synchro.
- **Fin d'essai (N-04) :** programmée localement depuis `expirationDate` quand `periodType = trial`, annulée si l'utilisateur résilie ou si l'essai se convertit.
- **Dev :** le flavor dev a un identifiant `.dev` sans produits dans les stores ; il utilise la clé du Test Store RevenueCat. Les achats sandbox réels se testent sur un build prod interne (TestFlight, test interne Play). À vérifier en 4a.


## 2. Flux

**Achat**
1. `RevenueCatUI.presentPaywall` → achat dans le store → `customerInfo` mis à jour → `PremiumStatus.active`.
2. RevenueCat → `revenuecat-webhook` → `revenuecat_events`, `entitlements` (actif, `purge_after = null`).
3. Proposition AC-01 si le compte est encore anonyme.

**Activation de la synchro après achat**
1. Apple ou Google natif : jeton d'identité → liaison à l'utilisateur anonyme (même uid) ; e-mail : `updateUser(email)`, lien → `auth-callback`. Identité déjà liée à un autre compte → connexion à ce compte, `Purchases.logIn(uid)`, fusion [11].
2. Envoi de toutes les lignes locales, puis récupération ; local `sync_state.cursor`.

**Fin d'abonnement**
1. Webhook `EXPIRATION` → `entitlements.is_active = false`, `purge_after = expires_at + 90 j`.
2. App : statut inactif → `finalPull` si en ligne → synchro désactivée → bannière avec la date de purge.
3. `pg_cron` purge les lignes en ligne après la date.

**Problème de facturation**
RevenueCat signale `billingIssueDetectedAt` → bannière sur le profil et à l'ouverture : « Ton paiement n'a pas abouti. Mets à jour ton moyen de paiement dans le store. » avec lien de gestion. Aucune période de grâce dans les stores.

**Suppression de compte**
1. AC-04 → confirmation (mention de l'abonnement actif [15]) → `delete-account`.
2. Serveur : suppression des 9 tables, `scan_counters`, `entitlements`, client RevenueCat, utilisateur Auth.
3. App : déconnexion, choix garder ou effacer le local, nouvelle session anonyme au prochain lancement en ligne.

## 3. Cas limites

| Cas | Comportement |
|---|---|
| Restauration sur un nouvel appareil sans compte | `restorePurchases` rend Premium ; la synchro reste désactivée tant qu'aucun compte n'est lié |
| Essai déjà consommé sur ce compte store | `introEligibility` non éligible : bouton « S'abonner », aucun badge d'essai |
| Expiration pendant le hors ligne | Le SDK garde le dernier `customerInfo` ; au retour en ligne, l'entitlement expire, l'app passe en gratuit, les données locales restent |
| Remboursement | Événement `CANCELLATION` ou `EXPIRATION` avec raison ; traitement identique à l'expiration |
| Transfert (`TRANSFER`) | L'ancien uid perd l'entitlement, le nouveau le gagne ; `entitlements` mise à jour pour les deux |
| Webhook en avance sur l'app | `scan-ticket` lit `entitlements` ; si absente, interroge l'API RevenueCat avec l'uid |
| Webhook en retard | Le SDK fait foi pour l'interface ; le quota Premium du scan attend `entitlements` ou le secours API |
| Réabonnement après expiration | `purge_after` remis à null ; si la purge a déjà eu lieu, la synchro repart des données locales |
| Suppression de compte avec abonnement actif | Message de résiliation avec `managementURL` ; client RevenueCat supprimé par `delete-account` ; l'abonnement store continue tant qu'il n'est pas résilié |

