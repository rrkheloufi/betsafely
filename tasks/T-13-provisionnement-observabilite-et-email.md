---
id: T-13
title: Provisionnement Sentry, PostHog et Brevo par script
status: todo
phase: 1 Comptes et services
depends_on: [T-11]
manual: false
estimate: S
model: opus
done_at:
---

# T-13 · Provisionnement Sentry, PostHog et Brevo par script

## Objectif

`scripts/ops/observability-provision.sh` crée le projet Sentry et récupère les clés PostHog dans `env/*.json` ; `scripts/ops/brevo-provision.sh` crée l'expéditeur et le domaine Brevo et affiche les enregistrements DNS à poser.

## Contexte

- docs/manual-setup.md, T-13
- https://docs.sentry.io/api/projects/create-a-new-project, https://posthog.com/docs/api/projects, https://developers.brevo.com/reference/create-domain
- `.claude/rules/` applicables et `CLAUDE.md`.

## Étapes

1. `observability-provision.sh` : Sentry `GET /api/0/organizations/{org}/projects/` puis `POST /api/0/teams/{org}/{team}/projects/` (`betsafely`, platform `flutter`) si absent, `GET /api/0/projects/{org}/betsafely/keys/` pour le DSN public ; PostHog `GET /api/organizations/{org}/projects/` et lecture de `api_token` du projet `BetSafely` (création `POST` si absent) ; écriture de `SENTRY_DSN`, `POSTHOG_API_KEY` dans `env/dev.json` et `env/prod.json` (même projet Sentry avec `environment` dev/prod côté app, un seul projet PostHog) ; idempotent.
2. `brevo-provision.sh` : `POST /v3/senders` (noreply@ du domaine R-Square), `POST /v3/senders/domains` puis `GET` : affiche les enregistrements DNS attendus (code Brevo, DKIM, DMARC) et l'état d'authentification ; `--verify` relance `PUT .../authenticate`. La clé SMTP et les DNS restent à Rayan (docs/manual-setup.md, T-13) ; dès que `secrets/brevo-smtp.env` existe, `supabase-provision.sh prod` pose le SMTP.
3. Exécuter les deux scripts, relancer une fois (idempotence), `scripts/ops/check-secrets.sh env` (env/*.json complets hors clés RevenueCat), commit des scripts.

## Tests

Aucun test exigé par la politique pour cette tâche (configuration, action manuelle ou relais sans logique). Un test ajouté ici serait superflu.

## Sécurité

- [ ] DSN et clés absents des commits
- [ ] Sentry : scrubbing des données personnelles laissé activé par défaut, vérifié par `GET /api/0/projects/{org}/betsafely/` (`scrubIPAddresses`)

## Definition of Done

- [ ] Étapes réalisées
- [ ] Tests du tableau écrits et verts, aucun test superflu
- [ ] Checklist sécurité cochée (ou n/a)
- [ ] `make check` vert (plus `make test-db` et `make test-functions` si `supabase/` est touché)
- [ ] Revue `code-reviewer` : OK ou OK avec réserves consignées
- [ ] Statut `done` avec date dans ce fichier et dans `tasks/INDEX.md`
- [ ] Commit unique `chore(T-13): Provisionnement Sentry, PostHog et Brevo par script` sur `dev`, sans push (ou rien à committer pour une tâche purement manuelle)

## Notes de revue
