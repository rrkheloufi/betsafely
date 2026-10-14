---
id: T-139
title: Test d'intégration du parcours critique
status: todo
phase: 13 Profil et finitions
depends_on: [T-138, T-111]
manual: false
estimate: M
model: opus
done_at:
---

# T-139 · Test d'intégration du parcours critique

## Objectif

`integration_test/critical_path_test.dart` parcourt onboarding (âge, réglages, bilan passé, budget 200 €, notifications refusées, paywall fermé), saisie d'un pari simple, règlement Gagné, vérification de l'accueil (net, jauge), sur le flavor dev avec des fakes réseau.

## Contexte

- .claude/rules/tests.md (intégration)
- Makefile (test-integration)
- `.claude/rules/` applicables et `CLAUDE.md`.

## Étapes

1. Point d'entrée de test qui injecte des fakes pour Supabase, RevenueCat et notifications (`dependencies.dart` accepte des surcharges).
2. Scénario unique, assertions sur le comportement (textes l10n), pas de capture d'écran.
3. `make test-integration` documenté (émulateur ou appareil requis).

## Tests

| Test (comportement vérifié) | Fichier | Commande |
|---|---|---|
| Parcours critique complet | `integration_test/critical_path_test.dart` | `make test-integration` |

## Sécurité

- [ ] Aucun secret ni valeur réelle dans le diff
- [ ] Aucune dépendance hors de la liste de docs/architecture.md section 10

## Definition of Done

- [ ] Étapes réalisées
- [ ] Tests du tableau écrits et verts, aucun test superflu
- [ ] Checklist sécurité cochée (ou n/a)
- [ ] `make check` vert (plus `make test-db` et `make test-functions` si `supabase/` est touché)
- [ ] Revue `code-reviewer` : OK ou OK avec réserves consignées
- [ ] Statut `done` avec date dans ce fichier et dans `tasks/INDEX.md`
- [ ] Commit unique `feat(T-139): Test d'intégration du parcours critique` sur `dev`, sans push (ou rien à committer pour une tâche purement manuelle)

## Notes de revue
