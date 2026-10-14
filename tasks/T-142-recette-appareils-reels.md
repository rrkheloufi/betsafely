---
id: T-142
title: Recette sur appareils réels
status: todo
phase: 14 Mise en production
depends_on: [T-141, T-112, T-132]
manual: true
estimate: M
model: opus
done_at:
---

# T-142 · Recette sur appareils réels

## Objectif

Le parcours complet est validé sur un iPhone et un Android physiques (dont notifications en arrière-plan, widget, synchro sur deux appareils, hors ligne, accessibilité), les anomalies sont consignées en tâches `fix`.

## Contexte

- docs/manual-setup.md, T-142
- brief 15
- `.claude/rules/` applicables et `CLAUDE.md`.

## Étape manuelle

**Actions**
1. Suivre docs/manual-setup.md, section T-142

- [ ] Confirmé par Rayan (date : )

**Vérifications automatisables**
- Aucune : la confirmation cochée fait foi.

## Étapes

1. Après confirmation manuelle : créer les tâches `fix` nécessaires dans `tasks/` (ID T-15x), les enchaîner avec `/batch`, puis cocher la définition de V1 terminée du brief (section 15) dans Notes de revue.

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
- [ ] Commit unique `chore(T-142): Recette sur appareils réels` sur `dev`, sans push (ou rien à committer pour une tâche purement manuelle)

## Notes de revue
