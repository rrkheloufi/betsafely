---
id: T-XX
title: Titre court
status: todo
phase: N Nom de la phase
depends_on: [T-YY]
manual: false
estimate: S
model: opus
done_at:
---

# T-XX · Titre court

## Objectif

Une phrase, résultat observable.

## Contexte

- Documents à lire, fichiers, décisions.

## Étape manuelle

(Seulement si `manual: true`.)

**Actions**
1. ...

- [ ] Confirmé par Rayan (date : )

**Vérifications automatisables**
- ...

## Étapes

1. ...

## Tests

| Test (comportement vérifié) | Fichier | Commande |
|---|---|---|
| ... | ... | ... |

## Sécurité

- [ ] ...

## Definition of Done

- [ ] Étapes réalisées
- [ ] Tests du tableau écrits et verts, aucun test superflu
- [ ] Checklist sécurité cochée (ou n/a)
- [ ] `make check` vert (plus `make test-db` et `make test-functions` si `supabase/` est touché)
- [ ] Revue `code-reviewer` : OK ou OK avec réserves consignées
- [ ] Statut `done` avec date dans ce fichier et dans `tasks/INDEX.md`
- [ ] Commit unique `feat(T-XX): titre` sur `dev`, sans push

## Notes de revue

