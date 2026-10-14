---
paths:
  - lib/ui/**
---

# Règles UI

- **Tokens :** toute couleur vient de `BsColors` (`Theme.of(context).extension<BsColors>()`), toute typographie de `BsTypography`, tout espacement de `BsSpacing`, tout rayon de `BsRadius`. Aucun `Color(0x...)` ni `Colors.*` hors `lib/ui/core/theme/`. Mode clair seul en V1 (`ThemeMode.light`).
- **Textes :** toute chaîne affichée passe par `context.l10n.<cle>` (ARB `fr` source, `en` miroir). Aucun `Text('...')` avec un littéral, aucune concaténation de phrases, pluriels en ICU. `scripts/check-strings.sh` le vérifie.
- **Chiffres :** montants, cotes et pourcentages via `lib/ui/core/formatters/` (locale, devise symbole, chiffres tabulaires `FontFeature.tabularFigures()`). Le signe est toujours explicite : « − » (U+2212) en `negative`, « + » en `textPrimary`. Jamais de vert pour un gain.
- **États :** chaque écran gère vide (`EmptyState`), chargement (`Skeleton`, jamais un indicateur seul plein écran), erreur (`Banner` ou message sous le champ) et hors ligne (`Banner` neutre). Un écran sans état vide ou chargement n'est pas terminé.
- **Accessibilité :** `Semantics` avec libellé sur toute icône seule ; cibles tactiles d'au moins 48 dp (zone étendue si le visuel est plus petit, par exemple `ChoiceChip` et boutons de `ToSettleRow`) ; `MediaQuery.textScalerOf` respecté jusqu'à 200 % sans troncature d'un chiffre ; `MediaQuery.disableAnimationsOf` ou `reduceMotion` : fondu à la place des glissements ; aucune information portée par la couleur seule.
- **Widgets :** `const` dès que possible ; aucune logique métier, aucun calcul C-xx, aucune requête dans un widget ; un widget lit son ViewModel via `context.watch` ou `ListenableBuilder` et appelle ses `Command`.
- **Composants :** utiliser les 35 composants de `lib/ui/core/widgets/` (noms de `docs/design-tokens.md`) avant d'en créer un nouveau.
- **Icônes :** `phosphor_flutter`, style regular, 24 ; fill réservé à l'onglet actif. Jamais Trophy ; CircleDashed pour « Autre ».
- **Mouvement :** 200 à 250 ms, `Curves.easeOut`, aucun rebond ni confetti. Retour haptique léger à l'enregistrement et au règlement, jamais sur un gain.
- **Dispose :** tout `TextEditingController`, `FocusNode`, `ScrollController`, `AnimationController` est disposé.
