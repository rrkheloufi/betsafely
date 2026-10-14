---
id: T-10
title: Projets Supabase dev et prod
status: todo
phase: 1 Comptes et services
depends_on: [T-01]
manual: true
estimate: S
model: opus
done_at:
---

# T-10 · Projets Supabase dev et prod

## Objectif

Les projets Supabase dev et prod existent à Francfort, Auth configurée, `env/dev.json` et `env/prod.json` renseignés, CLI lié au projet dev.

## Contexte

- docs/manual-setup.md, T-10
- docs/architecture.md section 11
- `.claude/rules/` applicables et `CLAUDE.md`.

## Étape manuelle

**Actions**
1. Suivre docs/manual-setup.md, section T-10

- [ ] Confirmé par Rayan (date : )

**Vérifications automatisables**
- env/dev.json et env/prod.json existent avec les clés SUPABASE_URL et SUPABASE_PUBLISHABLE_KEY (`jq keys`)
- `supabase status` répond et le projet lié contient `dev`

## Étapes

1. Après confirmation manuelle : `supabase link` déjà fait, vérifier `supabase status`.
2. Commit : rien à committer sauf si `supabase/config.toml` a été ajusté (project_id).

## Tests

Aucun test exigé par la politique pour cette tâche (configuration, action manuelle ou relais sans logique). Un test ajouté ici serait superflu.

## Sécurité

- [ ] Aucune valeur de env/*.json n'apparaît dans un commit

## Definition of Done

- [ ] Étapes réalisées
- [ ] Tests du tableau écrits et verts, aucun test superflu
- [ ] Checklist sécurité cochée (ou n/a)
- [ ] `make check` vert (plus `make test-db` et `make test-functions` si `supabase/` est touché)
- [ ] Revue `code-reviewer` : OK ou OK avec réserves consignées
- [ ] Statut `done` avec date dans ce fichier et dans `tasks/INDEX.md`
- [ ] Commit unique `chore(T-10): Projets Supabase dev et prod` sur `dev`, sans push (ou rien à committer pour une tâche purement manuelle)

## Notes de revue
