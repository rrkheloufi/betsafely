---
id: T-141
title: Build release signé (appbundle et ipa)
status: todo
phase: 14 Mise en production
depends_on: [T-139, T-12]
manual: true
estimate: S
model: opus
done_at:
---

# T-141 · Build release signé (appbundle et ipa)

## Objectif

`make build-prod` produit un `.aab` et un `.ipa` signés du flavor prod, et le flavor dev reste non signé en release.

## Contexte

- docs/manual-setup.md, T-141
- .claude/skills/deploy/SKILL.md
- `.claude/rules/` applicables et `CLAUDE.md`.

## Étape manuelle

**Actions**
1. Suivre docs/manual-setup.md, section T-141

- [ ] Confirmé par Rayan (date : )

**Vérifications automatisables**
- build/app/outputs/bundle/prodRelease/*.aab existe
- build/ios/ipa/*.ipa existe

## Étapes

1. Après confirmation manuelle : vérifier la configuration de signature (`build.gradle.kts` lit `key.properties` ; Xcode automatic signing avec l'équipe), `make build-prod`, consigner les tailles des artefacts.

## Tests

Aucun test exigé par la politique pour cette tâche (configuration, action manuelle ou relais sans logique). Un test ajouté ici serait superflu.

## Sécurité

- [ ] Keystore et profils jamais versionnés
- [ ] Aucune clé Test Store dans le build prod

## Definition of Done

- [ ] Étapes réalisées
- [ ] Tests du tableau écrits et verts, aucun test superflu
- [ ] Checklist sécurité cochée (ou n/a)
- [ ] `make check` vert (plus `make test-db` et `make test-functions` si `supabase/` est touché)
- [ ] Revue `code-reviewer` : OK ou OK avec réserves consignées
- [ ] Statut `done` avec date dans ce fichier et dans `tasks/INDEX.md`
- [ ] Commit unique `chore(T-141): Build release signé (appbundle et ipa)` sur `dev`, sans push (ou rien à committer pour une tâche purement manuelle)

## Notes de revue
