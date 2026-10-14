---
id: T-14
title: Provisionnement RevenueCat par API v2 (projet, apps, produits, offering, paywall, webhooks)
status: todo
phase: 1 Comptes et services
depends_on: [T-11, T-12]
manual: false
estimate: M
model: fable
done_at:
---

# T-14 · Provisionnement RevenueCat par API v2 (projet, apps, produits, offering, paywall, webhooks)

## Objectif

`scripts/ops/revenuecat-provision.sh` crée ou retrouve le projet BetSafely, les apps App Store et Play Store (avec clé d'abonnement Apple et compte de service Play), l'entitlement `premium`, les produits, l'offering `default` avec ses packages, le paywall publié, les deux webhooks vers Supabase, et écrit les clés publiques dans `env/*.json` et les secrets de fonctions.

## Contexte

- docs/manual-setup.md, T-14
- docs/monetisation.md
- https://www.revenuecat.com/docs/api-v2 (project, app, product, entitlement, offering, package, integration, paywall)
- `.claude/rules/` applicables et `CLAUDE.md`.
- Tâche marquée `model: fable` : une erreur y est coûteuse ou silencieuse ; Fable 5.1 conseillé.

## Étapes

1. `revenuecat-provision.sh` avec `REVENUECAT_API_KEY_V2` : 1) `GET /v2/projects` ; `POST /v2/projects` si `BetSafely` absent ; 2) `POST /v2/projects/{id}/apps` type `app_store` (`bundle_id`, `shared_secret` depuis secrets/apple-store.env `APP_SHARED_SECRET`, `subscription_private_key` ASC In-App Purchase key si fournie) et `play_store` (`package_name`, `play_service_account_credentials_json` depuis secrets/google-play.json) ; l'app Test Store créée avec le projet est retrouvée par `GET apps` ; 3) produits : App Store `betsafely_premium_monthly`, `betsafely_premium_annual` ; Play `betsafely_premium:monthly`, `betsafely_premium:annual` ; Test Store deux produits équivalents (type subscription, durées P1M et P1Y) ; 4) entitlement `premium` + `attach_products` ; 5) offering `default` (`is_current`), packages `$rc_monthly` et `$rc_annual` + `attach_products` par app ; 6) paywall : `POST /v2/projects/{id}/paywalls` depuis `ops/paywall.json` versionné (textes PW-01 FR et EN, tokens de docs/design-tokens.md, Restaurer, liens Conditions et Confidentialité) puis `actions/publish` ; 7) webhooks `POST /v2/projects/{id}/integrations/webhooks` : un par environnement (`sandbox` vers le projet Supabase dev, `production` vers prod), `authorization_header` = `openssl rand -base64 32` conservé dans `secrets/revenuecat-webhook-<flavor>.env` ; 8) clés publiques : `GET apps/{id}` pour les clés App Store, Play et Test Store ; `env/dev.json` reçoit la clé Test Store dans `RC_API_KEY_IOS` et `RC_API_KEY_ANDROID`, `env/prod.json` les clés App Store et Play ; 9) `supabase-provision.sh <flavor> --secrets-only` pose `REVENUECAT_WEBHOOK_SECRET` et `REVENUECAT_SECRET_API_KEY` (clé v2 restreinte aux abonnés, créée à la main si T-10 ne l'a pas fournie, sinon la clé de provisionnement avec avertissement) ; idempotent par recherche avant création, 60 requêtes par minute respectées (`sleep` entre lots).
2. Si l'API refuse une étape (ressource absente de l'enum, permission manquante), la noter dans docs/manual-setup.md section Résidu manuel plutôt que contourner.
3. Exécuter, relancer (idempotence), `scripts/ops/check-secrets.sh env` vert, commit des scripts et de `ops/paywall.json`.

## Tests

| Test (comportement vérifié) | Fichier | Commande |
|---|---|---|
| Le script passe en mode `OPS_DRY_RUN=1` sans appel réseau et sans fuite de valeur | `scripts/ops/tests/revenuecat_provision_test.sh` | `scripts/ops/tests/revenuecat_provision_test.sh` |

## Sécurité

- [ ] Aucune clé RevenueCat dans un commit
- [ ] Le secret de webhook fait 32 octets aléatoires, un par environnement
- [ ] La clé de provisionnement n'est jamais posée sur Supabase si une clé restreinte existe

## Definition of Done

- [ ] Étapes réalisées
- [ ] Tests du tableau écrits et verts, aucun test superflu
- [ ] Checklist sécurité cochée (ou n/a)
- [ ] `make check` vert (plus `make test-db` et `make test-functions` si `supabase/` est touché)
- [ ] Revue `code-reviewer` : OK ou OK avec réserves consignées
- [ ] Statut `done` avec date dans ce fichier et dans `tasks/INDEX.md`
- [ ] Commit unique `chore(T-14): Provisionnement RevenueCat par API v2 (projet, apps, produits, offering, paywall, webhooks)` sur `dev`, sans push (ou rien à committer pour une tâche purement manuelle)

## Notes de revue
