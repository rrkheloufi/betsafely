---
id: T-12
title: Apps dans les stores, identifiants, keystore, abonnements
status: todo
phase: 1 Comptes et services
depends_on: [T-02]
manual: true
estimate: M
model: opus
done_at:
---

# T-12 · Apps dans les stores, identifiants, keystore, abonnements

## Objectif

Les apps existent dans App Store Connect et Play Console avec leurs identifiants, capacités, abonnements et accords ; la signature release Android et iOS est prête.

## Contexte

- docs/manual-setup.md, T-12
- docs/architecture.md section 13
- `.claude/rules/` applicables et `CLAUDE.md`.

## Étape manuelle

**Actions**
1. Suivre docs/manual-setup.md, section T-12

- [ ] Confirmé par Rayan (date : )

**Vérifications automatisables**
- android/key.properties existe
- android/app/upload.jks existe
- `git check-ignore android/key.properties android/app/upload.jks` renvoie les deux chemins

## Étapes

1. Après confirmation manuelle : vérifier que `android/key.properties` est ignoré par git et que le build release Android se configure (sans le lancer).
2. Rien à committer sauf la configuration de signature dans `build.gradle.kts` si elle manquait (lecture de key.properties, jamais son contenu).

## Tests

Aucun test exigé par la politique pour cette tâche (configuration, action manuelle ou relais sans logique). Un test ajouté ici serait superflu.

## Sécurité

- [ ] key.properties, upload.jks et .p8 ne sont ni versionnés ni lus

## Definition of Done

- [ ] Étapes réalisées
- [ ] Tests du tableau écrits et verts, aucun test superflu
- [ ] Checklist sécurité cochée (ou n/a)
- [ ] `make check` vert (plus `make test-db` et `make test-functions` si `supabase/` est touché)
- [ ] Revue `code-reviewer` : OK ou OK avec réserves consignées
- [ ] Statut `done` avec date dans ce fichier et dans `tasks/INDEX.md`
- [ ] Commit unique `chore(T-12): Apps dans les stores, identifiants, keystore, abonnements` sur `dev`, sans push (ou rien à committer pour une tâche purement manuelle)

## Notes de revue
