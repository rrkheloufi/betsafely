---
id: T-112
title: Achats sandbox et scan sur appareils réels
status: todo
phase: 11 Monétisation
depends_on: [T-111, T-90, T-12, T-28]
manual: true
estimate: M
model: opus
done_at:
---

# T-112 · Achats sandbox et scan sur appareils réels

## Objectif

Essai, conversion, renouvellement, expiration, restauration et remboursement sont vérifiés en sandbox sur iOS et Android avec un build prod interne, et `entitlements` suit chaque événement.

## Contexte

- docs/manual-setup.md, T-112
- docs/monetisation.md
- `.claude/rules/` applicables et `CLAUDE.md`.

## Étape manuelle

**Actions**
1. Suivre docs/manual-setup.md, section T-112

- [ ] Confirmé par Rayan (date : )

**Vérifications automatisables**
- Aucune : la confirmation cochée fait foi.

## Étapes

1. Après confirmation manuelle : consigner dans Notes de revue les écarts observés et créer des tâches `fix` si nécessaire. Rien à committer sauf corrections.

## Tests

Aucun test exigé par la politique pour cette tâche (configuration, action manuelle ou relais sans logique). Un test ajouté ici serait superflu.

## Sécurité

- [ ] Aucune clé Test Store dans le build prod interne

## Definition of Done

- [ ] Étapes réalisées
- [ ] Tests du tableau écrits et verts, aucun test superflu
- [ ] Checklist sécurité cochée (ou n/a)
- [ ] `make check` vert (plus `make test-db` et `make test-functions` si `supabase/` est touché)
- [ ] Revue `code-reviewer` : OK ou OK avec réserves consignées
- [ ] Statut `done` avec date dans ce fichier et dans `tasks/INDEX.md`
- [ ] Commit unique `chore(T-112): Achats sandbox et scan sur appareils réels` sur `dev`, sans push (ou rien à committer pour une tâche purement manuelle)

## Notes de revue
