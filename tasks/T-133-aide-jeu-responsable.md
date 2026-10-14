---
id: T-133
title: Aide jeu responsable HE-01
status: todo
phase: 13 Profil et finitions
depends_on: [T-30, T-06]
manual: false
estimate: S
model: opus
done_at:
---

# T-133 · Aide jeu responsable HE-01

## Objectif

L'écran Aide affiche la ressource du pays (téléphone cliquable, site, horaires), l'autoexclusion quand elle existe, la ressource internationale et un accès à la pause, en deux taps depuis l'accueil et depuis chaque alerte.

## Contexte

- brief F-16, P-07
- docs/design-tokens.md (HE-01)
- `.claude/rules/` applicables et `CLAUDE.md`.

## Étapes

1. `HelpViewModel` depuis `ReferenceRepository.helpResources(country)` ; `call` (`tel:`), `openSite` (`https`), lien « Faire une pause dans l'app » → PA-01.
2. Écran HE-01 accessible sans garde (`/help`), lien « Besoin d'aide ? » des `AlertModal` AL-01, AL-03 et écran ON-02b.

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
- [ ] Commit unique `feat(T-133): Aide jeu responsable HE-01` sur `dev`, sans push (ou rien à committer pour une tâche purement manuelle)

## Notes de revue
