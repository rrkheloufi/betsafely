---
id: T-110
title: PurchasesService, SubscriptionRepository, paywall et gardes d'entitlement
status: todo
phase: 11 Monétisation
depends_on: [T-40, T-65, T-11]
manual: false
estimate: L
model: opus
done_at:
---

# T-110 · PurchasesService, SubscriptionRepository, paywall et gardes d'entitlement

## Objectif

RevenueCat est configuré avec l'uid Supabase, `watchStatus` reflète l'entitlement `premium`, le paywall RevenueCat s'affiche aux placements prévus, et toutes les gardes (mois, analyses, paliers, budgets, chasse, export, synchro, widget, scans) lisent l'entitlement.

## Contexte

- docs/monetisation.md
- .claude/rules/monetisation.md
- docs/architecture.md section 7
- `.claude/rules/` applicables et `CLAUDE.md`.

## Étapes

1. `PurchasesService` : `Purchases.configure(PurchasesConfiguration(key)..appUserID = uid)` au bootstrap quand la session existe (sinon anonyme puis `logIn(uid)`), `Purchases.setLogLevel` selon flavor, `customerInfoStream`, `presentPaywall()` (purchases_ui_flutter), `restorePurchases`, `getCustomerInfo`, `managementURL`, `checkTrialOrIntroductoryPriceEligibility`.
2. `SubscriptionRepositoryImpl` : `PremiumStatus(active, isTrial, expiresAt, billingIssueAt, managementUrl, trialEligible)` depuis `entitlements.active['premium']` ; `presentPaywall(placement)` → analytics `paywall_viewed(placement)` puis `PaywallOutcome` (purchased, restored, cancelled, error) ; `trial_started` et `purchase_completed(package)` depuis le résultat.
3. Branchement des gardes : routeur (`/profile/export`, `/account/link`), HomeViewModel (mois), BetListViewModel, AnalyticsViewModel, BudgetViewModel, record_bet (chasse), ScanViewModel (quota Premium côté serveur), onboarding `finish` (placement `onboarding`), Profil « Passer à Premium » (T-130).
4. Erreur d'achat → Toast « L'achat n'a pas abouti. Aucun montant n'a été débité. ».

## Tests

| Test (comportement vérifié) | Fichier | Commande |
|---|---|---|
| watchStatus passe actif quand customerInfo contient l'entitlement premium et inactif sinon ; presentPaywall émet paywall_viewed et traduit le résultat (mocktail sur le service) | `test/data/repositories/subscription/subscription_repository_test.dart` | `flutter test test/data/repositories/subscription/subscription_repository_test.dart` |

## Sécurité

- [ ] Aucun secret ni valeur réelle dans le diff
- [ ] Aucune dépendance hors de la liste de docs/architecture.md section 10
- [ ] Entitlement uniquement, jamais un identifiant de produit
- [ ] logOut jamais appelé
- [ ] Clé Test Store seulement en dev

## Definition of Done

- [ ] Étapes réalisées
- [ ] Tests du tableau écrits et verts, aucun test superflu
- [ ] Checklist sécurité cochée (ou n/a)
- [ ] `make check` vert (plus `make test-db` et `make test-functions` si `supabase/` est touché)
- [ ] Revue `code-reviewer` : OK ou OK avec réserves consignées
- [ ] Statut `done` avec date dans ce fichier et dans `tasks/INDEX.md`
- [ ] Commit unique `feat(T-110): PurchasesService, SubscriptionRepository, paywall et gardes d'entitlement` sur `dev`, sans push (ou rien à committer pour une tâche purement manuelle)

## Notes de revue
