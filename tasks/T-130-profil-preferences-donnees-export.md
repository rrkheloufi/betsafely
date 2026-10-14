---
id: T-130
title: Profil PR-01, préférences, À propos, effacement et export
status: todo
phase: 13 Profil et finitions
depends_on: [T-111, T-121, T-43]
manual: false
estimate: L
model: opus
done_at:
---

# T-130 · Profil PR-01, préférences, À propos, effacement et export

## Objectif

Le profil regroupe toutes les sections de F-20, les préférences se modifient (langue, pays, devise, format, bookmakers et sports favoris), l'effacement local demande une double confirmation, et l'export CSV et PDF fonctionne pour les abonnés.

## Contexte

- brief F-18, F-20
- docs/design-tokens.md (PR-01)
- cadrage décision 17
- `.claude/rules/` applicables et `CLAUDE.md`.

## Étapes

1. `ProfileViewModel`, `PreferencesViewModel` (écrans `/profile/preferences/:item` : langue, pays avec avertissement sur bookmakers et aide, devise sans avertissement, format de cote, bookmakers favoris ordre/masquer/ajouter, sports favoris), À propos (version via `package_info_plus`, Conditions, Confidentialité, Contact, Noter via `in_app_review`).
2. `DataViewModel` : `wipeLocal` (double confirmation), `exportCsv` (bets.csv avec tous les champs, selections.csv), `exportMonthPdf(month)` (récapitulatif d'un mois avec le package `pdf`), partage par `share_plus` ; verrouillé pour les gratuits (paywall `export`).
3. `ExportRepositoryImpl`, `ShareRepositoryImpl`, `ExportFileService`.

## Tests

| Test (comportement vérifié) | Fichier | Commande |
|---|---|---|
| exportCsv produit un fichier par pari avec toutes les colonnes et un second pour les sélections | `test/data/repositories/export/export_repository_test.dart` | `flutter test test/data/repositories/export/export_repository_test.dart` |

## Sécurité

- [ ] Aucun secret ni valeur réelle dans le diff
- [ ] Aucune dépendance hors de la liste de docs/architecture.md section 10
- [ ] Export réservé à l'entitlement
- [ ] Fichiers d'export dans le cache temporaire, supprimés après partage

## Definition of Done

- [ ] Étapes réalisées
- [ ] Tests du tableau écrits et verts, aucun test superflu
- [ ] Checklist sécurité cochée (ou n/a)
- [ ] `make check` vert (plus `make test-db` et `make test-functions` si `supabase/` est touché)
- [ ] Revue `code-reviewer` : OK ou OK avec réserves consignées
- [ ] Statut `done` avec date dans ce fichier et dans `tasks/INDEX.md`
- [ ] Commit unique `feat(T-130): Profil PR-01, préférences, À propos, effacement et export` sur `dev`, sans push (ou rien à committer pour une tâche purement manuelle)

## Notes de revue
