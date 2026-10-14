---
id: T-05
title: Routeur go_router et shell à onglets
status: todo
phase: 0 Socle
depends_on: [T-04]
manual: false
estimate: M
model: opus
done_at:
---

# T-05 · Routeur go_router et shell à onglets

## Objectif

Toutes les routes de l'architecture existent avec des écrans vides nommés, le shell à 4 onglets et le bouton central fonctionnent, les gardes sont des fonctions prêtes à recevoir leur logique.

## Contexte

- docs/architecture.md section 1 (carte de navigation)
- docs/design-tokens.md section 2 (TabBar, AddButton)
- `.claude/rules/` applicables et `CLAUDE.md`.

## Étapes

1. `lib/routing/routes.dart` : constantes de chemins et noms.
2. `lib/routing/router.dart` : `GoRouter` avec `StatefulShellRoute.indexedStack` (home, bets, analytics, profile), routes modales plein écran (`parentNavigatorKey` racine) pour saisie, scan, récap, compte, et les autres routes de la carte.
3. `lib/routing/guards.dart` : `redirect` global dans l'ordre : mise à jour obligatoire, âge refusé, onboarding inachevé, puis garde de route (entitlement, compte). Chaque garde lit un `Listenable` fourni par un repository ; pour l'instant des valeurs par défaut.
4. Écrans vides `<feature>_screen.dart` avec un `Scaffold` et un titre l10n.
5. Bouton central : ouvre une `BottomSheet` AD-01 vide (contenu en T-62).

## Tests

| Test (comportement vérifié) | Fichier | Commande |
|---|---|---|
| Le redirect envoie vers /onboarding/welcome quand l'onboarding n'est pas terminé et vers /blocked si l'âge est refusé | `test/routing/guards_test.dart` | `flutter test test/routing/guards_test.dart` |

## Sécurité

- [ ] Aucun secret ni valeur réelle dans le diff
- [ ] Aucune dépendance hors de la liste de docs/architecture.md section 10
- [ ] Les paramètres de route sont validés (uuid, AAAA-MM) avant usage

## Definition of Done

- [ ] Étapes réalisées
- [ ] Tests du tableau écrits et verts, aucun test superflu
- [ ] Checklist sécurité cochée (ou n/a)
- [ ] `make check` vert (plus `make test-db` et `make test-functions` si `supabase/` est touché)
- [ ] Revue `code-reviewer` : OK ou OK avec réserves consignées
- [ ] Statut `done` avec date dans ce fichier et dans `tasks/INDEX.md`
- [ ] Commit unique `feat(T-05): Routeur go_router et shell à onglets` sur `dev`, sans push (ou rien à committer pour une tâche purement manuelle)

## Notes de revue
