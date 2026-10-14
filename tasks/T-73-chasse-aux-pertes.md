---
id: T-73
title: Détecteur de chasse aux pertes (AL-03)
status: todo
phase: 7 Budget, alertes et pause
depends_on: [T-72]
manual: false
estimate: M
model: opus
done_at:
---

# T-73 · Détecteur de chasse aux pertes (AL-03)

## Objectif

À chaque pari enregistré, D1, D2 et D3 sont évalués sur les 30 derniers jours (médiane, au moins 5 paris), au plus une alerte par 12 h, chaque signal consigné et compté.

## Contexte

- brief F-09
- docs/design-tokens.md (AL-03)
- `.claude/rules/` applicables et `CLAUDE.md`.

## Étapes

1. `lib/domain/logic/chase_detector.dart` : médiane des mises réelles sur 30 jours, D1 (perte < 3 h et mise ≥ 2 M), D2 (≥ 3 paris en 2 h après une perte, total ≥ 3 M), D3 (≥ 2 pertes consécutives, mise ≥ somme des 2 dernières mises perdues), message chiffré (montant, délai, multiple).
2. `AlertLogRepositoryImpl` ; garde-fou 12 h via `lastOfKind`.
3. `record_bet` : évaluation après écriture, Premium seulement ; AL-03 (AlertModal) avec Voir mes paris du jour (`/bets?filter=all&day=today`), Pause de 24 h, Continuer, Besoin d'aide.
4. Compteur « N signaux ce mois-ci » exposé pour T-100.

## Tests

| Test (comportement vérifié) | Fichier | Commande |
|---|---|---|
| D1, D2, D3 sur des séquences construites ; pas de détection sous 5 paris ; une alerte par 12 h | `test/domain/logic/chase_detector_test.dart` | `flutter test test/domain/logic/chase_detector_test.dart` |

## Sécurité

- [ ] Aucun secret ni valeur réelle dans le diff
- [ ] Aucune dépendance hors de la liste de docs/architecture.md section 10
- [ ] Premium vérifié par entitlement

## Definition of Done

- [ ] Étapes réalisées
- [ ] Tests du tableau écrits et verts, aucun test superflu
- [ ] Checklist sécurité cochée (ou n/a)
- [ ] `make check` vert (plus `make test-db` et `make test-functions` si `supabase/` est touché)
- [ ] Revue `code-reviewer` : OK ou OK avec réserves consignées
- [ ] Statut `done` avec date dans ce fichier et dans `tasks/INDEX.md`
- [ ] Commit unique `feat(T-73): Détecteur de chasse aux pertes (AL-03)` sur `dev`, sans push (ou rien à committer pour une tâche purement manuelle)

## Notes de revue
