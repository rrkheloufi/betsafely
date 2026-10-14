---
name: deploy
description: Déploie BetSafely. /deploy dev pousse migrations et fonctions sur le projet Supabase dev, construit le flavor dev et pousse dev. /deploy prod prépare une version (version, tag, build release signé) avec confirmation explicite ; l'envoi et la soumission aux stores se font ensuite par /ops upload et /ops submit.
argument-hint: "dev | prod"
disable-model-invocation: true
effort: high
---

# /deploy $0

## `/deploy dev`

1. Branche `dev`, arbre propre. Sinon, arrêt.
2. `make check`, `make test-db`, `make test-functions`. Rouge : arrêt.
3. Vérifie que le projet Supabase lié est **dev** (`supabase status`, nom contenant `dev`). Sinon `supabase link --project-ref <ref dev>` (demande de permission).
4. `scripts/ops/supabase-provision.sh dev --secrets-only` (secrets de fonctions depuis `secrets/`), puis `supabase db push` et `supabase functions deploy` (chaque fonction).
5. `make build-dev` (APK debug du flavor dev).
6. `git push -u origin dev` (demande de permission).
7. Rapport : migrations appliquées, fonctions déployées, chemin du build, hash poussé.

## `/deploy prod`

1. Préconditions : branche `dev`, arbre propre, toutes les tâches de la version visée `done` dans `tasks/INDEX.md` (la version est nommée dans l'index). Sinon, arrêt avec la liste.
2. Incrémente `version` dans `pubspec.yaml` (X.Y.Z+build : build toujours +1, Z ou Y selon ce que je demande) et commit `chore: version X.Y.Z+build`.
3. `make check`, `make test-db`, `make test-functions`, puis `make test-integration` (appareil ou émulateur requis ; si indisponible, arrêt et instruction).
4. Affiche le récapitulatif (version, migrations à appliquer, fonctions, tag) et **demande ma confirmation explicite** (« oui, déploie X.Y.Z »). Sans cette phrase, arrêt.
5. `supabase link --project-ref <ref prod>` (ref lue par le script depuis `secrets/supabase-prod.env`, jamais affichée), `scripts/ops/supabase-provision.sh prod --secrets-only`, `supabase db push`, `supabase functions deploy` (chaque fonction).
6. `git switch main`, `git merge --ff-only dev`, `git tag vX.Y.Z`, `git push origin main --tags`, `git switch dev`.
7. `make build-prod` : `flutter build appbundle --release --flavor prod` et `flutter build ipa --release --flavor prod --export-options-plist ios/ExportOptions.plist`, signés avec le keystore de T-16 et les profils de T-15.
8. `supabase link --project-ref <ref dev>` pour rendre le CLI à dev.
9. Rapport : version, tag, chemins des artefacts, puis proposer `/ops upload ios appstore`, `/ops upload android production`, `/ops metadata` et `/ops submit X.Y.Z`.

## Interdits

Envoi ou soumission aux stores depuis cette commande (ils passent par `/ops`), `xcrun altool`, `notarytool`, `fastlane` direct, `git push --force`, `supabase db reset --linked`, déploiement prod sans la phrase de confirmation, déploiement prod depuis une branche autre que `dev`, modification de code dans cette commande.
