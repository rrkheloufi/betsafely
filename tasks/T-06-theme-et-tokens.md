---
id: T-06
title: Thème, tokens et composants de base
status: todo
phase: 0 Socle
depends_on: [T-05]
manual: false
estimate: L
model: opus
done_at:
---

# T-06 · Thème, tokens et composants de base

## Objectif

Le thème clair applique tous les tokens de docs/design-tokens.md et les composants de base existent dans `lib/ui/core/widgets/` avec un aperçu dans une galerie de dev.

## Contexte

- docs/design-tokens.md sections 1 et 2
- .claude/rules/ui.md
- `.claude/rules/` applicables et `CLAUDE.md`.

## Étapes

1. `lib/ui/core/theme/` : `bs_colors.dart` (ThemeExtension avec tous les tokens, valeurs claires ; valeurs sombres définies mais non branchées), `bs_typography.dart` (Inter embarquée dans `assets/fonts/`, styles display à overline, `tabularFigures`), `bs_spacing.dart`, `bs_radius.dart`, `bs_motion.dart`, `theme.dart` (`ThemeData` clair, `ThemeMode.light`).
2. Composants : PrimaryButton, SecondaryButton, TextButton (BsTextButton), DestructiveButton, IconButton (BsIconButton 48 dp), TopBar, SectionHeader, DayHeader, SegmentedControl, ChoiceChip (zone tactile 48), TextField, PickerField, MoneyField, OddsField, BottomSheet, AlertModal, Banner (4 variantes), Toast, EmptyState, Skeleton, ListRow, StatusChip, ProgressDots. Les composants de données (NetAmountCard, StatTile, BudgetGauge, InsightCard, BetRow, ToSettleRow, PauseCard, PlanCard, StoryCard, LockedOverlay, ScanFrame non utilisé) sont créés par leurs features.
3. Icônes via `phosphor_flutter` ; mapping sport → icône dans `lib/ui/core/icons/sport_icons.dart`.
4. Galerie `lib/ui/core/gallery/gallery_screen.dart` accessible uniquement en flavor dev (route `/dev/gallery`).
5. Tous les textes de la galerie via l10n.

## Tests

| Test (comportement vérifié) | Fichier | Commande |
|---|---|---|
| MoneyField refuse une valeur négative et accepte 0 ; OddsField signale une cote < 1,01 | `test/ui/core/widgets/fields_test.dart` | `flutter test test/ui/core/widgets/fields_test.dart` |

## Sécurité

- [ ] Aucun secret ni valeur réelle dans le diff
- [ ] Aucune dépendance hors de la liste de docs/architecture.md section 10
- [ ] Aucune couleur en dur hors lib/ui/core/theme/ (check-no-hex)

## Definition of Done

- [ ] Étapes réalisées
- [ ] Tests du tableau écrits et verts, aucun test superflu
- [ ] Checklist sécurité cochée (ou n/a)
- [ ] `make check` vert (plus `make test-db` et `make test-functions` si `supabase/` est touché)
- [ ] Revue `code-reviewer` : OK ou OK avec réserves consignées
- [ ] Statut `done` avec date dans ce fichier et dans `tasks/INDEX.md`
- [ ] Commit unique `feat(T-06): Thème, tokens et composants de base` sur `dev`, sans push (ou rien à committer pour une tâche purement manuelle)

## Notes de revue
