---
id: T-140
title: Site légal et support (GitHub Pages)
status: todo
phase: 14 Mise en production
depends_on: [T-135]
manual: false
estimate: M
model: opus
done_at:
---

# T-140 · Site légal et support (GitHub Pages)

## Objectif

`site/` contient la politique de confidentialité, les conditions d'utilisation, la page de support et le contact dans les 6 langues, publié sur GitHub Pages, et l'app pointe dessus (`LEGAL_BASE_URL`).

## Contexte

- cadrage décisions 13, 44
- brief 11.4
- docs/architecture.md section 13
- `.claude/rules/` applicables et `CLAUDE.md`.

## Étapes

1. HTML statique sans framework (une page par langue et par document, `index.html` qui détecte la langue), tokens de docs/design-tokens.md, aucun suivi, aucun cookie tiers, mentions légales R-Square (micro-entreprise, Mérignac), adresse de contact fournie par Rayan (placeholder `contact@REPLACE` à remplacer avant publication).
2. Politique de confidentialité : données locales par défaut, synchro Premium, images de scan transmises au fournisseur de vision sans conservation ni entraînement, Sentry et PostHog UE, droits RGPD, rétention (90 jours, 12 mois), suppression de compte dans l'app.
3. Workflow `.github/workflows/pages.yml` déployant `site/` sur `main` ; `LEGAL_BASE_URL` dans `env/*.example.json` ; liens « Conditions » et « Confidentialité » de l'app et du paywall RevenueCat mis à jour.

## Tests

Aucun test exigé par la politique pour cette tâche (configuration, action manuelle ou relais sans logique). Un test ajouté ici serait superflu.

## Sécurité

- [ ] Aucun secret ni valeur réelle dans le diff
- [ ] Aucune dépendance hors de la liste de docs/architecture.md section 10
- [ ] Aucun script tiers dans le site

## Definition of Done

- [ ] Étapes réalisées
- [ ] Tests du tableau écrits et verts, aucun test superflu
- [ ] Checklist sécurité cochée (ou n/a)
- [ ] `make check` vert (plus `make test-db` et `make test-functions` si `supabase/` est touché)
- [ ] Revue `code-reviewer` : OK ou OK avec réserves consignées
- [ ] Statut `done` avec date dans ce fichier et dans `tasks/INDEX.md`
- [ ] Commit unique `feat(T-140): Site légal et support (GitHub Pages)` sur `dev`, sans push (ou rien à committer pour une tâche purement manuelle)

## Notes de revue
