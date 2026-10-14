---
id: T-28
title: Déploiement du backend sur le projet dev
status: todo
phase: 2 Backend
depends_on: [T-20, T-21, T-22, T-23, T-24, T-25, T-26, T-27, T-14]
manual: false
estimate: S
model: opus
done_at:
---

# T-28 · Déploiement du backend sur le projet dev

## Objectif

Les migrations et les trois fonctions sont déployées sur le projet Supabase dev par `/deploy dev`, les secrets sont en place, et le webhook RevenueCat répond 200 à un événement de test envoyé par l'API.

## Contexte

- .claude/skills/deploy/SKILL.md
- docs/manual-setup.md, T-28
- `.claude/rules/` applicables et `CLAUDE.md`.

## Étapes

1. `scripts/ops/supabase-provision.sh dev --secrets-only` (reprend ANTHROPIC_API_KEY, REVENUECAT_WEBHOOK_SECRET, REVENUECAT_SECRET_API_KEY depuis secrets/) ; `supabase secrets list` ne montre que des noms.
2. `/deploy dev` : `supabase db push` puis `supabase functions deploy` pour les trois fonctions.
3. `scripts/ops/revenuecat-test-event.sh dev` : envoie un événement TEST via l'API v2 du webhook (ou, si l'API ne l'offre pas, un POST signé avec le secret vers la fonction) et vérifie une ligne dans `revenuecat_events` par `POST /v1/projects/{ref}/database/query`.
4. Rien à committer sauf le script de test.

## Tests

Aucun test exigé par la politique pour cette tâche (configuration, action manuelle ou relais sans logique). Un test ajouté ici serait superflu.

## Sécurité

- [ ] Les secrets sont posés par l'API ou `supabase secrets set`, jamais dans le code
- [ ] Aucun secret dans la sortie des scripts

## Definition of Done

- [ ] Étapes réalisées
- [ ] Tests du tableau écrits et verts, aucun test superflu
- [ ] Checklist sécurité cochée (ou n/a)
- [ ] `make check` vert (plus `make test-db` et `make test-functions` si `supabase/` est touché)
- [ ] Revue `code-reviewer` : OK ou OK avec réserves consignées
- [ ] Statut `done` avec date dans ce fichier et dans `tasks/INDEX.md`
- [ ] Commit unique `chore(T-28): Déploiement du backend sur le projet dev` sur `dev`, sans push (ou rien à committer pour une tâche purement manuelle)

## Notes de revue
