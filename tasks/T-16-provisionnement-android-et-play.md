---
id: T-16
title: Signature Android et provisionnement Play par API (abonnements, pistes)
status: todo
phase: 1 Comptes et services
depends_on: [T-12]
manual: false
estimate: M
model: fable
done_at:
---

# T-16 · Signature Android et provisionnement Play par API (abonnements, pistes)

## Objectif

`scripts/ops/android-signing.sh` génère le keystore d'envoi et `android/key.properties` ; `scripts/ops/play-provision.sh` crée l'abonnement `betsafely_premium` avec ses plans de base et son offre d'essai via l'API Google Play Developer, et vérifie l'accès du compte de service.

## Contexte

- docs/manual-setup.md, T-16
- docs/monetisation.md
- https://developers.google.com/android-publisher/api-ref/rest (monetization.subscriptions, basePlans, offers, edits)
- `.claude/rules/` applicables et `CLAUDE.md`.
- Tâche marquée `model: fable` : une erreur y est coûteuse ou silencieuse ; Fable 5.1 conseillé.

## Étapes

1. `android-signing.sh` : si `android/app/upload.jks` absent, `keytool -genkey -v -keystore android/app/upload.jks -alias upload -keyalg RSA -keysize 2048 -validity 10000` avec mot de passe `openssl rand -base64 24` conservé dans `secrets/android-keystore.env` ; écrit `android/key.properties` ; `git check-ignore` sur les deux fichiers ; rapport sans mot de passe.
2. `play-provision.sh` : jeton OAuth du compte de service (`secrets/google-play.json`, JWT RS256 par `scripts/ops/lib/google-token.ts` Deno, scope androidpublisher) ; `GET /androidpublisher/v3/applications/fr.rsquare.betsafely/subscriptions` ; `POST subscriptions` `betsafely_premium` avec `basePlans` `monthly` (P1M) et `annual` (P1Y), prix régionaux depuis `ops/play-prices.json` versionné (brief 7.2), `listings` dans les 8 langues ; `basePlans.activate` ; `offers.create` `annual-trial-7d` (essai 7 jours, `annual`) puis `activate` ; idempotent par `GET` puis `PATCH`.
3. Si l'API répond que l'app exige un premier envoi par la console, le script s'arrête avec ce message : la création des abonnements est alors reprise par `scripts/ops/store-upload.sh android internal` (T-112) qui relance `play-provision.sh` après le premier envoi.
4. Commit des scripts et de `ops/play-prices.json` ; `docs/manual-setup.md` section Résidu manuel : Play App Signing accepté au premier envoi, testeurs de licence, questionnaire de contenu.

## Tests

| Test (comportement vérifié) | Fichier | Commande |
|---|---|---|
| `google-token.ts` produit une assertion JWT RS256 valide pour une clé de test | `scripts/ops/tests/google_token_test.ts` | `deno test scripts/ops/tests/google_token_test.ts` |

## Sécurité

- [ ] Keystore, key.properties et JSON du compte de service jamais versionnés ni affichés
- [ ] Aucune publication sur une piste de production dans ce script

## Definition of Done

- [ ] Étapes réalisées
- [ ] Tests du tableau écrits et verts, aucun test superflu
- [ ] Checklist sécurité cochée (ou n/a)
- [ ] `make check` vert (plus `make test-db` et `make test-functions` si `supabase/` est touché)
- [ ] Revue `code-reviewer` : OK ou OK avec réserves consignées
- [ ] Statut `done` avec date dans ce fichier et dans `tasks/INDEX.md`
- [ ] Commit unique `chore(T-16): Signature Android et provisionnement Play par API (abonnements, pistes)` sur `dev`, sans push (ou rien à committer pour une tâche purement manuelle)

## Notes de revue
