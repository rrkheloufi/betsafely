---
id: T-134
title: Accessibilité, états vides et erreurs, texte à 200 %, mouvement réduit
status: todo
phase: 13 Profil et finitions
depends_on: [T-130, T-131, T-101, T-90]
manual: false
estimate: M
model: opus
done_at:
---

# T-134 · Accessibilité, états vides et erreurs, texte à 200 %, mouvement réduit

## Objectif

Tous les écrans passent une revue d'accessibilité (libellés, cibles 48 dp, contraste, texte à 200 % sans troncature, mouvement réduit), chaque écran a ses états vide, chargement, erreur et hors ligne.

## Contexte

- brief 15 (accessibilité)
- docs/design-tokens.md sections 3, 4 et 7
- .claude/rules/ui.md
- `.claude/rules/` applicables et `CLAUDE.md`.

## Étapes

1. Parcours écran par écran avec la liste de docs/design-tokens.md ; corrections ; variantes 200 % de HO-01 et AD-02 (tuiles empilées).
2. Bannière hors ligne globale (`connectivity` via `SupabaseService` ou `InternetAddress.lookup`, sans package supplémentaire sauf justification).
3. Libellé du chiffre principal annoncé avec son signe (« Résultat net, moins 64 euros 50 »).

## Tests

| Test (comportement vérifié) | Fichier | Commande |
|---|---|---|
| Les montants signés exposent un libellé sémantique lisible (widget sur NetAmountCard) | `test/ui/home/widgets/net_amount_card_test.dart` | `flutter test test/ui/home/widgets/net_amount_card_test.dart` |

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
- [ ] Commit unique `feat(T-134): Accessibilité, états vides et erreurs, texte à 200 %, mouvement réduit` sur `dev`, sans push (ou rien à committer pour une tâche purement manuelle)

## Notes de revue
