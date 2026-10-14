---
paths:
  - lib/data/services/purchases/**
  - lib/data/repositories/subscription/**
  - lib/ui/paywall/**
  - supabase/functions/revenuecat-webhook/**
---

# Règles de monétisation (RevenueCat)

- Un seul entitlement : `premium`. Le code teste `customerInfo.entitlements.active.containsKey('premium')`, jamais un identifiant de produit ni un nom de package.
- Offering `default`, packages `$rc_monthly` et `$rc_annual`. Les prix affichés viennent du store via RevenueCat, jamais d'une constante.
- Paywall : `RevenueCatUI.presentPaywall()` depuis `PurchasesService`, exposé au ViewModel par `SubscriptionRepository.presentPaywall(placement)`. Aucun écran de paywall sur mesure. Le `placement` ne sert qu'à l'événement analytics `paywall_viewed`.
- Identité : `Purchases.configure(appUserID: <uid Supabase>)` dès que la session anonyme existe ; `Purchases.logIn(uid)` si l'uid change (liaison, reconnexion). `Purchases.logOut()` n'est jamais appelé.
- Restauration : `Purchases.restorePurchases()` accessible dans le paywall et dans Profil > Abonnement, toujours.
- Problème de facturation : aucune période de grâce ; `billingIssueDetectedAt` non nul affiche une bannière avec `managementURL`. Aucun droit n'est accordé sans entitlement actif.
- Essai : badge et bouton d'essai seulement si `introEligibility` est éligible ; N-04 programmée depuis `expirationDate` quand `periodType == trial`.
- Côté serveur : `revenuecat-webhook` authentifié par `Authorization: Bearer <REVENUECAT_WEBHOOK_SECRET>` (comparaison à temps constant), idempotent par `event.id`, met à jour `entitlements` ; `scan-ticket` et la RLS d'écriture lisent `entitlements`, jamais le client.
- Dev : clé du Test Store RevenueCat dans `env/dev.json` ; jamais une clé Test Store dans un build prod. Les achats sandbox réels se testent sur un build prod interne (TestFlight, test interne Play).
- Analytics : `trial_started`, `purchase_completed(package)`, `paywall_viewed(placement)` sans montant.
