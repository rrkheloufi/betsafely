---
name: ops
description: Pilote les services par script avec les jetons de secrets/ (provisionnement Supabase, RevenueCat, Apple, Play, observabilité, Brevo ; envoi des builds ; fiches stores ; soumission). Usage /ops <supabase dev|prod> | revenuecat | apple | play | observability | brevo | upload <ios|android> <piste> | metadata | submit X.Y.Z.
argument-hint: "<service> [arguments]"
disable-model-invocation: true
effort: high
---

# /ops $ARGUMENTS

Tu exécutes une opération de `scripts/ops/` sans jamais lire `secrets/` ni `env/*.json`. Si le script demandé n'existe pas encore, dis quelle tâche le crée (`scripts/ops/README.md`) et arrête.

## Procédure

1. `scripts/ops/check-secrets.sh <groupe>` pour le groupe concerné (`services`, `stores`, `supabase`, `env`). Manque : affiche les noms manquants et la section correspondante de `docs/manual-setup.md`, arrêt.
2. Rappelle en une ligne ce que le script va créer ou modifier, puis lance-le :
   - `supabase dev|prod` : `scripts/ops/supabase-provision.sh <flavor>` ; `--secrets-only` pour ne reposer que les secrets de fonctions.
   - `revenuecat`, `apple`, `play`, `observability`, `brevo` : le script de provisionnement correspondant.
   - `upload ios testflight|appstore`, `upload android internal|production [--rollout r]` : `scripts/ops/store-upload.sh` (demande de permission ; construit le flavor prod d'abord).
   - `metadata` : `scripts/ops/store-metadata.sh` (fiches, captures, classification, data safety).
   - `submit X.Y.Z` : vérifie que `vX.Y.Z` est tagué sur `main` et que les builds de cette version sont envoyés ; affiche le récapitulatif ; attend la phrase exacte `oui, soumets X.Y.Z` de Rayan ; puis `scripts/ops/store-submit.sh X.Y.Z`.
3. Lis la sortie. Une étape refusée par une API est consignée par le script dans `docs/manual-setup.md`, section Résidu manuel : relis-la, et dis à Rayan en une ligne ce qui lui reste à faire et où.
4. Relance une fois les scripts de provisionnement pour confirmer l'idempotence (aucune création à la seconde passe).
5. Rapport : ressources créées ou retrouvées (noms, jamais de clé), fichiers `env/*.json` et `secrets/*.env` écrits (noms des clés seulement), résidu manuel.

## Interdits

Afficher une valeur de `secrets/` ou de `env/*.json` ; appeler `fastlane`, `xcrun altool` ou une API directement hors des scripts ; toute suppression de ressource distante ; `store-submit.sh` sans la phrase de confirmation ; envoi sur une piste de production depuis `/ops upload` sans `/deploy prod` préalable.
