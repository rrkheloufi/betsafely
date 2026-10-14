---
id: T-136
title: Relecture native des textes sensibles
status: todo
phase: 13 Profil et finitions
depends_on: [T-135, T-140]
manual: true
estimate: S
model: opus
done_at:
---

# T-136 · Relecture native des textes sensibles

## Objectif

Les textes du paywall, des mentions d'abonnement, des notifications, des conditions, de la politique de confidentialité et des fiches store sont relus par un natif pour ES, PT-BR, IT et DE, et les corrections intégrées.

## Contexte

- docs/manual-setup.md, T-136
- brief 12
- `.claude/rules/` applicables et `CLAUDE.md`.

## Étape manuelle

**Actions**
1. Suivre docs/manual-setup.md, section T-136

- [ ] Confirmé par Rayan (date : )

**Vérifications automatisables**
- Aucune : la confirmation cochée fait foi.

## Étapes

1. Après confirmation manuelle : intégrer les corrections dans les ARB et `site/`, `make check`, commit.

## Tests

Aucun test exigé par la politique pour cette tâche (configuration, action manuelle ou relais sans logique). Un test ajouté ici serait superflu.

## Sécurité

- [ ] Aucun secret ni valeur réelle dans le diff
- [ ] Aucune dépendance hors de la liste de docs/architecture.md section 10

## Definition of Done

- [ ] Étapes réalisées
- [ ] Tests du tableau écrits et verts, aucun test superflu
- [ ] Checklist sécurité cochée (ou n/a)
- [ ] `make check` vert (plus `make test-db` et `make test-functions` si `supabase/` est touché)
- [ ] Revue `code-reviewer` : OK ou OK avec réserves consignées
- [ ] Statut `done` avec date dans ce fichier et dans `tasks/INDEX.md`
- [ ] Commit unique `feat(T-136): Relecture native des textes sensibles` sur `dev`, sans push (ou rien à committer pour une tâche purement manuelle)

## Notes de revue
