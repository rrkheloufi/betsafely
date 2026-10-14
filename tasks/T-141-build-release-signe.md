---
id: T-141
title: Build release signé (appbundle et ipa)
status: todo
phase: 14 Mise en production
depends_on: [T-139, T-15, T-16]
manual: false
estimate: S
model: opus
done_at:
---

# T-141 · Build release signé (appbundle et ipa)

## Objectif

`make build-prod` produit un `.aab` et un `.ipa` signés du flavor prod avec le keystore de T-16 et les profils de T-15, sans intervention.

## Contexte

- .claude/skills/deploy/SKILL.md
- docs/manual-setup.md, T-141
- `.claude/rules/` applicables et `CLAUDE.md`.

## Étapes

1. Vérifier que `build.gradle.kts` lit `key.properties` et que l'export iOS utilise `ios/ExportOptions.plist` (method app-store-connect, profils de `secrets/apple-signing.env`, signature manuelle) ; `flutter build ipa --export-options-plist`.
2. `make build-prod`, consigner les tailles des artefacts dans Notes de revue.

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
