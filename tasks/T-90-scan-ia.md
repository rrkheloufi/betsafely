---
id: T-90
title: Scan IA du ticket (SC-02 à SC-06)
status: todo
phase: 9 Scan
depends_on: [T-62, T-24, T-40]
manual: false
estimate: L
model: opus
done_at:
---

# T-90 · Scan IA du ticket (SC-02 à SC-06)

## Objectif

Depuis AD-01, l'utilisateur photographie ou importe un ticket, voit le traitement, vérifie un ou plusieurs brouillons avec les champs à confirmer surlignés, et enregistre ; le compteur de scans est visible et le quota épuisé ouvre le paywall.

## Contexte

- brief F-04, F-22
- docs/design-tokens.md (SC-02 à SC-06, ToConfirmField)
- cadrage décisions 7, 43
- `.claude/rules/` applicables et `CLAUDE.md`.

## Étapes

1. `ImagePickerService` (`image_picker`, `maxWidth/maxHeight 1600`, `imageQuality 80`, caméra et galerie) ; `ScanRepositoryImpl` : `quota()` via RPC `scan_quota`, `scan(jpeg)` via `functions.invoke('scan-ticket')` avec délai 20 s, erreurs typées (`unreadable`, `noTicket`, `offline`, `timeout`, `quotaExceeded`).
2. `ScanViewModel` : quota affiché (« 2 scans offerts restants », « 12 / 150 ce mois-ci »), `pickImage(source)`, `scan`, brouillons (`BetDraft` avec `confidence`, champs < 0,7 marqués), sélection multiple (jusqu'à 10), `saveDrafts` via `record_bet` (source `scan`, `scan_confidence`, `placed_at` lu sur le ticket), devise du ticket ignorée.
3. Écrans SC-02 (miniature 40 %, Skeleton, mention de suppression), SC-03 (formulaire AD-02 prérempli avec `ToConfirmField`), SC-04 (liste cochable, « Enregistrer les N paris »), SC-05 (3 erreurs avec Réessayer et Saisir à la main), SC-06 (paywall `scan_quota`) ; AD-01 affiche le compteur réel.
4. Analytics `scan_failed(reason)`, `bet_created(scan)`.

## Tests

| Test (comportement vérifié) | Fichier | Commande |
|---|---|---|
| ScanViewModel : états chargement, succès multi-brouillons, erreurs typées, quota épuisé ouvre le paywall (fakes) | `test/ui/scan/view_models/scan_view_model_test.dart` | `flutter test test/ui/scan/view_models/scan_view_model_test.dart` |

## Sécurité

- [ ] Aucun secret ni valeur réelle dans le diff
- [ ] Aucune dépendance hors de la liste de docs/architecture.md section 10
- [ ] Image jamais écrite sur disque au-delà du cache du picker, supprimée après envoi
- [ ] Texte de permission caméra conforme à docs/architecture.md section 13

## Definition of Done

- [ ] Étapes réalisées
- [ ] Tests du tableau écrits et verts, aucun test superflu
- [ ] Checklist sécurité cochée (ou n/a)
- [ ] `make check` vert (plus `make test-db` et `make test-functions` si `supabase/` est touché)
- [ ] Revue `code-reviewer` : OK ou OK avec réserves consignées
- [ ] Statut `done` avec date dans ce fichier et dans `tasks/INDEX.md`
- [ ] Commit unique `feat(T-90): Scan IA du ticket (SC-02 à SC-06)` sur `dev`, sans push (ou rien à committer pour une tâche purement manuelle)

## Notes de revue
