---
id: T-143
title: Fiches stores par script, déclarations de confidentialité et soumission
status: todo
phase: 14 Mise en production
depends_on: [T-142, T-136, T-140]
manual: true
estimate: M
model: opus
done_at:
---

# T-143 · Fiches stores par script, déclarations de confidentialité et soumission

## Objectif

Les fiches App Store et Google Play (textes dans toutes les langues, captures, classification 18+, URL de confidentialité et de support) sont poussées par `scripts/ops/store-metadata.sh`, les builds envoyés par `store-upload.sh`, la soumission faite par `scripts/ops/store-submit.sh` après la phrase de confirmation ; seules les déclarations de confidentialité et le questionnaire de contenu Play restent à cocher dans les consoles.

## Contexte

- docs/manual-setup.md, T-143
- brief 5.3, 11.4, 15
- .claude/skills/ops/SKILL.md
- `.claude/rules/` applicables et `CLAUDE.md`.

## Étape manuelle

**Actions**
1. Dans App Store Connect : remplir App Privacy ; dans Play Console : questionnaire de contenu, public cible 18+, formulaire Data safety (puis l'exporter en CSV dans ops/store-metadata/play/data-safety.csv) ; voir docs/manual-setup.md, T-143

- [ ] Confirmé par Rayan (date : )

**Vérifications automatisables**
- ops/store-metadata/play/data-safety.csv existe

## Étapes

1. Générer les captures ST-01 à ST-06 par `integration_test/screenshots_test.dart` sur simulateur iPhone 6,9 pouces et émulateur Pixel (FR et EN-US au minimum, puis les autres langues) dans `ops/store-metadata/<store>/<locale>/screenshots/`.
2. Rédiger `ops/store-metadata/` (format `fastlane deliver` et `supply` : nom, sous-titre, description, mots-clés, notes de version, URL confidentialité et support vers le site de T-140, note App Review Information du brief 11.4) dans les 7 langues App Store et 8 langues Play.
3. Vérifier `help_resources` et `bookmakers` (dates `verified_at` de la semaine), mettre à jour le seed si nécessaire, `/deploy prod`.
4. `scripts/ops/store-metadata.sh` : `fastlane deliver --api_key_path ... --skip_binary_upload --skip_app_version_update false` + `PATCH /v1/ageRatingDeclarations` (18+ volontaire, jeux d'argent simulés : non) ; `fastlane supply --skip_upload_aab --metadata_path ops/store-metadata/play` ; `POST .../dataSafety` avec `ops/store-metadata/play/data-safety.csv` exporté depuis la console une fois rempli.
5. `scripts/ops/store-upload.sh ios appstore` et `android production --rollout 0.2` (envoi sans publication), puis `scripts/ops/store-submit.sh` qui exige la phrase `oui, soumets X.Y.Z` et crée la Review Submission App Store et valide l'edit Play en `completed` ; `docs/manual-setup.md` section Résidu manuel pour App Privacy et le questionnaire de contenu, à faire avant la soumission.
6. Après soumission : marquer la V1 livrée dans README.md (version et date), commit.

## Tests

Aucun test exigé par la politique pour cette tâche (configuration, action manuelle ou relais sans logique). Un test ajouté ici serait superflu.

## Sécurité

- [ ] Aucun secret ni valeur réelle dans le diff
- [ ] Aucune dépendance hors de la liste de docs/architecture.md section 10
- [ ] Déclarations App Privacy et Data safety cohérentes avec docs/architecture.md section 13
- [ ] La soumission n'a lieu qu'après la phrase de confirmation

## Definition of Done

- [ ] Étapes réalisées
- [ ] Tests du tableau écrits et verts, aucun test superflu
- [ ] Checklist sécurité cochée (ou n/a)
- [ ] `make check` vert (plus `make test-db` et `make test-functions` si `supabase/` est touché)
- [ ] Revue `code-reviewer` : OK ou OK avec réserves consignées
- [ ] Statut `done` avec date dans ce fichier et dans `tasks/INDEX.md`
- [ ] Commit unique `chore(T-143): Fiches stores par script, déclarations de confidentialité et soumission` sur `dev`, sans push (ou rien à committer pour une tâche purement manuelle)

## Notes de revue
