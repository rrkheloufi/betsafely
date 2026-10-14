# Architecture BetSafely

Source de vérité de l'architecture, issue du cadrage validé le 14 octobre 2026 (journal des décisions en fin de document). Le brief produit (`brief.md`, hors dépôt) fait foi pour les règles fonctionnelles F-xx, N-xx, C-xx et P-xx ; ce document fait foi pour la façon de les construire. Le schéma SQL est dans `docs/database.md`, la monétisation dans `docs/monetisation.md`, les tokens dans `docs/design-tokens.md`.

## Périmètre

**Inclus (V1) :** F-01 à F-22 du brief : onboarding, bilan rétroactif, saisie manuelle, scan IA, paris en cours et règlement, notifications locales N-01 à N-05, budget mensuel et alertes avancées, détecteur de chasse aux pertes, vue mensuelle, liste des paris, constats et équivalents, analyses, récap mensuel et annuel avec partage, mode Pause, aide jeu responsable, compte et synchro Premium, export CSV et PDF, widget, profil et réglages, verrouillage biométrique, hors ligne. Six langues au lancement (FR et EN pendant le développement, ES, PT-BR, IT, DE en finition).

**Exclu :** connexion aux comptes bookmakers, résultats sportifs automatiques, bankrolls multiples et mode unités, fonctions sociales, web, tablette dédiée, Apple Watch, paris hippiques et casino, achat à vie, sauvegarde par fichier, mode sombre (V1), paywall sur mesure, notifications distantes, période de grâce de facturation, conversion de devises.

## 0. Principes structurants

- **Hors ligne d'abord.** La base locale `drift` est la source de vérité sur l'appareil. Supabase n'est qu'un miroir pour la synchro Premium, plus le scan, le quota et les référentiels.
- **MVVM du socle.** `ChangeNotifier` et `provider`, jamais Riverpod [6]. Sens unique View → ViewModel → Repository → Service.
- **Montants.** Entiers en unités mineures (`int`), aucune conversion de devise. La devise n'est qu'un symbole d'affichage [17, 43].
- **Logique métier pure** (C-01 à C-12, constats, chasse aux pertes, planification des notifications) dans `lib/domain/logic/`, sans Flutter ni SDK, couverte par des tests unitaires.
- **Mode clair seul** [32]. Les tokens sombres restent documentés pour plus tard, sans être branchés.
- **Paywall RevenueCat** [24, 42], présenté par le service d'achat : aucun SDK n'est importé dans `lib/ui/`.

## 1. Carte de navigation (go_router)

| Route | Écran (maquette) | Paramètres | Garde |
|---|---|---|---|
| `/onboarding/welcome` | ON-01 | | |
| `/onboarding/age` | ON-02 | | |
| `/blocked` | ON-02b | | Terminal : aucune sortie si l'âge est refusé |
| `/onboarding/settings` | ON-03 | | âge confirmé |
| `/onboarding/retro` | ON-04, ON-05, ON-06 | `?step=intro\|form\|result` | âge confirmé |
| `/onboarding/budget` | ON-07 | | âge confirmé |
| `/onboarding/notifications` | ON-08 | | âge confirmé |
| (paywall RevenueCat) | ON-09 = PW-01 | placement `onboarding` | présenté à la fin, puis `/home` |
| `/home` | HO-01 à HO-05 | `?month=AAAA-MM` | onboarding terminé |
| `/bets` | BE-01 | `?filter=all\|open\|settled&bookmaker=&sport=&q=` | onboarding terminé |
| `/bets/new` | AD-02, AD-04 | `?type=single\|multi\|system&from=<betId>` (duplication) | |
| `/bets/:betId` | BE-02 | `?settle=1` ouvre BE-03 | |
| `/bets/:betId/edit` | AD-02 prérempli | | |
| `/scan` | sélection système puis SC-02 | `?source=camera\|gallery` | quota > 0, sinon paywall |
| `/scan/review` | SC-03, SC-04, SC-05 | brouillons passés en `extra` | |
| `/analytics` | AN-01, AN-02 | `?period=month\|3m\|12m\|year\|all` | flou si non abonné |
| `/recap/:period` | RC-01 à RC-09 | `AAAA-MM` ou `AAAA` | période disponible |
| `/recap/:period/share` | RC-08 | | |
| `/budget` | BU-01, BU-02 | | |
| `/pause` | PA-01 | | |
| `/pause/summary/:pauseId` | PA-02 | | |
| `/help` | HE-01 | | aucune (accessible même bloqué ou verrouillé) |
| `/profile` | PR-01 | | |
| `/profile/preferences/:item` | langue, pays, devise, cotes, bookmakers, sports | | |
| `/profile/notifications` | PR-02 | | |
| `/profile/privacy` | PR-03 | | |
| `/profile/retro` | Mon bilan initial (ON-05 et ON-06 réutilisés) | | |
| `/profile/pauses` | historique des pauses | | |
| `/profile/export` | export | | entitlement `premium` |
| `/profile/about` | À propos | | |
| `/account/link` | AC-01 | | entitlement `premium` |
| `/account/email` | AC-02, AC-03 | | entitlement `premium` |
| `/account` | AC-04 | | compte non anonyme |
| `/update-required` | écran bloquant | | version < `app_config.min_version` |

- **Shell :** `StatefulShellRoute` à 4 branches (Accueil, Paris, Analyses, Profil) ; le bouton central ouvre la feuille AD-01 sans route.
- **Verrouillage (LK-01)** : superposition pilotée par le cycle de vie de l'app, pas une route, pour revenir exactement où l'on était.
- **Ordre des redirections :** mise à jour obligatoire, puis âge refusé, puis onboarding inachevé (reprise à l'étape mémorisée, F-01), puis garde de la route.
- **Liens profonds :** `fr.rsquare.betsafely://auth-callback` (dev : `fr.rsquare.betsafely.dev://auth-callback`) pour le lien magique en PKCE [12] ; charge utile des notifications `bets/<id>?settle=1` ou `/home` ; widget `bets/<id>?settle=1` (bouton « Régler », E15) ou `/home`.

## 2. Features

Chaque écran a un ViewModel (`ChangeNotifier`), un état en lecture seule et des `Command`.

| Feature | Écrans | ViewModel : état · commandes | Repositories |
|---|---|---|---|
| onboarding | ON-01 à ON-08 | `OnboardingViewModel` : étape, réglages proposés · `confirmAge`, `declineAge`, `saveSettings`, `skip`, `requestNotifications`, `finish` | Preferences, Reference, Budget, Notification, Subscription, Telemetry |
| retro | ON-04 à ON-06, `/profile/retro` | `RetroViewModel` : lignes, total C-09, équivalent, phrase pays · `addLine`, `updateLine`, `removeLine`, `save` | RetroBalance, Reference, Preferences |
| home | HO-01 à HO-05, AL-01, AL-02 | `HomeViewModel` : mois, `MonthSummary`, jauge, projection, constat, à régler, depuis le début, pause, bannière récap, verrou de mois · `previousMonth`, `nextMonth`, `quickSettle`, `dismissBanner` | Bet, Budget, Pause, RetroBalance, Subscription, Reference |
| bets | BE-01 | `BetListViewModel` : groupes par jour, à régler, filtres, nombre de paris verrouillés · `setFilter`, `search`, `quickSettle` | Bet, Subscription, Reference |
| bet_detail | BE-02, BE-03 | `BetDetailViewModel` : pari, retour potentiel, heure de notification · `settle`, `duplicate`, `delete` | Bet, Notification |
| bet_form | AD-01 à AD-04, AL-03, AL-04 | `BetFormViewModel` : champs, erreurs, retour potentiel, heure de notification, alertes à afficher · `save`, `addSelection`, `removeSelection`, `pickBookmaker` | Bet, Reference, Preferences, Budget, Pause, AlertLog, Notification, Subscription |
| scan | SC-02 à SC-05 | `ScanViewModel` : quota, progression, brouillons, champs à vérifier, erreur · `pickImage`, `scan`, `toggleDraft`, `saveDrafts` | Scan, Bet, Subscription |
| budget | BU-01, BU-02 | `BudgetViewModel` : budget du mois, paliers, budgets détaillés, historique · `setAmount`, `toggleThreshold`, `addScopedBudget`, `removeScopedBudget` | Budget, Bet, Subscription |
| pause | PA-01, PA-02, historique | `PauseViewModel` : pause active, estimation C-10 · `start`, `end` | Pause, Bet, Notification |
| analytics | AN-01, AN-02 | `AnalyticsViewModel` : période, `AnalyticsReport` · `setPeriod` | Bet, AlertLog, Subscription |
| recap | RC-01 à RC-09 | `RecapViewModel` : cartes, index, montants visibles · `next`, `previous`, `toggleAmounts`, `share` | Bet, Budget, Reference, Share, Telemetry |
| paywall | PW-01, PW-02 | `PaywallViewModel` : résultat · `present(placement)`, `restore` | Subscription, Telemetry |
| account | AC-01 à AC-04 | `AccountViewModel` : identité, dernière synchro, état d'abonnement, date de purge · `linkApple`, `linkGoogle`, `sendMagicLink`, `signOut`, `deleteAccount` | Auth, Sync, Subscription |
| profile | PR-01 à PR-03, préférences, À propos | `ProfileViewModel`, `PreferencesViewModel`, `NotificationSettingsViewModel`, `PrivacySettingsViewModel` · bascules et sélections | Preferences, Subscription, Notification, AppLock, Reference |
| data | export, effacement | `DataViewModel` · `exportCsv`, `exportMonthPdf`, `wipeLocal` | Export, Share, Auth, Bet |
| help | HE-01, ON-02b | `HelpViewModel` : ressources du pays · `call`, `openSite` | Reference, Preferences |
| lock | LK-01 | `AppLockViewModel` : verrouillé · `unlock` | AppLock |
| startup | lancement, `/update-required` | `StartupViewModel` : étape d'amorçage · `init` | Preferences, Reference, Auth, Subscription, Notification, Sync |

## 3. Couche données

### 3.1 Services (un par SDK, sans état métier)

| Service | Enveloppe |
|---|---|
| `LocalDatabase` | `drift` (SQLite), tables miroir de la section 5 plus `settings` clé-valeur et `sync_state` |
| `SupabaseService` | `supabase_flutter` : auth (anonyme, jetons d'identité, OTP), requêtes, RPC, Edge Functions |
| `PurchasesService` | `purchases_flutter` et `purchases_ui_flutter` : configuration, `logIn`, `customerInfo`, paywall, restauration |
| `NotificationService` | `flutter_local_notifications`, `timezone`, `flutter_timezone` |
| `LocalAuthService` | `local_auth` |
| `HomeWidgetService` | `home_widget` |
| `ImagePickerService` | `image_picker` (côté long 1600 px, JPEG qualité 80) [7] |
| `ShareService` | `share_plus` |
| `AppleSignInService`, `GoogleSignInService` | `sign_in_with_apple`, `google_sign_in` (jeton d'identité natif) [10] |
| `AnalyticsService` | `posthog_flutter` (région UE, désactivable) [34] |
| `CrashReportingService` | `sentry_flutter` (région UE, filtrage des données personnelles) |
| `PlatformService` | `package_info_plus`, `url_launcher`, `in_app_review` |
| `ExportFileService` | `csv`, `pdf`, `path_provider` |

### 3.2 Repositories (interfaces)

Les flux `Stream` servent à l'observation locale ; toute opération faillible renvoie `Result<T>`.

```dart
abstract class BetRepository {
  Stream<List<Bet>> watchMonth(YearMonth month);
  Stream<List<Bet>> watchToSettle(DateTime now);
  Stream<List<Bet>> watchFiltered(BetFilter filter);
  Future<Result<Bet>> get(String id);
  Future<Result<List<Bet>>> range(DateTime from, DateTime to);
  Future<Result<Bet>> save(BetDraft draft);              // création ou modification
  Future<Result<List<Bet>>> saveAll(List<BetDraft> drafts); // scan multiple
  Future<Result<Bet>> settle(String id, Settlement settlement);
  Future<Result<void>> delete(String id);                 // suppression logique
  Future<Result<YearMonth?>> firstMonth();
}

abstract class ReferenceRepository {
  Future<Result<void>> refresh();                         // si version distante > locale
  Future<Result<List<Bookmaker>>> bookmakers(String country);
  Future<Result<List<Sport>>> sports(String country);
  Future<Result<List<Market>>> markets(String? sportId);
  Future<Result<List<HelpResource>>> helpResources(String country);
  Future<Result<MarketFact>> marketFact(String country);
  Future<Result<List<Equivalent>>> equivalents(String locale);
  Future<Result<Map<String, Duration>>> notificationDurations();
  Future<Result<AppConfig>> appConfig();
}

abstract class PreferencesRepository {
  Stream<UserPreferences> watch();
  Future<Result<void>> update(UserPreferences Function(UserPreferences) change);
  Future<Result<OnboardingProgress>> onboarding();
  Future<Result<void>> setOnboarding(OnboardingProgress progress);
  Future<Result<List<UserBookmaker>>> bookmakerChoices();
  Future<Result<void>> saveBookmakerChoice(UserBookmaker choice);
  Future<Result<List<UserSport>>> sportChoices();
  Future<Result<void>> saveSportChoice(UserSport choice);
}

abstract class BudgetRepository {
  Stream<List<Budget>> watchMonth(YearMonth month);
  Future<Result<Budget>> setGlobal(YearMonth month, int amountMinor, Set<int> thresholds);
  Future<Result<Budget>> setScoped(YearMonth month, BudgetScope scope, String ref, int amountMinor);
  Future<Result<void>> removeScoped(String id);
  Future<Result<List<BudgetMonth>>> history(int months);
}

abstract class PauseRepository {
  Stream<Pause?> watchActive();
  Future<Result<Pause>> start(PauseDuration duration, {required bool notifyMilestones});
  Future<Result<Pause>> end(PauseEndReason reason);
  Future<Result<List<Pause>>> history();
}

abstract class RetroBalanceRepository {
  Stream<List<RetroBalance>> watchAll();
  Future<Result<RetroBalance>> save(RetroBalanceDraft draft);
  Future<Result<void>> delete(String id);
}

abstract class AlertLogRepository {
  Future<Result<void>> record(AlertEvent event);
  Future<Result<AlertEvent?>> lastOfKind(AlertKind kind);
  Future<Result<List<AlertEvent>>> range(DateTime from, DateTime to);
}

abstract class ScanRepository {
  Future<Result<ScanQuota>> quota();
  Future<Result<ScanResult>> scan(Uint8List jpeg);        // erreurs typées : illisible, aucun ticket, hors ligne, délai, quota
}

abstract class SubscriptionRepository {
  Stream<PremiumStatus> watchStatus();                    // actif, essai, fin d'essai, problème de facturation
  Future<Result<PaywallOutcome>> presentPaywall(PaywallPlacement placement);
  Future<Result<PremiumStatus>> restore();
  Future<Result<Uri>> managementUrl();
}

abstract class AuthRepository {
  Stream<AppUser?> watchUser();
  Future<Result<AppUser>> ensureAnonymousSession();       // [8]
  Future<Result<AppUser>> linkWithApple();
  Future<Result<AppUser>> linkWithGoogle();
  Future<Result<void>> sendMagicLink(String email);
  Future<Result<void>> signOut();
  Future<Result<void>> deleteAccount();
}

abstract class SyncRepository {
  Stream<SyncState> watchState();                         // désactivée, inactive, en cours, erreur, dernière synchro
  Future<Result<void>> syncNow();                         // envoi puis récupération
  void scheduleDebounced();                               // 3 s après écriture
  Future<Result<void>> finalPull();                       // fin d'abonnement
}

abstract class NotificationRepository {
  Future<Result<PermissionState>> permission();
  Future<Result<PermissionState>> requestPermission();
  Future<Result<void>> rescheduleAll(DateTime now);       // N-01 à N-05, plafond de 50
  Stream<NotificationAction> watchActions();
}

abstract class ExportRepository {
  Future<Result<List<XFileRef>>> exportCsv();             // paris et sélections
  Future<Result<XFileRef>> exportMonthPdf(YearMonth month);
}

abstract class ShareRepository {
  Future<Result<void>> shareFiles(List<XFileRef> files);
  Future<Result<void>> shareImage(Uint8List png);
}

abstract class AppLockRepository {
  Stream<bool> watchEnabled();
  Future<Result<bool>> authenticate(String reason);
  Future<Result<void>> setEnabled(bool enabled);
}

abstract class WidgetRepository { Future<Result<void>> refresh(); }
abstract class TelemetryRepository { void track(TelemetryEvent event); } // liste fermée 11.3
```

### 3.3 Logique pure (`lib/domain/logic/`)

`BetMath` (C-01 à C-12, conversions de cote C-08, arrondis C-12), `MonthSummaryBuilder`, `InsightSelector` (I-01 à I-07, F-12), `EquivalentPicker` (1 à 12 unités, pertes seulement), `ChaseDetector` (D1 à D3, médiane sur 30 jours, au moins 5 paris, une alerte par 12 h), `BudgetEvaluator` (paliers, projection C-11), `NotificationPlanner` (heure d'envoi, créneau calme, regroupement à 30 min, relance à 24 h, plafond de 50, une notification par jour hors N-01 avec la priorité N-04, N-02, N-03, N-05 [29]), `AnalyticsCalculator` (F-13), `RecapBuilder` (F-14), `PaywallMath` (rien : prix gérés par RevenueCat [42]).

### 3.4 Cache et hors ligne

- **Référentiels :** instantané JSON embarqué dans `assets/reference/` [21], copié dans `drift` au premier lancement. Au lancement en ligne, comparaison de `reference_version` et téléchargement complet si la version distante est plus récente.
- **Données utilisateur :** toujours écrites localement, colonne `dirty` à vrai. Sans compte Premium, rien ne part.
- **Synchro [22, 23] :** envoi des lignes `dirty` par lots (upsert sur `id`), la base serveur refuse une ligne plus ancienne que la sienne (`updated_at` client). Récupération des lignes dont `server_updated_at` dépasse le curseur, application si `remote.updated_at >= local.updated_at`. Déclenchement 3 s après une écriture, à l'ouverture et au retour au premier plan.
- **Erreurs :** chaque Repository traduit les exceptions des Services en `AppError` typée (réseau, délai, quota, non autorisé, conflit, inconnue). Aucune erreur ne bloque une saisie (F-22).

## 4. Backend Supabase

**Ce que fait la plateforme :** Auth (anonyme, Apple, Google, OTP par lien magique via SMTP Brevo [45]), Postgres avec RLS, RPC SQL, `pg_cron`. Aucun bucket Storage : les images de ticket ne sont jamais stockées.

**Edge Functions (Deno) :**

| Fonction | Responsabilité | Pourquoi une fonction |
|---|---|---|
| `scan-ticket` | Session exigée (anonyme ou compte), réservation du quota, appel au modèle de vision avec sortie JSON stricte, validation du JSON, remboursement du quota en cas d'échec ou d'image sans ticket, aucune image ni contenu dans les logs, délai de 20 s | Détient la clé du modèle [38] et fait foi pour le quota |
| `revenuecat-webhook` | Authentification par en-tête secret, idempotence par `event.id`, mise à jour de `entitlements`, `purge_after` à l'expiration, effacé au réabonnement | Appelée par RevenueCat, écrit des tables serveur |
| `delete-account` | Suppression des données en ligne, du client RevenueCat par l'API REST, de l'utilisateur Auth [14, 15] | Nécessite la clé service_role et la clé secrète RevenueCat |

En secours, si `entitlements` n'a pas encore reçu le webhook, `scan-ticket` interroge l'API RevenueCat avec l'uid [8].

## 6. Flux principaux

**Premier lancement**
1. Âge confirmé → local `settings.age_confirmed = true`, `settings.onboarding_step`.
2. Si en ligne : `signInAnonymously` → session Supabase stockée localement ; `Purchases.configure(appUserID: uid)` [8]. Hors ligne : RevenueCat anonyme, puis `logIn(uid)` au premier lancement en ligne.
3. Réglages → local `user_preferences`. Bilan → local `retro_balances`. Budget → local `budgets` (global, mois courant). Permission de notification.
4. Paywall RevenueCat (placement `onboarding`) → `/home`, `settings.onboarding_step = done`.

**Saisie d'un pari**
1. `BetFormViewModel.save` valide (mise, cote, champs) via `BetMath`.
2. Pause active → AL-04 ; confirmation → local `pauses.ended_at`, `end_reason = bet_recorded`.
3. Local `bets` (+ `selections`), `dirty = true`.
4. `BudgetEvaluator` et `ChaseDetector` → AL-01, AL-02 ou AL-03 ; local `alerts_log`.
5. `NotificationRepository.rescheduleAll` → notifications locales ; `WidgetRepository.refresh` → données du widget.
6. Premium avec compte : envoi 3 s plus tard → `bets`, `selections`, `alerts_log` en ligne.

**Règlement depuis une notification, application fermée**
1. Action « Gagné » ou « Perdu » → isolat d'arrière-plan, amorçage minimal (`drift`, `BetRepository`).
2. Local `bets.status`, `return_minor` (C-02), `settled_at`, `dirty = true`.
3. Seuil de budget franchi → N-02 (une par jour) ; replanification ; widget. La synchro attend la prochaine ouverture.

**Scan**
1. `image_picker` (1600 px, qualité 80) → `scan-ticket` avec le jeton de session.
2. Serveur : `has_active_premium` (ou API RevenueCat), `reserve_scan` ; appel du modèle ; échec ou aucun ticket → `refund_scan`. Image jamais écrite.
3. App : brouillons, champs de confiance < 0,7 en `ToConfirmField`, devise ignorée [43] ; validation → local `bets` (`source = scan`, `scan_confidence`).

**Achat**
1. `RevenueCatUI.presentPaywall` → achat dans le store → `customerInfo` mis à jour → `PremiumStatus.active`.
2. RevenueCat → `revenuecat-webhook` → `revenuecat_events`, `entitlements` (actif, `purge_after = null`).
3. Proposition AC-01 si le compte est encore anonyme.

**Activation de la synchro**
1. Apple ou Google natif : jeton d'identité → liaison à l'utilisateur anonyme (même uid) ; e-mail : `updateUser(email)`, lien → `auth-callback`. Identité déjà liée à un autre compte → connexion à ce compte, `Purchases.logIn(uid)`, fusion [11].
2. Envoi de toutes les lignes locales, puis récupération ; local `sync_state.cursor`.

**Fin d'abonnement**
1. Webhook `EXPIRATION` → `entitlements.is_active = false`, `purge_after = expires_at + 90 j`.
2. App : statut inactif → `finalPull` si en ligne → synchro désactivée → bannière avec la date de purge.
3. `pg_cron` purge les lignes en ligne après la date.

**Problème de facturation [26]**
RevenueCat signale `billingIssueDetectedAt` → bannière sur le profil et à l'ouverture : « Ton paiement n'a pas abouti. Mets à jour ton moyen de paiement dans le store. » avec lien de gestion. Aucune période de grâce dans les stores.

**Suppression de compte**
1. AC-04 → confirmation (mention de l'abonnement actif [15]) → `delete-account`.
2. Serveur : suppression des 9 tables, `scan_counters`, `entitlements`, client RevenueCat, utilisateur Auth.
3. App : déconnexion, choix garder ou effacer le local, nouvelle session anonyme au prochain lancement en ligne.

## 8. Matrice des droits

| Ressource | Opération | Anonyme local | Anonyme Supabase | Compte sans Premium | Abonné sans compte | Abonné avec compte | Admin (futur, désactivé) |
|---|---|---|---|---|---|---|---|
| Paris, budgets, pauses, bilan (local) | tout | oui | oui | oui | oui | oui | n/a |
| Mois au-delà des 2 précédents, analyses, paliers, budgets détaillés, chasse aux pertes, export, widget, constats multiples | lecture | non | non | non | oui | oui | n/a |
| Tables utilisateur en ligne | lecture | non | non | propres lignes | non | propres lignes | non |
| Tables utilisateur en ligne | écriture | non | non | non | non | propres lignes | non |
| Référentiels | lecture | instantané local | oui | oui | oui | oui | oui |
| Référentiels | écriture | non | non | non | non | non | oui si `roles_enabled` |
| `scan-ticket` | appel | non | 3 au total | 3 au total | 150 par mois | 150 par mois | n/a |
| `delete-account` | appel | n/a | oui (effacement [14]) | oui | oui | oui | n/a |
| `entitlements` | lecture | non | propre ligne | propre ligne | propre ligne | propre ligne | non |

## 9. Structure du dépôt

```
lib/
  main_dev.dart, main_prod.dart, app.dart
  config/            env.dart, bootstrap.dart (SDK), dependencies.dart (providers), background_entrypoint.dart
  routing/           router.dart, routes.dart, guards.dart
  data/
    services/        database/ (drift : tables, daos, migrations), supabase/, purchases/, notifications/,
                     local_auth/, home_widget/, image_picker/, share/, auth_providers/, analytics/, crash/, platform/, export_file/
    repositories/    <feature>/<feature>_repository.dart (abstrait) et <feature>_repository_impl.dart
    models/          DTO JSON (Supabase, scan, référentiel embarqué)
  domain/
    models/          modèles freezed (Bet, Selection, Budget, Pause, Money, YearMonth, PremiumStatus...)
    logic/           bet_math.dart, insight_selector.dart, chase_detector.dart, budget_evaluator.dart,
                     notification_planner.dart, analytics_calculator.dart, recap_builder.dart, equivalent_picker.dart
    use_cases/       record_bet.dart (formulaire, scan, duplication), settle_bet.dart (app, notification, widget)
  ui/
    core/            theme/ (tokens, BsColors, BsTypography), widgets/ (35 composants de la spec), formatters/
    onboarding/ retro/ home/ bets/ bet_detail/ bet_form/ scan/ budget/ pause/ analytics/ recap/
    paywall/ account/ profile/ data/ help/ lock/ startup/
      view_models/
      widgets/
  l10n/              app_fr.arb (source), app_en.arb, app_es.arb, app_pt.arb, app_it.arb, app_de.arb
  utils/             result.dart, command.dart
assets/              fonts/Inter, reference/snapshot.json, images/logo.png
test/                miroir de lib/, testing/fakes/
integration_test/    parcours critique : onboarding, saisie, règlement, mois
ios/                 Runner, BetSafelyWidget (WidgetKit), PrivacyInfo.xcprivacy, flavors xcconfig
android/             flavors, AppWidget, permissions
supabase/            config.toml, migrations/, functions/{scan-ticket,revenuecat-webhook,delete-account}/, tests/, seed.sql
site/                pages légales et support, publiées sur GitHub Pages [44]
env/                 dev.example.json, prod.example.json
scripts/             check-no-dash.sh, check-no-hex.sh, check-architecture.sh, check-strings.sh
```

`use_cases/` ne contient que les deux flux partagés par plusieurs ViewModels : enregistrer un pari (formulaire, scan, duplication, avec pause, alertes, notifications et widget) et régler un pari (détail, accueil, liste, notification, widget).

## 10. Dépendances

Versions majeures à confirmer en 4a contre pub.dev.

| Package | Justification |
|---|---|
| `provider` | Injection du socle |
| `go_router` | Navigation du socle |
| `freezed`, `freezed_annotation`, `json_serializable`, `json_annotation`, `build_runner` | Modèles immuables du socle |
| `flutter_localizations`, `intl` | Textes ARB et formats de nombres, devises, dates |
| `drift`, `drift_flutter`, `drift_dev` | Base locale relationnelle, requêtes agrégées et migrations, source de vérité hors ligne |
| `supabase_flutter` | Backend imposé |
| `purchases_flutter`, `purchases_ui_flutter` | Monétisation imposée, paywall RevenueCat [24] |
| `flutter_local_notifications`, `timezone`, `flutter_timezone` | Notifications locales N-01 à N-05 avec actions en arrière-plan et fuseau de l'appareil |
| `local_auth` | Verrouillage biométrique F-21 |
| `home_widget` | Pont vers les widgets natifs F-19 |
| `fl_chart` | Courbe et barres des analyses F-13 |
| `image_picker` | Capture et import du ticket avec compression intégrée [7] |
| `share_plus` | Partage du récap et des exports |
| `sign_in_with_apple`, `google_sign_in` | Jetons d'identité natifs [10] |
| `sentry_flutter` | Suivi des crashs (brief 11.1) |
| `posthog_flutter` | Analytics produit UE (brief 11.1) [34] |
| `phosphor_flutter` | Jeu d'icônes imposé par la spec |
| `url_launcher` | Appel et sites des ressources d'aide, liens légaux |
| `package_info_plus` | Version affichée et contrôle de version minimale [35] |
| `in_app_review` | « Noter l'application » (F-20) |
| `csv`, `pdf`, `path_provider` | Export F-18 |
| `uuid` | Identifiants v4 générés hors ligne |
| `mocktail` (dev) | Fakes aux frontières SDK seulement |

La police Inter est embarquée en asset (pas de `google_fonts`, pour le hors ligne).

## 11. Environnements

| | dev | prod |
|---|---|---|
| Flavor | `dev` | `prod` |
| Identifiant | `fr.rsquare.betsafely.dev` | `fr.rsquare.betsafely` |
| Nom affiché | BetSafely Dev | BetSafely |
| Supabase | projet `betsafely-dev`, Francfort [3] | projet `betsafely-prod`, Francfort |
| Tests pgTAP | base locale Docker (dev et CI) | |
| SMTP | SMTP par défaut de Supabase | Brevo [45] |
| RevenueCat | un projet, clés du Test Store | même projet, clés App Store et Play |
| Sentry | environnement `dev` | environnement `prod` |
| PostHog | projet dev | projet prod |
| Schéma de retour | `fr.rsquare.betsafely.dev://auth-callback` | `fr.rsquare.betsafely://auth-callback` |

`env/<flavor>.json` (non versionné) : `FLAVOR`, `SUPABASE_URL`, `SUPABASE_PUBLISHABLE_KEY`, `RC_API_KEY_IOS`, `RC_API_KEY_ANDROID`, `SENTRY_DSN`, `POSTHOG_API_KEY`, `POSTHOG_HOST`, `AUTH_REDIRECT_URL`, `LEGAL_BASE_URL`. Secrets Supabase (jamais dans l'app) : `ANTHROPIC_API_KEY`, `REVENUECAT_WEBHOOK_SECRET`, `REVENUECAT_SECRET_API_KEY`.

## 12. Identifiants sensibles

| Élément | Format | Entropie | Justification |
|---|---|---|---|
| Identifiants des lignes utilisateur | uuid v4 généré par l'appareil | 122 bits | Création hors ligne, non devinable, RLS en plus |
| Session Supabase | JWT et jeton de rafraîchissement gérés par le SDK | SDK | Aucun jeton manipulé par l'app |
| Lien magique | flux PKCE de Supabase, code à usage unique | SDK | Le code intercepté est inutilisable sans le vérificateur resté sur l'appareil |
| Secret du webhook RevenueCat | 32 octets aléatoires, base64url | 256 bits | Seule preuve d'origine du webhook |
| Clés API serveur (Anthropic, RevenueCat secrète) | secrets Supabase | fournisseur | Jamais dans l'app ni dans le dépôt |

Aucun jeton, code ni lien n'est conçu par l'app elle-même.

## 13. Conformité stores

- **Suppression de compte :** Profil > Compte et synchro > Supprimer mon compte ; utilisateur gratuit : Données > Effacer [14].
- **Restauration des achats :** dans le paywall RevenueCat et dans Profil.
- **Mentions d'abonnement :** prix, renouvellement automatique et résiliation dans le paywall, liens Conditions et Confidentialité vers `site/`.
- **Permissions [31] :** `NSCameraUsageDescription`, `NSFaceIDUsageDescription` ; Android `CAMERA`, `POST_NOTIFICATIONS`, `USE_BIOMETRIC`, `RECEIVE_BOOT_COMPLETED` ; pas d'alarme exacte [28].
- **Privacy manifest iOS :** `PrivacyInfo.xcprivacy` avec les API à raison déclarée (UserDefaults, horodatage de fichiers, espace disque) ; manifestes des SDK tiers vérifiés.
- **App Privacy et Data safety :** identifiant utilisateur, achats, diagnostics (crashs), usage (analytics anonymes), e-mail (compte), contenu utilisateur (paris synchronisés) ; aucun suivi, aucune ATT. Images du scan : traitement éphémère, non conservées.
- **Classification :** 18+ volontaire sur l'App Store, public cible 18+ sur Google Play ; catégories Finance puis Sports ; note de validation Apple du brief (11.4).
- **Sauvegarde système :** base `drift` incluse dans iCloud et Auto Backup, session Supabase exclue de la sauvegarde Android.
- **Aperçu masqué :** quand le verrouillage est actif seulement (`FLAG_SECURE` sur Android, vue de masquage sur iOS) [41].

## 14. Écarts avec les maquettes tranchés par l'architecture

| # | Écart | Décision |
|---|---|---|
| A1 | PW-01 et PW-02 sur mesure dans les maquettes | Remplacés par le paywall RevenueCat unique, conçu dans le dashboard d'après PW-01 [42] ; phrase personnalisée et titres contextuels abandonnés |
| A2 | SC-01, viseur maison | Appareil photo du système ; compteur de scans sur AD-01 [7] |
| A3 | Écrans en sombre | Non implémentés en V1 [32] ; `ThemeMode.light` imposé |
| A4 | Avertissement de changement de devise (brief 5.2) | Supprimé [43] |
| A5 | Colonne `currency` sur `bets` (brief 11.2) | Supprimée : la devise vit dans `user_preferences` |
| A6 | `scan_usage (user_id, month, count, free_used)` du brief | Remplacée par `scan_counters`, une ligne par utilisateur, réservation et remboursement atomiques |
| A7 | Tables `selections`, `pauses`, `alerts_log` sans `user_id` ni colonnes de synchro | Complétées (E19) ; tables `user_preferences`, `user_bookmakers`, `user_sports` ajoutées |
| A8 | `sport_custom` absent du brief alors que « Autre » en texte libre est prévu (F-03) | Colonne ajoutée |

## 15. Hypothèses validées (sauf contre-ordre)

1. Enregistrer et régler un pari sont les deux seuls use cases ; le reste passe directement par les Repositories.
2. Un pari sans compte Premium ne quitte jamais l'appareil ; la session anonyme ne sert qu'au quota et à RevenueCat.
3. `logOut` RevenueCat n'est jamais appelé ; une déconnexion crée une nouvelle session anonyme.
4. Les libellés des référentiels sont en JSON par langue dans la base, et non dans les ARB, pour rester modifiables sans version.
5. Le dev utilise le Test Store RevenueCat ; les achats sandbox se testent sur un build prod interne.
6. La synchro attend la prochaine ouverture après un règlement fait depuis une notification.
7. Les tables de référence sont modifiées depuis le Studio Supabase ; le rôle admin existe dans les policies mais reste désactivé.
8. L'accès hors ligne au référentiel repose sur l'instantané embarqué, régénéré depuis `seed.sql` par un script.
9. Le widget et la notification affichent les montants selon les réglages de discrétion, sans autre logique.
10. Le site légal (`site/`) est une tâche de la phase de mise en production, avant la soumission aux stores.


## 16. Journal des décisions

| Date | # | Décision |
|---|---|---|
| 2026-10-14 | D01 | Identifiant d'application `fr.rsquare.betsafely`, `.dev` pour le flavor dev [1] |
| 2026-10-14 | D02 | Dépôt `rrkheloufi/betsafely` ; génération locale tant qu'il n'est pas rattaché [2] |
| 2026-10-14 | D03 | Supabase : projet cloud dev à Francfort, base Docker locale pour pgTAP et CI [3] |
| 2026-10-14 | D04 | iOS 16 et Android API 26 minimum [4] |
| 2026-10-14 | D05 | Flutter stable épinglé avec FVM [5] |
| 2026-10-14 | D06 | ChangeNotifier et provider, jamais Riverpod ; section 11.1 du brief amendée [6] |
| 2026-10-14 | D07 | Capture par `image_picker`, appareil photo du système, sans viseur maison [7] |
| 2026-10-14 | D08 | Session anonyme Supabase au premier lancement en ligne, RevenueCat configuré avec l'uid ; secours par l'API RevenueCat dans `scan-ticket` [8] |
| 2026-10-14 | D09 | Connexion : Apple, Google, lien magique sur iOS ; Google, lien magique sur Android [9] |
| 2026-10-14 | D10 | Apple et Google par jeton natif, repli navigateur si la liaison anonyme l'exige [10] |
| 2026-10-14 | D11 | Connexion sur un second appareil : fusion, la dernière écriture gagne [11] |
| 2026-10-14 | D12 | Retour du lien magique par schéma personnalisé, flux PKCE [12] |
| 2026-10-14 | D13 | Pages légales, support et contact sur un site sur mesure créé en fin de projet [13] |
| 2026-10-14 | D14 | L'effacement gratuit supprime aussi l'utilisateur anonyme et son compteur de scans [14] |
| 2026-10-14 | D15 | Suppression avec abonnement actif : message de résiliation et suppression du client RevenueCat [15] |
| 2026-10-14 | D16 | Rétention : 90 j après expiration, anonymes inactifs 12 mois, suppressions logiques 90 j, Sentry 30 j [16] |
| 2026-10-14 | D17 | Devises purement visuelles, aucune conversion, aucun avertissement ; devise du scan ignorée [17, 43] |
| 2026-10-14 | D18 | Cote facultative pour un pari Système [18] |
| 2026-10-14 | D19 | Pari long terme : date effaçable, sans notification ni « À régler » [19] |
| 2026-10-14 | D20 | Bookmakers : identifiant global et table pays ; choix utilisateur synchronisés [20] |
| 2026-10-14 | D21 | Instantané du référentiel embarqué pour le premier lancement hors ligne [21] |
| 2026-10-14 | D22 | Conflits : `updated_at` client arbitre, `server_updated_at` sert de curseur [22] |
| 2026-10-14 | D23 | Écriture en ligne réservée aux comptes Premium (RLS), lecture permise au propriétaire [23] |
| 2026-10-14 | D24 | Paywall RevenueCat unique, phrase générique, sans titre contextuel [24, 42] |
| 2026-10-14 | D25 | Identifiants produits, entitlement `premium`, offering `default` (section 7) [25] |
| 2026-10-14 | D26 | Aucune période de grâce ; erreur de facturation affichée à l'utilisateur [26] |
| 2026-10-14 | D27 | Essai affiché selon l'éligibilité ; N-04 programmée localement [27] |
| 2026-10-14 | D28 | Alarmes Android inexactes, sans permission d'alarme exacte [28] |
| 2026-10-14 | D29 | Hors N-01, priorité N-04, N-02, N-03, N-05, une par jour [29] |
| 2026-10-14 | D30 | Aucune notification distante, ni Firebase [30] |
| 2026-10-14 | D31 | Textes de permissions validés (section 13) [31] |
| 2026-10-14 | D32 | Téléphone, portrait, mode clair uniquement, texte jusqu'à 200 % [32] |
| 2026-10-14 | D33 | FR et EN pendant le développement ; ES, PT-BR, IT, DE en finition, puis relecture native [33] |
| 2026-10-14 | D34 | Sentry sans consentement ; PostHog UE sous exemption CNIL, désactivable ; pas d'ATT [34] |
| 2026-10-14 | D35 | Version minimale par plateforme dans `app_config`, écran bloquant [35] |
| 2026-10-14 | D36 | Sessions perdues ou révoquées : synchro arrêtée, local conservé, saisie jamais bloquée [36] |
| 2026-10-14 | D37 | Écrans non maquettés construits avec les composants existants [37] |
| 2026-10-14 | D38 | Scan par Claude Haiku 5.5 en JSON strict [38] |
| 2026-10-14 | D39 | Nom BetSafely, distribution dans tous les pays [39] |
| 2026-10-14 | D40 | Comptes Apple Developer et Google Play déjà ouverts [40] |
| 2026-10-14 | D41 | Widget natif via `home_widget` ; aperçu masqué seulement si le verrouillage est actif [41] |
| 2026-10-14 | D42 | Site légal dans `site/`, publié sur GitHub Pages [44] |
| 2026-10-14 | D43 | SMTP Brevo en production [45] |
| 2026-10-14 | D44 | Architecture de la phase 2 validée, ses 10 hypothèses comprises |

