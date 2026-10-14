---
id: T-80
title: Notifications locales N-01 avec actions en arrière-plan
status: todo
phase: 8 Notifications
depends_on: [T-64, T-30]
manual: false
estimate: L
model: fable
done_at:
---

# T-80 · Notifications locales N-01 avec actions en arrière-plan

## Objectif

À chaque pari en cours, une notification de résultat est programmée à l'heure calculée, avec actions Gagné, Perdu, Ouvrir qui règlent le pari sans ouvrir l'app, relance à 24 h, regroupement à 30 min, plafond de 50 et reprogrammation à l'ouverture, au règlement et au redémarrage.

## Contexte

- brief F-06 (N-01, contrainte iOS, durées), N-02
- docs/architecture.md section 6 (règlement depuis une notification)
- cadrage décisions 28, 30
- `.claude/rules/` applicables et `CLAUDE.md`.
- Tâche marquée `model: fable` : une erreur y est coûteuse ou silencieuse ; Fable 5.1 conseillé.

## Étapes

1. `lib/domain/logic/notification_planner.dart` : heure (début + durée du sport, ou heure par défaut réglable 18:00 à 23:30, combiné = sélection la plus tardive, > 23:30 → lendemain 09:00, sans date → rien), relance +24 h, regroupement (< 30 min → une seule « N paris attendent leur résultat », sans actions), plafond 50 par ordre chronologique, priorité journalière hors N-01 (N-04, N-02, N-03, N-05).
2. `NotificationService` : `flutter_local_notifications` avec catégories iOS (actions `won`, `lost`, `open`), canal Android `results`, `timezone` + `flutter_timezone`, `AndroidScheduleMode.inexactAllowWhileIdle` (aucune alarme exacte), `RECEIVE_BOOT_COMPLETED` et reprogrammation au démarrage.
3. `lib/config/background_entrypoint.dart` : `@pragma('vm:entry-point')` qui ouvre drift, règle via `settle_bet` (source `notification`), évalue N-02, reprogramme ; iOS : actions en arrière-plan via `DarwinNotificationActionOption`.
4. `NotificationRepositoryImpl.rescheduleAll(now)` appelé par `record_bet`, `settle_bet`, au lancement et au retour au premier plan ; `permission` et `requestPermission` (ON-08).
5. Contenu : titre et corps N-01 ; option « Notifications discrètes » (T-81) remplace le contenu.
6. Analytics `notification_action(action)`.

## Tests

| Test (comportement vérifié) | Fichier | Commande |
|---|---|---|
| NotificationPlanner : heure selon sport, heure par défaut, créneau calme, combiné, regroupement, relance, plafond 50 | `test/domain/logic/notification_planner_test.dart` | `flutter test test/domain/logic/notification_planner_test.dart` |

## Sécurité

- [ ] Aucun secret ni valeur réelle dans le diff
- [ ] Aucune dépendance hors de la liste de docs/architecture.md section 10
- [ ] Aucune permission d'alarme exacte
- [ ] Charge utile des notifications limitée à l'id du pari

## Definition of Done

- [ ] Étapes réalisées
- [ ] Tests du tableau écrits et verts, aucun test superflu
- [ ] Checklist sécurité cochée (ou n/a)
- [ ] `make check` vert (plus `make test-db` et `make test-functions` si `supabase/` est touché)
- [ ] Revue `code-reviewer` : OK ou OK avec réserves consignées
- [ ] Statut `done` avec date dans ce fichier et dans `tasks/INDEX.md`
- [ ] Commit unique `feat(T-80): Notifications locales N-01 avec actions en arrière-plan` sur `dev`, sans push (ou rien à committer pour une tâche purement manuelle)

## Notes de revue
