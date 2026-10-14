---
id: T-23
title: Fonctions de quota de scan
status: todo
phase: 2 Backend
depends_on: [T-22]
manual: false
estimate: M
model: fable
done_at:
---

# T-23 · Fonctions de quota de scan

## Objectif

`reserve_scan`, `refund_scan` et `scan_quota` existent, atomiques, testées, et `scan_quota` est appelable par l'utilisateur.

## Contexte

- docs/database.md section 1 (fonctions de quota)
- brief F-04
- `.claude/rules/` applicables et `CLAUDE.md`.
- Tâche marquée `model: fable` : une erreur y est coûteuse ou silencieuse ; Fable 5.1 conseillé.

## Étapes

1. `supabase migration new 0004_scan_quota` avec les trois fonctions de docs/database.md, revoke sur reserve et refund.
2. Tests : réservation gratuite 3 fois puis refus ; réservation premium 150 puis refus ; remise à zéro au changement de mois UTC ; remboursement ne descend pas sous 0 ; `scan_quota()` renvoie premium et remaining cohérents ; `reserve_scan` non exécutable par authenticated.

## Tests

| Test (comportement vérifié) | Fichier | Commande |
|---|---|---|
| Quota gratuit, premium, remise à zéro mensuelle, remboursement, droits d'exécution | `supabase/tests/scan_quota_test.sql` | `make test-db` |

## Sécurité

- [ ] Aucun secret ni valeur réelle dans le diff
- [ ] Aucune dépendance hors de la liste de docs/architecture.md section 10
- [ ] reserve_scan et refund_scan révoquées pour anon et authenticated

## Definition of Done

- [ ] Étapes réalisées
- [ ] Tests du tableau écrits et verts, aucun test superflu
- [ ] Checklist sécurité cochée (ou n/a)
- [ ] `make check` vert (plus `make test-db` et `make test-functions` si `supabase/` est touché)
- [ ] Revue `code-reviewer` : OK ou OK avec réserves consignées
- [ ] Statut `done` avec date dans ce fichier et dans `tasks/INDEX.md`
- [ ] Commit unique `feat(T-23): Fonctions de quota de scan` sur `dev`, sans push (ou rien à committer pour une tâche purement manuelle)

## Notes de revue
