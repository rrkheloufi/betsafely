---
id: T-10
title: Jetons d'accès des services (Supabase, RevenueCat, Sentry, PostHog, Brevo, Anthropic, Turnstile)
status: todo
phase: 1 Comptes et services
depends_on: [T-01]
manual: true
estimate: S
model: opus
done_at:
---

# T-10 · Jetons d'accès des services (Supabase, RevenueCat, Sentry, PostHog, Brevo, Anthropic, Turnstile)

## Objectif

Tous les jetons qui permettent de provisionner les services sans console sont déposés dans `secrets/` (jamais versionné, jamais lu par Claude), vérifiés par présence des clés attendues.

## Contexte

- docs/manual-setup.md, T-10
- secrets/README.md
- `.claude/rules/` applicables et `CLAUDE.md`.

## Étape manuelle

**Actions**
1. Déposer les jetons listés dans docs/manual-setup.md, section T-10, dans secrets/ (un fichier .env par service, modèle dans secrets/README.md)

- [ ] Confirmé par Rayan (date : )

**Vérifications automatisables**
- `scripts/ops/check-secrets.sh services` est vert : secrets/supabase.env (SUPABASE_ACCESS_TOKEN, SUPABASE_ORG_SLUG), secrets/revenuecat.env (REVENUECAT_API_KEY_V2), secrets/sentry.env (SENTRY_AUTH_TOKEN, SENTRY_ORG), secrets/posthog.env (POSTHOG_PERSONAL_API_KEY, POSTHOG_ORG_ID), secrets/brevo.env (BREVO_API_KEY), secrets/anthropic.env (ANTHROPIC_API_KEY), secrets/turnstile.env (TURNSTILE_SITE_KEY, TURNSTILE_SECRET_KEY)

## Étapes

1. Après confirmation manuelle : `scripts/ops/check-secrets.sh services` (présence des fichiers et des clés attendues, sans afficher de valeur).
2. Rien à committer sauf `secrets/README.md` s'il a dû être précisé.

## Tests

Aucun test exigé par la politique pour cette tâche (configuration, action manuelle ou relais sans logique). Un test ajouté ici serait superflu.

## Sécurité

- [ ] Aucune valeur de secrets/ n'apparaît dans un commit ni dans la conversation
- [ ] `git check-ignore secrets/supabase.env` renvoie le chemin

## Definition of Done

- [ ] Étapes réalisées
- [ ] Tests du tableau écrits et verts, aucun test superflu
- [ ] Checklist sécurité cochée (ou n/a)
- [ ] `make check` vert (plus `make test-db` et `make test-functions` si `supabase/` est touché)
- [ ] Revue `code-reviewer` : OK ou OK avec réserves consignées
- [ ] Statut `done` avec date dans ce fichier et dans `tasks/INDEX.md`
- [ ] Commit unique `chore(T-10): Jetons d'accès des services (Supabase, RevenueCat, Sentry, PostHog, Brevo, Anthropic, Turnstile)` sur `dev`, sans push (ou rien à committer pour une tâche purement manuelle)

## Notes de revue
