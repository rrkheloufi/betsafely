---
id: T-08
title: CI GitHub Actions opérationnelle
status: todo
phase: 0 Socle
depends_on: [T-07]
manual: false
estimate: S
model: opus
done_at:
---

# T-08 · CI GitHub Actions opérationnelle

## Objectif

Le workflow `.github/workflows/ci.yml` passe sur `dev` : scripts de contrôle, format, analyse, tests, build Android debug.

## Contexte

- .github/workflows/ci.yml
- Makefile
- `.claude/rules/` applicables et `CLAUDE.md`.

## Étapes

1. Vérifier que la CI reproduit `make check` ; ajuster la version Flutter du workflow à `.fvmrc` si elle a changé.
2. Ajouter un cache Gradle (`gradle/actions/setup-gradle`).
3. Documenter dans README.md les variables de dépôt `CI_RUN_DB_TESTS`, `CI_RUN_FUNCTION_TESTS`, `CI_BUILD_IOS` (à activer par Rayan quand les jobs ont du contenu).

## Tests

Aucun test exigé par la politique pour cette tâche (configuration, action manuelle ou relais sans logique). Un test ajouté ici serait superflu.

## Sécurité

- [ ] Aucun secret ni valeur réelle dans le diff
- [ ] Aucune dépendance hors de la liste de docs/architecture.md section 10
- [ ] Aucun secret attendu par la CI ; env/dev.json y est l'exemple

## Definition of Done

- [ ] Étapes réalisées
- [ ] Tests du tableau écrits et verts, aucun test superflu
- [ ] Checklist sécurité cochée (ou n/a)
- [ ] `make check` vert (plus `make test-db` et `make test-functions` si `supabase/` est touché)
- [ ] Revue `code-reviewer` : OK ou OK avec réserves consignées
- [ ] Statut `done` avec date dans ce fichier et dans `tasks/INDEX.md`
- [ ] Commit unique `chore(T-08): CI GitHub Actions opérationnelle` sur `dev`, sans push (ou rien à committer pour une tâche purement manuelle)

## Notes de revue
