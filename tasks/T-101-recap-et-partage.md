---
id: T-101
title: Récap mensuel et annuel RC-01 à RC-09 et partage
status: todo
phase: 10 Analyses et récap
depends_on: [T-100]
manual: false
estimate: L
model: opus
done_at:
---

# T-101 · Récap mensuel et annuel RC-01 à RC-09 et partage

## Objectif

Le récap de 7 cartes est disponible le 1er du mois (et le 1er janvier pour l'année), accessible depuis la bannière et le mois, et se partage en PNG 1080 × 1920 avec montants masqués par défaut.

## Contexte

- brief F-14, P-03
- docs/design-tokens.md (RC-01 à RC-09, StoryCard, HO-05)
- `.claude/rules/` applicables et `CLAUDE.md`.

## Étapes

1. `lib/domain/logic/recap_builder.dart` : 7 cartes (intro, misé, net + équivalent, taux réel vs nécessaire, ce qui a pesé le plus (I-01 ou I-03), budget, contexte), variante annuelle, disponibilité (mois précédent avec ≥ 1 pari ; année).
2. `RecapViewModel` : navigation tap gauche/droite, barre de progression, `toggleAmounts`, `share` : rendu hors écran d'un widget 1080 × 1920 (`RepaintBoundary`, `toImage`), logo 48 pt, nom, phrase du pays, pourcentages par défaut, montants si activés, puis `ShareRepository.shareImage`.
3. Écrans RC-01 à RC-07 (fond brand-800, texte blanc, fondu si mouvement réduit), RC-08 (aperçu, interrupteur, Partager), RC-09 ; bannière HO-05 du 1er au 7 ; N-03 branchée.
4. Analytics `recap_viewed`, `recap_shared(amounts_visible)`.

## Tests

| Test (comportement vérifié) | Fichier | Commande |
|---|---|---|
| RecapBuilder : disponibilité, contenu des 7 cartes sur septembre (242 €, −118 €, 35 % vs 45 %, 121 %), aucune carte de célébration pour un mois positif | `test/domain/logic/recap_builder_test.dart` | `flutter test test/domain/logic/recap_builder_test.dart` |

## Sécurité

- [ ] Aucun secret ni valeur réelle dans le diff
- [ ] Aucune dépendance hors de la liste de docs/architecture.md section 10
- [ ] Montants masqués par défaut dans l'image partagée

## Definition of Done

- [ ] Étapes réalisées
- [ ] Tests du tableau écrits et verts, aucun test superflu
- [ ] Checklist sécurité cochée (ou n/a)
- [ ] `make check` vert (plus `make test-db` et `make test-functions` si `supabase/` est touché)
- [ ] Revue `code-reviewer` : OK ou OK avec réserves consignées
- [ ] Statut `done` avec date dans ce fichier et dans `tasks/INDEX.md`
- [ ] Commit unique `feat(T-101): Récap mensuel et annuel RC-01 à RC-09 et partage` sur `dev`, sans push (ou rien à committer pour une tâche purement manuelle)

## Notes de revue
