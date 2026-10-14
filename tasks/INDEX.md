# Index des tâches BetSafely

Source de vérité de l'avancement avec le frontmatter de chaque tâche (`scripts/check-tasks.sh` vérifie la cohérence). Statuts : `todo`, `in_progress`, `blocked_manual`, `done`. Estimation : S (moins d'une heure de session), M (une session), L (une session longue). « Manuel » : la tâche contient une action de Rayan ; elle s'arrête en `blocked_manual` jusqu'à `/manual-done`.

Version visée : **1.0.0** = toutes les tâches de cet index.

Tâches `model: fable` (erreur coûteuse ou silencieuse) : T-22, T-23, T-25, T-26, T-27, T-40, T-41, T-42, T-43, T-80, T-120, T-121.

## Phase 0 Socle

| ID | Titre | Statut | Dépend de | Estimation | Manuel | Terminé le |
|---|---|---|---|---|---|---|
| T-00 | Création du projet Flutter | todo | aucune | S | non |  |
| T-01 | Analyse stricte, FVM, hooks et scripts branchés | todo | T-00 | S | oui |  |
| T-02 | Flavors dev et prod | todo | T-01 | M | non |  |
| T-03 | Result<T> et Command | todo | T-01 | S | non |  |
| T-04 | Injection des dépendances et bootstrap | todo | T-02, T-03 | M | non |  |
| T-05 | Routeur go_router et shell à onglets | todo | T-04 | M | non |  |
| T-06 | Thème, tokens et composants de base | todo | T-05 | L | non |  |
| T-07 | Localisation FR et EN et formatters | todo | T-06 | M | non |  |
| T-08 | CI GitHub Actions opérationnelle | todo | T-07 | S | non |  |
| T-09 | Base locale drift | todo | T-04 | L | non |  |

## Phase 1 Comptes et services

| ID | Titre | Statut | Dépend de | Estimation | Manuel | Terminé le |
|---|---|---|---|---|---|---|
| T-10 | Projets Supabase dev et prod | todo | T-01 | S | oui |  |
| T-11 | Projet RevenueCat, Test Store, produits, paywall, webhook | todo | T-10 | M | oui |  |
| T-12 | Apps dans les stores, identifiants, keystore, abonnements | todo | T-02 | M | oui |  |
| T-13 | Projets Sentry et PostHog | todo | T-10 | S | oui |  |

## Phase 2 Backend

| ID | Titre | Statut | Dépend de | Estimation | Manuel | Terminé le |
|---|---|---|---|---|---|---|
| T-20 | Migration des référentiels et seed | todo | T-10 | M | non |  |
| T-21 | Migration des tables utilisateur et triggers de synchro | todo | T-20 | M | non |  |
| T-22 | Policies RLS et tests pgTAP | todo | T-21 | L | non |  |
| T-23 | Fonctions de quota de scan | todo | T-22 | M | non |  |
| T-24 | Edge Function scan-ticket | todo | T-23 | L | non |  |
| T-25 | Edge Function revenuecat-webhook et table entitlements | todo | T-22 | M | non |  |
| T-26 | Edge Function delete-account | todo | T-25 | M | non |  |
| T-27 | Jobs planifiés de purge | todo | T-25 | S | non |  |
| T-28 | Déploiement du backend sur le projet dev | todo | T-20, T-21, T-22, T-23, T-24, T-25, T-26, T-27, T-11 | S | oui |  |

## Phase 3 Référentiel et préférences

| ID | Titre | Statut | Dépend de | Estimation | Manuel | Terminé le |
|---|---|---|---|---|---|---|
| T-30 | Référentiel embarqué et ReferenceRepository | todo | T-09, T-20 | M | non |  |
| T-31 | PreferencesRepository et réglages locaux | todo | T-09, T-07 | M | non |  |

## Phase 4 Authentification et compte

| ID | Titre | Statut | Dépend de | Estimation | Manuel | Terminé le |
|---|---|---|---|---|---|---|
| T-40 | SupabaseService et session anonyme | todo | T-30, T-31, T-10 | M | non |  |
| T-41 | Liens profonds et lien magique | todo | T-40, T-05 | M | non |  |
| T-42 | Connexion Apple et Google par jeton natif | todo | T-41 | L | non |  |
| T-43 | Suppression de compte et effacement local | todo | T-42, T-26 | M | non |  |

## Phase 5 Onboarding

| ID | Titre | Statut | Dépend de | Estimation | Manuel | Terminé le |
|---|---|---|---|---|---|---|
| T-50 | Onboarding ON-01 à ON-03, ON-07, ON-08 et reprise | todo | T-31, T-05, T-06, T-07 | L | non |  |
| T-51 | Bilan rétroactif (ON-04 à ON-06, Profil > Mon bilan initial) | todo | T-50, T-09, T-30 | M | non |  |

## Phase 6 Paris

| ID | Titre | Statut | Dépend de | Estimation | Manuel | Terminé le |
|---|---|---|---|---|---|---|
| T-60 | Domaine Bet et BetMath (C-01 à C-12) | todo | T-04, T-03 | M | non |  |
| T-61 | BetRepository sur drift | todo | T-60, T-09 | M | non |  |
| T-62 | Formulaire de saisie AD-01 à AD-04 | todo | T-61, T-30, T-31, T-06, T-07 | L | non |  |
| T-63 | Liste des paris BE-01, filtres et recherche | todo | T-61, T-06 | M | non |  |
| T-64 | Détail BE-02, règlement BE-03 et use case settle_bet | todo | T-63 | M | non |  |
| T-65 | Accueil HO-01 à HO-05 et constats | todo | T-64, T-51 | L | non |  |

## Phase 7 Budget, alertes et pause

| ID | Titre | Statut | Dépend de | Estimation | Manuel | Terminé le |
|---|---|---|---|---|---|---|
| T-70 | Budget mensuel, jauge et alerte 100 % (BU-01, AL-01) | todo | T-65 | M | non |  |
| T-71 | Paliers, budgets détaillés et projection (BU-02, AL-02) | todo | T-70 | M | non |  |
| T-72 | Mode Pause (PA-01, PA-02, AL-04, HO-04, historique) | todo | T-70 | M | non |  |
| T-73 | Détecteur de chasse aux pertes (AL-03) | todo | T-72 | M | non |  |

## Phase 8 Notifications

| ID | Titre | Statut | Dépend de | Estimation | Manuel | Terminé le |
|---|---|---|---|---|---|---|
| T-80 | Notifications locales N-01 avec actions en arrière-plan | todo | T-64, T-30 | L | non |  |
| T-81 | Notifications N-02 à N-05, réglages PR-02 et discrétion | todo | T-80, T-72 | M | non |  |

## Phase 9 Scan

| ID | Titre | Statut | Dépend de | Estimation | Manuel | Terminé le |
|---|---|---|---|---|---|---|
| T-90 | Scan IA du ticket (SC-02 à SC-06) | todo | T-62, T-24, T-40 | L | non |  |

## Phase 10 Analyses et récap

| ID | Titre | Statut | Dépend de | Estimation | Manuel | Terminé le |
|---|---|---|---|---|---|---|
| T-100 | Analyses AN-01 et AN-02 | todo | T-73, T-65 | L | non |  |
| T-101 | Récap mensuel et annuel RC-01 à RC-09 et partage | todo | T-100 | L | non |  |

## Phase 11 Monétisation

| ID | Titre | Statut | Dépend de | Estimation | Manuel | Terminé le |
|---|---|---|---|---|---|---|
| T-110 | PurchasesService, SubscriptionRepository, paywall et gardes d'entitlement | todo | T-40, T-65, T-11 | L | non |  |
| T-111 | Restauration, abonnement dans le profil, erreur de facturation, N-04 | todo | T-110, T-81 | M | non |  |
| T-112 | Achats sandbox et scan sur appareils réels | todo | T-111, T-90, T-12, T-28 | M | oui |  |

## Phase 12 Synchronisation

| ID | Titre | Statut | Dépend de | Estimation | Manuel | Terminé le |
|---|---|---|---|---|---|---|
| T-120 | Synchronisation Premium (envoi, récupération, conflits) | todo | T-110, T-42, T-22 | L | non |  |
| T-121 | Écrans compte AC-01 à AC-04 et fin d'abonnement | todo | T-120, T-43 | M | non |  |

## Phase 13 Profil et finitions

| ID | Titre | Statut | Dépend de | Estimation | Manuel | Terminé le |
|---|---|---|---|---|---|---|
| T-130 | Profil PR-01, préférences, À propos, effacement et export | todo | T-111, T-121, T-43 | L | non |  |
| T-131 | Verrouillage biométrique LK-01 et confidentialité PR-03 | todo | T-130 | M | non |  |
| T-132 | Widget d'écran d'accueil iOS et Android | todo | T-110, T-70 | L | non |  |
| T-133 | Aide jeu responsable HE-01 | todo | T-30, T-06 | S | non |  |
| T-134 | Accessibilité, états vides et erreurs, texte à 200 %, mouvement réduit | todo | T-130, T-131, T-101, T-90 | M | non |  |
| T-135 | Traductions ES, PT-BR, IT, DE | todo | T-134 | M | non |  |
| T-136 | Relecture native des textes sensibles | todo | T-135, T-140 | S | oui |  |
| T-137 | Icône, splash, textes de permissions, privacy manifest, Sentry et PostHog | todo | T-134, T-13 | M | non |  |
| T-138 | Mise à jour obligatoire et écran de démarrage | todo | T-137, T-30 | S | non |  |
| T-139 | Test d'intégration du parcours critique | todo | T-138, T-111 | M | non |  |

## Phase 14 Mise en production

| ID | Titre | Statut | Dépend de | Estimation | Manuel | Terminé le |
|---|---|---|---|---|---|---|
| T-140 | Site légal et support (GitHub Pages) | todo | T-135 | M | non |  |
| T-141 | Build release signé (appbundle et ipa) | todo | T-139, T-12 | S | oui |  |
| T-142 | Recette sur appareils réels | todo | T-141, T-112, T-132 | M | oui |  |
| T-143 | Fiches stores, déclarations de confidentialité et soumission | todo | T-142, T-136, T-140 | M | oui |  |

## Graphe de départ

`/batch` depuis un dépôt vierge enchaîne T-00, T-01 (s'arrête pour l'outillage), puis T-02 à T-09, et bute sur T-10 (projets Supabase). Faire T-10 à T-13 en avance (`/manual-done`) permet ensuite d'enchaîner T-20 à T-27, T-30, T-31, T-40 à T-43, T-50, T-51, T-60 à T-65, T-70 à T-73, T-80, T-81, T-90, T-100, T-101, T-110, T-111 sans interruption jusqu'à T-28 et T-112.
