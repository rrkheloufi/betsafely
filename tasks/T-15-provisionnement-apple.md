---
id: T-15
title: Provisionnement Apple par API (identifiants, capacités, signature, abonnements)
status: todo
phase: 1 Comptes et services
depends_on: [T-12]
manual: false
estimate: M
model: fable
done_at:
---

# T-15 · Provisionnement Apple par API (identifiants, capacités, signature, abonnements)

## Objectif

`scripts/ops/apple-provision.sh` crée ou retrouve les Bundle IDs `fr.rsquare.betsafely` et `.dev` avec Sign in with Apple et App Groups, le certificat et les profils de distribution, le groupe d'abonnement « BetSafely Premium », les deux abonnements avec prix par territoire et offre d'introduction de 7 jours, et renseigne le secret client Apple dans Supabase.

## Contexte

- docs/manual-setup.md, T-15
- docs/monetisation.md section prix
- brief 7.2
- https://developer.apple.com/documentation/appstoreconnectapi (bundleIds, bundleIdCapabilities, certificates, profiles, subscriptionGroups, subscriptions, subscriptionPrices, subscriptionIntroductoryOffers)
- https://docs.fastlane.tools/app-store-connect-api/
- `.claude/rules/` applicables et `CLAUDE.md`.
- Tâche marquée `model: fable` : une erreur y est coûteuse ou silencieuse ; Fable 5.1 conseillé.

## Étapes

1. `scripts/ops/lib/asc-token.ts` (Deno) : JWT ES256 20 minutes depuis `secrets/apple.env` (ASC_KEY_ID, ASC_ISSUER_ID, ASC_KEY_PATH) ; `asc()` dans common.sh l'utilise.
2. `apple-provision.sh` : 1) `GET /v1/bundleIds?filter[identifier]` puis `POST /v1/bundleIds` pour les deux identifiants (platform IOS) ; `POST /v1/bundleIdCapabilities` `SIGN_IN_WITH_APPLE` et `APP_GROUPS` (`group.fr.rsquare.betsafely`) ; 2) signature : `fastlane cert` et `fastlane sigh` (`--api_key_path secrets/asc-api-key.json` généré depuis apple.env, type appstore, un profil par identifiant) ; profils installés localement, chemins notés dans `secrets/apple-signing.env` pour `make build-prod` ; 3) `GET /v1/apps?filter[bundleId]` pour l'app créée en T-12 ; `POST /v1/subscriptionGroups` « BetSafely Premium » si absent ; `POST /v1/subscriptions` `betsafely_premium_monthly` (P1M) et `betsafely_premium_annual` (P1Y) ; `subscriptionLocalizations` FR, EN, ES, PT-BR, IT, DE (docs/monetisation.md) ; `GET /v1/subscriptions/{id}/pricePoints` puis `POST /v1/subscriptionPrices` par territoire selon brief 7.2 (zone euro 3,99 et 24,99, autres territoires par égalisation) ; `POST /v1/subscriptionIntroductoryOffers` 7 jours gratuits sur l'annuel ; 4) `POST /v1/subscriptionGroupLocalizations` ; 5) In-App Purchase key (`GET /v1/inAppPurchaseKeys`) si présente, notée pour T-14 ; 6) rapport.
3. Idempotent (recherche avant chaque création, mise à jour par PATCH sinon). Relancer une fois.
4. Commit des scripts ; `docs/manual-setup.md` section Résidu manuel mise à jour si l'API refuse une étape (accord manquant 403 REQUIRED_AGREEMENTS_MISSING : arrêt avec le message).

## Tests

| Test (comportement vérifié) | Fichier | Commande |
|---|---|---|
| `asc-token.ts` produit un JWT valide (en-tête ES256, kid, iss, aud appstoreconnect-v1, exp dans 20 min) avec une clé de test générée à la volée | `scripts/ops/tests/asc_token_test.ts` | `deno test scripts/ops/tests/asc_token_test.ts` |

## Sécurité

- [ ] AuthKey .p8 jamais affiché ni copié hors de secrets/
- [ ] Aucune suppression (DELETE) dans le script
- [ ] Prix et durées relus avant exécution contre docs/monetisation.md

## Definition of Done

- [ ] Étapes réalisées
- [ ] Tests du tableau écrits et verts, aucun test superflu
- [ ] Checklist sécurité cochée (ou n/a)
- [ ] `make check` vert (plus `make test-db` et `make test-functions` si `supabase/` est touché)
- [ ] Revue `code-reviewer` : OK ou OK avec réserves consignées
- [ ] Statut `done` avec date dans ce fichier et dans `tasks/INDEX.md`
- [ ] Commit unique `chore(T-15): Provisionnement Apple par API (identifiants, capacités, signature, abonnements)` sur `dev`, sans push (ou rien à committer pour une tâche purement manuelle)

## Notes de revue
