---
id: T-81
title: Notifications N-02 à N-05, réglages PR-02 et discrétion
status: todo
phase: 8 Notifications
depends_on: [T-80, T-72]
manual: false
estimate: M
model: opus
done_at:
---

# T-81 · Notifications N-02 à N-05, réglages PR-02 et discrétion

## Objectif

N-02 (budget depuis une notification), N-03 (récap le 1er à 10:00), N-04 (fin d'essai, branchée en T-111), N-05 (jalons de pause) sont programmées selon les règles communes, chaque type est désactivable, l'heure par défaut est réglable, et la bannière de réactivation s'affiche au plus une fois par mois.

## Contexte

- brief F-06 (N-02 à N-05, règles communes)
- docs/design-tokens.md (PR-02, NO-02 à NO-07)
- `.claude/rules/` applicables et `CLAUDE.md`.

## Étapes

1. `NotificationPlanner` étendu : N-03 (1er du mois 10:00 si au moins un pari le mois précédent ; 1er janvier une seule notification), N-05 (jours 7, 30, 90 depuis `started_at`), N-02 (seulement depuis l'arrière-plan), une par jour hors N-01.
2. `NotificationSettingsViewModel` et écran PR-02 : interrupteurs par type, heure de rappel par défaut (PickerField 18:00 à 23:30) ; réglages dans PreferencesRepository ; mode discret (PR-03 en T-131) : contenu remplacé par « BetSafely : une mise à jour t'attend », actions conservées.
3. Bannière « Réactiver les notifications » sur l'accueil si permission refusée, au plus une fois par mois (`settings.notification_banner_shown_month`).

## Tests

| Test (comportement vérifié) | Fichier | Commande |
|---|---|---|
| N-03 et N-05 aux bonnes dates ; un type désactivé n'est pas programmé ; une seule notification par jour hors N-01 avec la priorité attendue | `test/domain/logic/notification_planner_other_test.dart` | `flutter test test/domain/logic/notification_planner_other_test.dart` |

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
- [ ] Commit unique `feat(T-81): Notifications N-02 à N-05, réglages PR-02 et discrétion` sur `dev`, sans push (ou rien à committer pour une tâche purement manuelle)

## Notes de revue
