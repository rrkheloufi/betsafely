---
id: T-11
title: Provisionnement des projets Supabase dev et prod par script
status: todo
phase: 1 Comptes et services
depends_on: [T-10]
manual: false
estimate: M
model: fable
done_at:
---

# T-11 · Provisionnement des projets Supabase dev et prod par script

## Objectif

`scripts/ops/supabase-provision.sh dev` et `prod` créent (ou retrouvent) les projets à Francfort via l'API de gestion, configurent Auth, écrivent `env/<flavor>.json`, posent les secrets de fonctions et lient le CLI à dev ; relançables sans effet de bord.

## Contexte

- docs/manual-setup.md, T-11
- docs/architecture.md section 11
- https://supabase.com/docs/reference/api/v1-create-a-project, v1-update-auth-service-config, v1-get-project-api-keys, v1-bulk-create-secrets
- `.claude/rules/` applicables et `CLAUDE.md`.
- Tâche marquée `model: fable` : une erreur y est coûteuse ou silencieuse ; Fable 5.1 conseillé.

## Étapes

1. `scripts/ops/lib/common.sh` : chargement de `secrets/<service>.env` par `set -a; source`, `require_var`, `api()` (curl silencieux, Bearer, jq, échec explicite sur code HTTP non 2xx, jamais d'écho d'un corps contenant un jeton), `confirm()` pour les scripts demandant une phrase.
2. `supabase-provision.sh <dev|prod>` : 1) `GET /v1/projects` ; si `betsafely-<flavor>` absent, `POST /v1/projects` (`organization_slug`, `region_selection` eu-central-1, `db_pass` généré par `openssl rand -base64 24` et conservé dans `secrets/supabase-<flavor>.env` sous `SUPABASE_DB_PASSWORD`) puis attente de `status = ACTIVE_HEALTHY` ; 2) `GET /v1/projects/{ref}/api-keys?reveal=true` et écriture de `env/<flavor>.json` depuis `env/<flavor>.example.json` (`SUPABASE_URL`, `SUPABASE_PUBLISHABLE_KEY`, `AUTH_REDIRECT_URL`, `POSTHOG_HOST`) avec `jq`, sans toucher aux clés déjà renseignées par d'autres scripts ; 3) `PATCH /v1/projects/{ref}/config/auth` : `external_anonymous_users_enabled`, `security_manual_linking_enabled`, `site_url`, `uri_allow_list` (`fr.rsquare.betsafely[.dev]://auth-callback`), `mailer_otp_exp`, `security_captcha_enabled` + `provider: turnstile` + `secret` (secrets/turnstile.env), Apple et Google quand `secrets/apple.env` et `secrets/google-oauth.env` existent (sinon avertissement et reprise par T-15), SMTP Brevo en prod seulement quand `secrets/brevo-smtp.env` existe ; 4) `POST /v1/projects/{ref}/secrets` : `ANTHROPIC_API_KEY`, et `REVENUECAT_WEBHOOK_SECRET` + `REVENUECAT_SECRET_API_KEY` s'ils existent déjà (sinon posés par T-14) ; 5) `POST /v1/projects/{ref}/database/query` `create extension if not exists pg_cron` ; 6) pour dev : `supabase link --project-ref <ref>` avec `SUPABASE_ACCESS_TOKEN` et `SUPABASE_DB_PASSWORD` exportés ; 7) écriture de `secrets/supabase-<flavor>.env` (`SUPABASE_PROJECT_REF`) ; 8) rapport sans valeur secrète.
3. Exécuter `scripts/ops/supabase-provision.sh dev` puis `prod` ; relancer `dev` une seconde fois : aucune création, aucune erreur (idempotence).
4. `scripts/ops/check-secrets.sh supabase` et `supabase status` verts ; commit des scripts et de `docs/manual-setup.md` si précisé.

## Tests

| Test (comportement vérifié) | Fichier | Commande |
|---|---|---|
| Le script est idempotent et n'écrit aucune valeur secrète sur stdout (exécution à blanc avec `OPS_DRY_RUN=1` et un faux secrets/) | `scripts/ops/tests/supabase_provision_test.sh` | `scripts/ops/tests/supabase_provision_test.sh` |

## Sécurité

- [ ] Les jetons ne sortent jamais de secrets/ ni des variables d'environnement du script
- [ ] `db_pass` généré, jamais affiché
- [ ] Aucune valeur de env/*.json ni de secrets/ dans un commit

## Definition of Done

- [ ] Étapes réalisées
- [ ] Tests du tableau écrits et verts, aucun test superflu
- [ ] Checklist sécurité cochée (ou n/a)
- [ ] `make check` vert (plus `make test-db` et `make test-functions` si `supabase/` est touché)
- [ ] Revue `code-reviewer` : OK ou OK avec réserves consignées
- [ ] Statut `done` avec date dans ce fichier et dans `tasks/INDEX.md`
- [ ] Commit unique `chore(T-11): Provisionnement des projets Supabase dev et prod par script` sur `dev`, sans push (ou rien à committer pour une tâche purement manuelle)

## Notes de revue
