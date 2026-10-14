---
id: T-12
title: Fiches app dans les stores, clés API stores, Sign in with Apple
status: todo
phase: 1 Comptes et services
depends_on: [T-02, T-10]
manual: true
estimate: M
model: opus
done_at:
---

# T-12 · Fiches app dans les stores, clés API stores, Sign in with Apple

## Objectif

Les fiches app existent dans App Store Connect et Play Console (seules créations sans API), les clés API des deux stores et la clé Sign in with Apple sont dans `secrets/`, les accords sont acceptés ; tout le reste de la configuration store se fait par script (T-15, T-16).

## Contexte

- docs/manual-setup.md, T-12
- secrets/README.md
- docs/architecture.md section 13
- `.claude/rules/` applicables et `CLAUDE.md`.

## Étape manuelle

**Actions**
1. Suivre docs/manual-setup.md, section T-12 : fiche App Store Connect, clé API d'équipe (Admin), Services ID et clé Sign in with Apple, accord Paid Apps, testeur sandbox ; fiche Play Console, compte de service invité avec droits release et abonnements, testeurs de licence

- [ ] Confirmé par Rayan (date : )

**Vérifications automatisables**
- `scripts/ops/check-secrets.sh stores` est vert : secrets/apple.env (ASC_KEY_ID, ASC_ISSUER_ID, ASC_KEY_PATH, APPLE_TEAM_ID), le fichier .p8 pointé, secrets/apple-signin.env (SIGNIN_KEY_ID, SIGNIN_KEY_PATH, SIGNIN_SERVICES_ID), secrets/google-play.json (`jq .client_email`)

## Étapes

1. Après confirmation manuelle : `scripts/ops/check-secrets.sh stores` (secrets/apple.env et AuthKey, secrets/google-play.json, secrets/apple-signin.env et sa clé .p8).
2. Générer le secret client Apple pour Supabase (JWT ES256 signé avec la clé Sign in with Apple, validité 6 mois) par `scripts/ops/apple-signin-secret.sh`, qui l'écrit dans `secrets/apple.env` (`APPLE_OAUTH_CLIENT_ID` = Services ID, `APPLE_OAUTH_SECRET`) et relance `supabase-provision.sh` pour les deux flavors (section Auth seulement). Noter la date d'expiration dans docs/manual-setup.md.
3. Rien d'autre à committer que les scripts.

## Tests

Aucun test exigé par la politique pour cette tâche (configuration, action manuelle ou relais sans logique). Un test ajouté ici serait superflu.

## Sécurité

- [ ] AuthKey .p8, JSON du compte de service et clé Sign in with Apple jamais versionnés ni lus
- [ ] Le secret client Apple est régénéré avant expiration (rappel dans docs/manual-setup.md)

## Definition of Done

- [ ] Étapes réalisées
- [ ] Tests du tableau écrits et verts, aucun test superflu
- [ ] Checklist sécurité cochée (ou n/a)
- [ ] `make check` vert (plus `make test-db` et `make test-functions` si `supabase/` est touché)
- [ ] Revue `code-reviewer` : OK ou OK avec réserves consignées
- [ ] Statut `done` avec date dans ce fichier et dans `tasks/INDEX.md`
- [ ] Commit unique `chore(T-12): Fiches app dans les stores, clés API stores, Sign in with Apple` sur `dev`, sans push (ou rien à committer pour une tâche purement manuelle)

## Notes de revue
