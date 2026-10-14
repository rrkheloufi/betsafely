---
id: T-07
title: Localisation FR et EN et formatters
status: todo
phase: 0 Socle
depends_on: [T-06]
manual: false
estimate: M
model: opus
done_at:
---

# T-07 · Localisation FR et EN et formatters

## Objectif

Tous les textes des écrans ON, HO, BE, AD, SC, BU, AL, PA, AN, RC, AC, PR, HE, LK, WI, NO existent en FR (source) et EN dans les ARB, et les formatters de montants, cotes, dates et pourcentages sont testés.

## Contexte

- brief sections 5, 12 et textes des écrans dans docs/design-tokens.md
- docs/architecture.md section 0 (devises visuelles)
- `.claude/rules/` applicables et `CLAUDE.md`.

## Étapes

1. ARB : clés nommées `<ecran>_<element>` (`home_netResultLabel`), descriptions `@` pour chaque clé, pluriels ICU, placeholders typés. Source FR complète d'après les maquettes ; EN-US d'après le lot 9 (Sportsbook, Straight, Parlay, Win rate...).
2. `lib/ui/core/formatters/` : `MoneyFormatter` (unités mineures → chaîne locale avec symbole de la devise de l'utilisateur, signe explicite U+2212 et +), `OddsFormatter` (décimal 2 décimales, américain entier, conversions via BetMath en T-60 ; pour l'instant affichage seul), `PercentFormatter`, `DateFormatter` (jour, mois, heure selon locale, `intl`).
3. Extension `context.l10n`.
4. Langue : celle du système si supportée, sinon `en` ; surcharge par préférence (branchée en T-31).

## Tests

| Test (comportement vérifié) | Fichier | Commande |
|---|---|---|
| MoneyFormatter : 1552,40 € en fr, $1,552.40 en en-US, signe moins U+2212 et plus explicite, zéro sans signe | `test/ui/core/formatters/money_formatter_test.dart` | `flutter test test/ui/core/formatters/money_formatter_test.dart` |

## Sécurité

- [ ] Aucun secret ni valeur réelle dans le diff
- [ ] Aucune dépendance hors de la liste de docs/architecture.md section 10
- [ ] check-strings vert

## Definition of Done

- [ ] Étapes réalisées
- [ ] Tests du tableau écrits et verts, aucun test superflu
- [ ] Checklist sécurité cochée (ou n/a)
- [ ] `make check` vert (plus `make test-db` et `make test-functions` si `supabase/` est touché)
- [ ] Revue `code-reviewer` : OK ou OK avec réserves consignées
- [ ] Statut `done` avec date dans ce fichier et dans `tasks/INDEX.md`
- [ ] Commit unique `feat(T-07): Localisation FR et EN et formatters` sur `dev`, sans push (ou rien à committer pour une tâche purement manuelle)

## Notes de revue
