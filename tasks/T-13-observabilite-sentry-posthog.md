---
id: T-13
title: Projets Sentry et PostHog
status: todo
phase: 1 Comptes et services
depends_on: [T-10]
manual: true
estimate: S
model: opus
done_at:
---

# T-13 · Projets Sentry et PostHog

## Objectif

Les projets Sentry (UE) et PostHog (UE) existent et leurs clés sont dans `env/*.json`.

## Contexte

- docs/manual-setup.md, T-13
- `.claude/rules/` applicables et `CLAUDE.md`.

## Étape manuelle

**Actions**
1. Suivre docs/manual-setup.md, section T-13

- [ ] Confirmé par Rayan (date : )

**Vérifications automatisables**
- env/dev.json contient SENTRY_DSN, POSTHOG_API_KEY, POSTHOG_HOST

## Étapes

1. Après confirmation manuelle : rien à committer.

## Tests

Aucun test exigé par la politique pour cette tâche (configuration, action manuelle ou relais sans logique). Un test ajouté ici serait superflu.

## Sécurité

- [ ] DSN et clé PostHog absents des commits

## Definition of Done

- [ ] Étapes réalisées
- [ ] Tests du tableau écrits et verts, aucun test superflu
- [ ] Checklist sécurité cochée (ou n/a)
- [ ] `make check` vert (plus `make test-db` et `make test-functions` si `supabase/` est touché)
- [ ] Revue `code-reviewer` : OK ou OK avec réserves consignées
- [ ] Statut `done` avec date dans ce fichier et dans `tasks/INDEX.md`
- [ ] Commit unique `chore(T-13): Projets Sentry et PostHog` sur `dev`, sans push (ou rien à committer pour une tâche purement manuelle)

## Notes de revue
