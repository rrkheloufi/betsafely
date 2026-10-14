---
id: T-112
title: Builds internes envoyés par script, achats sandbox sur appareils réels
status: todo
phase: 11 Monétisation
depends_on: [T-111, T-90, T-15, T-16, T-28]
manual: true
estimate: M
model: opus
done_at:
---

# T-112 · Builds internes envoyés par script, achats sandbox sur appareils réels

## Objectif

Un build prod interne est envoyé sur TestFlight interne et sur la piste interne Play par `scripts/ops/store-upload.sh`, puis essai, conversion, renouvellement, expiration, restauration et remboursement sont vérifiés en sandbox sur iOS et Android, et `entitlements` suit chaque événement.

## Contexte

- docs/manual-setup.md, T-112
- docs/monetisation.md
- .claude/skills/ops/SKILL.md
- `.claude/rules/` applicables et `CLAUDE.md`.

## Étape manuelle

**Actions**
1. Sur iPhone avec le compte sandbox et sur Android avec le testeur de licence : essai, conversion, renouvellement, expiration, restauration sur un second appareil, remboursement ; scan d'un ticket réel, d'une capture, d'une image sans ticket, hors ligne (docs/manual-setup.md, T-112)

- [ ] Confirmé par Rayan (date : )

**Vérifications automatisables**
- Aucune : la confirmation cochée fait foi.

## Étapes

1. Avant la confirmation manuelle : `scripts/ops/store-upload.sh ios testflight` (`make build-prod` iOS puis `fastlane pilot upload --api_key_path --skip_waiting_for_build_processing`, groupe interne) et `scripts/ops/store-upload.sh android internal` (`make build-prod` Android puis `fastlane supply --aab --track internal --json_key secrets/google-play.json`) ; pour Android, si Play refuse le premier envoi par API, afficher l'instruction du premier envoi par la console (docs/manual-setup.md, Résidu manuel) et relancer après ; puis `play-provision.sh` si T-16 l'avait reporté.
2. Après confirmation manuelle : `scripts/ops/revenuecat-customer.sh <app_user_id>` (API v2, lecture des abonnements du client de test) et `scripts/ops/supabase-query.sh dev "select * from entitlements where user_id = ..."` pour confirmer chaque transition ; consigner les écarts en tâches `fix`.

## Tests

Aucun test exigé par la politique pour cette tâche (configuration, action manuelle ou relais sans logique). Un test ajouté ici serait superflu.

## Sécurité

- [ ] Aucune clé Test Store dans le build prod interne
- [ ] L'envoi n'a lieu que sur les pistes internes (le script refuse toute autre piste)

## Definition of Done

- [ ] Étapes réalisées
- [ ] Tests du tableau écrits et verts, aucun test superflu
- [ ] Checklist sécurité cochée (ou n/a)
- [ ] `make check` vert (plus `make test-db` et `make test-functions` si `supabase/` est touché)
- [ ] Revue `code-reviewer` : OK ou OK avec réserves consignées
- [ ] Statut `done` avec date dans ce fichier et dans `tasks/INDEX.md`
- [ ] Commit unique `chore(T-112): Builds internes envoyés par script, achats sandbox sur appareils réels` sur `dev`, sans push (ou rien à committer pour une tâche purement manuelle)

## Notes de revue
