# Design tokens BetSafely

Extraits de la spécification de design V1 (14 octobre 2026) et du design system validé dans Claude Design. L'app n'utilise jamais une couleur, une taille ni un espacement en dur : tout passe par `lib/ui/core/theme/` (`BsColors`, `BsTypography`, `BsSpacing`, `BsRadius`, `BsMotion`). **V1 en mode clair uniquement** : les valeurs sombres sont conservées ici pour une version ultérieure et ne sont pas branchées.

Ressenti : application bancaire moderne, calme et précise. Sobre, clair, rassurant. Interdits : codes visuels des bookmakers (vert fluo, noir et or, néons, dégradés, urgence), imagerie d'argent, de trophées, de stades, de logos, célébration d'un gain, rouge et vert façon trading.

## 1. Tokens

Les couleurs sont dérivées du logo. Les valeurs ci-dessous font foi : elles ont été ajustées pour respecter les contrastes WCAG AA. Si l'extraction automatique de Claude Design propose d'autres valeurs, garder celles-ci.

### 2.1 Couleurs de marque

| Token | Valeur | Origine et usage |
|---|---|---|
| `brand-900` | #163A28 | Texte sur fond vert clair, fond des cartes du récap en mode sombre |
| `brand-800` | #1F4A34 | Fond des cartes du récap, en-têtes forts |
| `brand-700` | #285A3F | Vert du portefeuille du logo. Titres de marque |
| `brand-600` | #2E7048 | **Couleur d'action principale en mode clair** (boutons, liens, onglet actif). Contraste sur blanc 5,9:1 |
| `brand-500` | #3F8F55 | Vert des billets du logo. Jauge de budget sous 80 %, éléments graphiques |
| `brand-400` | #5FAA6C | **Couleur d'action principale en mode sombre** |
| `brand-300` | #7ABF7B | Vert clair du logo. Illustrations, états sélectionnés en mode sombre |
| `brand-200` | #B4DDB5 | Bordures d'éléments sélectionnés |
| `brand-100` | #DDF0DE | Fonds d'états sélectionnés, puces actives |
| `brand-50` | #F1F8F1 | Fonds très légers, bannières d'information |
| `teal-700` | #2F8077 | Bas du fond du logo. Valeurs positives dans les graphiques uniquement |
| `teal-300` | #86C5AC | Haut du fond du logo. Décor discret, illustrations |
| `teal-100` | #DCEFE7 | Fond de la carte Pause |

### 2.2 Neutres (gris légèrement teintés de vert)

| Token | Clair | Sombre | Usage |
|---|---|---|---|
| `bg` | #F7F9F8 | #0B110E | Fond de l'application |
| `surface` | #FFFFFF | #131B17 | Cartes, feuilles |
| `surface-2` | #EFF3F1 | #1A241F | Champs, segments, zones secondaires |
| `border` | #E2E8E5 | #26322C | Bordures de 1 px |
| `border-strong` | #C9D2CE | #3A4842 | Bordures de champs actifs, séparateurs forts |
| `text-primary` | #141C18 | #EEF3F0 | Texte principal, chiffres |
| `text-secondary` | #5F6B66 | #A3B0AA | Libellés, métadonnées (contraste 5,2:1 sur `bg`) |
| `text-tertiary` | #8A9691 | #6F7C76 | Placeholders, textes désactivés (jamais pour une information utile) |
| `on-primary` | #FFFFFF | #0B110E | Texte sur bouton principal |

### 2.3 Couleurs sémantiques

| Token | Clair | Sombre | Usage |
|---|---|---|---|
| `negative` | #B42318 | #F97066 | Résultat net négatif, budget dépassé, perdu |
| `negative-bg` | #FEF3F2 | #3A1714 | Fond d'alerte budget atteint |
| `warning` | #B54708 | #FDB022 | Texte d'avertissement, jauge de 80 à 99 %, champs à confirmer du scan |
| `warning-fill` | #F79009 | #FDB022 | Remplissage de la jauge de 80 à 99 % |
| `warning-bg` | #FFFAEB | #3A2A0A | Fond des bannières de palier, champs à confirmer |
| `neutral-result` | = `text-primary` | = `text-primary` | **Résultat net positif** : même couleur que le texte, avec le signe « + ». Jamais en vert (P-03) |
| `positive-chart` | #2F8077 | #6CC3B2 | Barres positives des graphiques uniquement |

**Règles :**
- Le négatif est porté par la couleur `negative` **et** le signe « − » (vrai signe moins, U+2212). Jamais par la couleur seule.
- Le positif est porté par le signe « + » et la couleur `text-primary`.
- La jauge de budget prend la couleur `brand-500` sous 80 %, `warning-fill` de 80 à 99 %, puis `negative` à 100 % et au-delà.

### 2.4 Typographie

- **Police :** Inter (Google Fonts), qui couvre les accents des 6 langues.
- **Chiffres :** tous les montants, cotes et pourcentages utilisent les chiffres tabulaires (`font-feature-settings: "tnum"`).

| Style | Taille / interligne | Graisse | Usage |
|---|---|---|---|
| `display` | 40 / 44 | 700 | Chiffre principal d'un écran (résultat net, bilan) |
| `title-1` | 28 / 34 | 600 | Titres d'écran d'onboarding, cartes du récap |
| `title-2` | 22 / 28 | 600 | Titres d'écran |
| `title-3` | 18 / 24 | 600 | Titres de carte et de section |
| `body` | 16 / 24 | 400 | Texte courant |
| `body-strong` | 16 / 24 | 600 | Valeurs dans les listes, boutons |
| `callout` | 15 / 20 | 400 | Descriptions secondaires |
| `caption` | 13 / 18 | 400 | Métadonnées, mentions légales |
| `overline` | 12 / 16 | 500, interlettrage 0,4 | Libellés au-dessus des chiffres |

Taille minimale de texte : 13. Tous les écrans doivent supporter l'agrandissement du texte jusqu'à 200 % : le contenu passe à la ligne, aucune troncature d'un chiffre.

### 2.5 Espacements, rayons, élévation

- **Grille de base 4 :** 4, 8, 12, 16, 20, 24, 32, 40, 48.
- **Marges :** 20 sur les côtés de l'écran ; 24 entre deux cartes ; 16 à l'intérieur d'une carte.
- **Rayons :**

| Élément | Rayon |
|---|---|
| Puces | 8 |
| Champs et boutons | 12 |
| Cartes | 16 |
| Feuilles et fenêtres | 24 |
| Pilules | Arrondi complet |

- **Élévation :**
  - les cartes n'ont pas d'ombre, mais une bordure `border` de 1 px ;
  - les feuilles du bas ont une ombre douce (y 8, flou 24, noir à 12 %) ;
  - le bouton d'ajout central a une ombre légère (y 4, flou 12, `brand-700` à 25 %).

### 2.6 Iconographie

- **Jeu d'icônes :** Phosphor Icons, style Regular, 24 px. Le style Fill est réservé à l'onglet actif.
- **Icônes de sport :**

| Sport | Icône Phosphor |
|---|---|
| Football | SoccerBall |
| Basket | Basketball |
| Tennis | TennisBall |
| Football américain | Football |
| Baseball | Baseball |
| Volley-ball | Volleyball |
| Boxe, MMA | BoxingGlove |
| Cyclisme | Bicycle |
| Sport automobile | FlagCheckered |
| Golf | GolfBall (à défaut, Flag) |
| E-sport | GameController |
| Fléchettes | Target |
| Autres | Trophy est interdit : utiliser CircleDashed |

- **Icônes fonctionnelles :**

| Fonction | Icône |
|---|---|
| Aide | Lifebuoy (bouée), toujours en haut à droite de l'accueil |
| Scan | Scan |
| Budget | Gauge |
| Pause | PauseCircle |
| Verrou | LockSimple |
| Premium | Sparkle |

### 2.7 Mouvement et retours

- Durées de 200 à 250 ms, courbe ease-out. Aucun rebond, aucune animation de fête.
- Retour haptique léger à l'enregistrement d'un pari et au règlement. Aucun retour haptique sur un gain.
- Changement de mois : glissement horizontal de 250 ms.

### 2.8 Visualisation de données

- **Courbes :** trait de 2 px en `brand-600`. Zone sous la courbe en `brand-100` à 40 %. Ligne zéro en pointillés `border-strong`.
- **Barres horizontales :** négatif en `negative`, positif en `positive-chart`, libellé à gauche, valeur à droite en chiffres tabulaires.
- Pas de camembert, pas de 3D, pas plus de 6 barres visibles (au-delà : « Voir tout »).

### 2.9 Logo

- Le logo est utilisé tel quel, sans modification de couleur.
- Usages :
  - écran de démarrage, centré à 96 pt ;
  - onboarding ON-01 à 72 pt ;
  - écran de verrouillage ;
  - images de partage du récap à 48 pt ;
  - captures store.
- Pas de logo dans la barre de navigation des écrans principaux.


## 2. Composants

Chaque composant existe en mode clair et en mode sombre.

| Nom | Description |
|---|---|
| `PrimaryButton` | Hauteur 52, rayon 12, fond `brand-600` (sombre : `brand-400`), texte `body-strong` `on-primary`, pleine largeur. États : normal, pressé (−8 % de luminosité), désactivé (opacité 40 %), chargement (indicateur à la place du texte) |
| `SecondaryButton` | Hauteur 52, fond `surface-2`, texte `text-primary` |
| `TextButton` | Texte `brand-600`, sans fond, hauteur minimale 44 |
| `DestructiveButton` | Comme `SecondaryButton`, texte `negative` |
| `IconButton` | Zone de 44 × 44, icône de 24 |
| `TabBar` | 5 emplacements : Accueil (House), Paris (ListBullets), bouton d'ajout central, Analyses (ChartLineUp), Profil (UserCircle). Libellés `caption`. Actif en `brand-600` avec icône Fill |
| `AddButton` | Cercle de 56, fond `brand-600`, icône Plus blanche, légèrement surélevé au centre de la `TabBar` |
| `TopBar` | Titre `title-2` aligné à gauche, actions à droite (`IconButton`) |
| `MonthSwitcher` | « Octobre 2026 » en `title-2`, chevrons gauche et droite de 44 × 44. Chevron droit désactivé sur le mois en cours |
| `NetAmountCard` | Carte. `overline` « Résultat net », puis `display` (montant signé), puis `callout` `text-secondary` (« sur 186,00 € misés · 23 paris ») |
| `StatTile` | Moitié de largeur. `overline` en libellé, `title-3` en valeur, `caption` en complément |
| `BudgetGauge` | Carte. Titre « Budget d'octobre », valeur « 186 € / 200 € », barre de 8 px de haut à bords arrondis, pourcentage à droite, ligne de projection optionnelle en `caption` |
| `InsightCard` | Carte à fond `brand-50` (sombre : `surface-2`). `overline` « Constat du mois », texte `body`, lien optionnel |
| `ToSettleRow` | Ligne de pari en attente, avec deux petits boutons « Gagné » et « Perdu » à droite (hauteur 36, fond `surface-2`) |
| `BetRow` | Hauteur minimale 72. Icône du sport dans un cercle `surface-2` de 40. Ligne 1 : événement (`body-strong`, une ligne, ellipse). Ligne 2 : « Bookmaker · 10,00 € · cote 1,65 » (`caption`). À droite : `StatusChip` au-dessus du résultat net (`body-strong`) |
| `StatusChip` | Pilule de hauteur 24, `caption` en 500. En cours : `surface-2` + Clock. À régler : `warning-bg` + `warning`. Gagné : `surface-2` + Check, texte `text-primary`. Perdu : `negative-bg` + `negative`. Remboursé et Cash out : `surface-2` |
| `SectionHeader` | `title-3` à gauche, `TextButton` optionnel à droite |
| `DayHeader` | `overline` `text-secondary` (« SAMEDI 11 OCTOBRE »), sur fond `bg`, fixé en haut au défilement |
| `SegmentedControl` | Fond `surface-2`, segment actif sur `surface` avec bordure, hauteur 40 |
| `ChoiceChip` | Hauteur 36, rayon 8. Inactif : `surface` + bordure. Actif : `brand-100` + bordure `brand-200` + texte `brand-700` |
| `MoneyField` | Grand champ de saisie : valeur en `title-1`, devise en suffixe, clavier numérique, libellé au-dessus |
| `OddsField` | Comme `MoneyField`, avec une aide de format sous le champ (« Décimal » ou « Américain ») |
| `TextField` | Hauteur 52, fond `surface-2`, rayon 12, libellé au-dessus, aide ou erreur en dessous |
| `PickerField` | Comme `TextField`, avec un chevron. Ouvre une `BottomSheet` |
| `ToConfirmField` | Variante d'un champ pour le scan : fond `warning-bg`, bordure `warning`, icône WarningCircle, aide « À vérifier » |
| `BottomSheet` | Rayon supérieur 24, poignée, titre `title-3`, contenu défilant |
| `AlertModal` | Fenêtre centrée, rayon 24. Icône en haut, titre `title-3`, texte `body`, 1 à 3 boutons empilés, lien « Besoin d'aide ? » en bas |
| `Banner` | Bande pleine largeur dans une carte, rayon 12, icône + texte `callout` + fermeture optionnelle. Variantes info (`brand-50`), avertissement (`warning-bg`), négatif (`negative-bg`) |
| `Toast` | Pilule sombre en bas d'écran, 3 s, avec une action optionnelle « Annuler » |
| `EmptyState` | Illustration au trait (`brand-300` et `teal-300`, motif abstrait de lignes et de cercles), titre `title-3`, texte `body`, bouton |
| `LockedOverlay` | Flou de 12 px sur le contenu, puis carte centrale : icône Sparkle, titre, texte, `PrimaryButton` « Débloquer avec Premium » |
| `PlanCard` | Carte sélectionnable pour le paywall : radio, nom de l'offre, prix, sous-prix, badge optionnel. Sélectionnée : bordure 2 px `brand-600` |
| `StoryCard` | Carte du récap plein écran, fond `brand-800`, texte blanc, barres de progression en haut |
| `ListRow` | Ligne de réglage de hauteur 56 : icône, libellé, valeur ou interrupteur, chevron |
| `PauseCard` | Carte à fond `teal-100` (sombre : `surface-2`) : icône PauseCircle, « Pause en cours · 12 jours », estimation, bouton « Terminer » |
| `ProgressDots` | Indicateur d'étape de l'onboarding, 7 points |
| `ScanFrame` | Cadre de visée de l'appareil photo, 4 coins arrondis blancs, consigne en dessous |
| `Skeleton` | Blocs `surface-2` animés pendant les chargements |


## 3. États transverses

| État | Traitement |
|---|---|
| Chargement | `Skeleton` (jamais d'indicateur seul en plein écran) |
| Hors ligne | `Banner` neutre « Hors ligne. Tes paris sont enregistrés sur ce téléphone. » |
| Erreur d'achat | `Toast` « L'achat n'a pas abouti. Aucun montant n'a été débité. » |
| Texte agrandi à 200 % | Variante de HO-01 et AD-02 où les tuiles passent l'une sous l'autre |
| Textes longs | Variante de HO-01 en allemand : « Nettoergebnis », « Wetteinsatz », « Monatsbudget » |


## 4. Accessibilité

- Contraste WCAG AA : 4,5:1 pour le texte, 3:1 pour les grands textes et les éléments graphiques.
- Cibles tactiles d'au moins 44 × 44 pt.
- Aucune information portée uniquement par la couleur : signes « + » et « − », libellés de statut, icônes.
- Libellés d'accessibilité sur toutes les icônes seules (aide, filtres, chevrons).
- Ordre de lecture logique de haut en bas. Le chiffre principal est annoncé avec son libellé (« Résultat net, moins 64 euros 50 »).
- Mouvement réduit : si l'option système est active, le changement de mois et les stories passent en fondu.


## 5. Internationalisation

- Prévoir +35 % de longueur de texte (allemand). Les boutons passent sur 2 lignes plutôt que de tronquer.
- Aucun texte dans les images, sauf le logo.
- Chiffres et devises au format de la locale : « 1 552,40 € » en français, « $1,552.40 » en anglais US, « R$ 1.552,40 » au Brésil.
- Format de cote selon le réglage : « 1,85 » ou « −118 ».


## 6. Jeu de données d'exemple (tests et aperçus)

Date du jour : mercredi 14 octobre 2026. Utilisateur en France, euros, cotes décimales.

### 5.1 Octobre 2026 (mois en cours)

| Indicateur | Valeur |
|---|---|
| Paris | 23, dont 2 en cours (37,00 € engagés) et 21 réglés (8 gagnés, 12 perdus, 1 remboursé) |
| Total misé | 186,00 € |
| Résultat net | −64,50 € (simples −6,50 €, combinés −58,00 €) |
| Taux de réussite | 40 % (taux nécessaire : 47 %) |
| Cote moyenne | 2,13 |
| Mise moyenne | 8,09 € |
| Mise médiane | 8,00 € |
| ROI | −43,3 % |
| Budget | 200 € (93 % utilisé). Projection : ≈ 412 € à la fin du mois, budget atteint vers le 15 octobre |
| Depuis le début | −1 552,40 € (bilan initial −1 240,00 € et paris −312,40 €) |

### 5.2 Paris d'octobre

| Date | Événement | Sport | Bookmaker | Mise | Cote | Statut | Net |
|---|---|---|---|---|---|---|---|
| 13 oct. | Real Madrid - Barça · Real Madrid | Basket | Unibet | 25,00 € | 1,80 | À régler | |
| 12 oct. | Lyon - Lille · Les deux équipes marquent | Football | Betclic | 12,00 € | 1,72 | En cours (dim. 18 oct., 21:00) | |
| 11 oct. | Combiné 4 sélections | Football | Winamax | 5,00 € | 7,40 | Perdu | −5,00 € |
| 11 oct. | Alcaraz - Sinner · Alcaraz | Tennis | Unibet | 15,00 € | 2,10 | Gagné | +16,50 € |
| 10 oct. | PSG - OM · Victoire PSG | Football | Winamax | 10,00 € | 1,65 | Perdu | −10,00 € |
| 10 oct. | Toulouse - La Rochelle · Toulouse −7,5 | Rugby | Winamax | 8,00 € | 1,95 | Gagné | +7,60 € |
| 9 oct. | Combiné 3 sélections | Football | Betclic | 10,00 € | 4,20 | Perdu | −10,00 € |

### 5.3 Bilan initial

| Bookmaker | Déposé | Retiré | Solde | Résultat |
|---|---|---|---|---|
| Winamax | 1 450 € | 380 € | 12 € | −1 058 € |
| Betclic | 260 € | 75 € | 3 € | −182 € |
| **Total** | | | | **−1 240 €** |

### 5.4 Récap de septembre 2026

| Indicateur | Valeur |
|---|---|
| Paris | 31 (19 simples, 12 combinés) |
| Total misé | 242 €, soit 8 € par jour en moyenne |
| Résultat net | −118 € (≈ 11 mois de streaming) |
| Taux de réussite | 35 % (taux nécessaire : 45 %) |
| Combinés | −96 € |
| Simples | −22 € |
| Budget | 200 € dépassé de 42 € (121 %) |
| Résultat en pourcentage des mises | −49 % |

### 5.5 Variante États-Unis (lot 9)

| Indicateur | Valeur |
|---|---|
| Mois | October 2026 |
| Total misé | $186.00 |
| Résultat net | −$64.50 |
| Budget | $200 |
| Format de cote | Américain |

| Événement | Sport | Bookmaker | Mise | Cote | Statut |
|---|---|---|---|---|---|
| Chiefs vs Bills · Chiefs −3.5 | NFL | DraftKings | $20.00 | −110 | Lost, −$20.00 |
| Lakers vs Celtics · Over 224.5 | NBA | FanDuel | $10.00 | −105 | To settle (game on Oct 13) |
| Yankees vs Red Sox · Yankees ML | MLB | BetMGM | $15.00 | +120 | Won, +$18.00 |


## 7. Correctifs d'accessibilité validés dans les maquettes

- Interrupteurs inactifs : piste `text-tertiary` #8A9691 (3,1:1) au lieu de #C9D2CE.
- Radios et cases non cochées : bordure 2 px en #8A9691.
- Puces de règlement (BE-03) et de durée (PA-01) à 44 de haut ; `ChoiceChip` et boutons de `ToSettleRow` restent à 36 de haut avec une zone tactile étendue à 48 dp.
- Fermeture de la bannière de palier (AL-02) en zone de 44 × 44.
- Bouton Google (AC-01) : logo officiel, pas le « G » provisoire.
- Icônes de sport manquantes dans Phosphor (rugby, hockey sur glace, handball) : icône dédiée si elle existe dans la version épinglée de `phosphor_flutter`, sinon `CircleDashed`.

