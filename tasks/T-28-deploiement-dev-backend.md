---
id: T-28
title: Déploiement du backend sur le projet dev
status: todo
phase: 2 Backend
depends_on: [T-20, T-21, T-22, T-23, T-24, T-25, T-26, T-27, T-11]
manual: true
estimate: S
model: opus
done_at:
---

# T-28 · Déploiement du backend sur le projet dev

## Objectif

Les migrations et les trois fonctions sont déployées sur le projet Supabase dev, les secrets posés, et le webhook RevenueCat répond 200 à l'événement TEST.

## Contexte

- docs/manual-setup.md, T-28
- .claude/skills/deploy/SKILL.md
- `.claude/rules/` applicables et `CLAUDE.md`.

## Étape manuelle

**Actions**
1. Suivre docs/manual-setup.md, section T-28

- [ ] Confirmé par Rayan (date : )

**Vérifications automatisables**
- `supabase secrets list` liste ANTHROPIC_API_KEY
- Le projet lié contient dev

## Étapes

1. Après confirmation manuelle : `supabase db push` puis `supabase functions deploy scan-ticket`, `revenuecat-webhook`, `delete-account` (projet dev, demandes de permission).
2. Envoyer l'événement TEST depuis le dashboard RevenueCat et vérifier une ligne dans `revenuecat_events` (via Studio ou `supabase db` query).
3. Rien à committer.

## Tests

Aucun test exigé par la politique pour cette tâche (configuration, action manuelle ou relais sans logique). Un test ajouté ici serait superflu.

## Sécurité

- [ ] Les secrets sont posés par `supabase secrets set`, jamais dans le code

## Definition of Done

- [ ] Étapes réalisées
- [ ] Tests du tableau écrits et verts, aucun test superflu
- [ ] Checklist sécurité cochée (ou n/a)
- [ ] `make check` vert (plus `make test-db` et `make test-functions` si `supabase/` est touché)
- [ ] Revue `code-reviewer` : OK ou OK avec réserves consignées
- [ ] Statut `done` avec date dans ce fichier et dans `tasks/INDEX.md`
- [ ] Commit unique `chore(T-28): Déploiement du backend sur le projet dev` sur `dev`, sans push (ou rien à committer pour une tâche purement manuelle)

## Notes de revue
