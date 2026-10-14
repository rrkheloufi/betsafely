---
id: T-143
title: Fiches stores, déclarations de confidentialité et soumission
status: todo
phase: 14 Mise en production
depends_on: [T-142, T-136, T-140]
manual: true
estimate: M
model: opus
done_at:
---

# T-143 · Fiches stores, déclarations de confidentialité et soumission

## Objectif

Les fiches App Store et Google Play sont complètes dans toutes les langues avec captures, déclarations de confidentialité et classification 18+, les ressources d'aide sont revérifiées, et les builds sont soumis (manuellement).

## Contexte

- docs/manual-setup.md, T-143
- brief 5.3, 11.4, 15
- `.claude/rules/` applicables et `CLAUDE.md`.

## Étape manuelle

**Actions**
1. Suivre docs/manual-setup.md, section T-143

- [ ] Confirmé par Rayan (date : )

**Vérifications automatisables**
- Aucune : la confirmation cochée fait foi.

## Étapes

1. Avant la confirmation manuelle : générer les captures ST-01 à ST-06 en FR et EN-US (au minimum) depuis le flavor prod sur simulateur, vérifier `help_resources` et `bookmakers` (dates `verified_at` de la semaine), mettre à jour le seed si nécessaire et déployer en prod via `/deploy prod`.
2. Après confirmation manuelle : rien à committer ; marquer la V1 livrée dans README.md (version et date).

## Tests

Aucun test exigé par la politique pour cette tâche (configuration, action manuelle ou relais sans logique). Un test ajouté ici serait superflu.

## Sécurité

- [ ] Aucun secret ni valeur réelle dans le diff
- [ ] Aucune dépendance hors de la liste de docs/architecture.md section 10
- [ ] Déclarations App Privacy et Data safety cohérentes avec docs/architecture.md section 13

## Definition of Done

- [ ] Étapes réalisées
- [ ] Tests du tableau écrits et verts, aucun test superflu
- [ ] Checklist sécurité cochée (ou n/a)
- [ ] `make check` vert (plus `make test-db` et `make test-functions` si `supabase/` est touché)
- [ ] Revue `code-reviewer` : OK ou OK avec réserves consignées
- [ ] Statut `done` avec date dans ce fichier et dans `tasks/INDEX.md`
- [ ] Commit unique `chore(T-143): Fiches stores, déclarations de confidentialité et soumission` sur `dev`, sans push (ou rien à committer pour une tâche purement manuelle)

## Notes de revue
