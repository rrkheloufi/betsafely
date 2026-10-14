---
id: T-137
title: Icône, splash, textes de permissions, privacy manifest, Sentry et PostHog
status: todo
phase: 13 Profil et finitions
depends_on: [T-134, T-13]
manual: false
estimate: M
model: opus
done_at:
---

# T-137 · Icône, splash, textes de permissions, privacy manifest, Sentry et PostHog

## Objectif

L'app a son icône et son écran de démarrage (ON-00), tous les textes de permissions, le privacy manifest iOS, et Sentry et PostHog sont branchés sans donnée personnelle avec l'analytics désactivable.

## Contexte

- docs/architecture.md section 13
- brief 11.3, 11.4, F-01 (ON-00)
- cadrage décision 34
- `.claude/rules/` applicables et `CLAUDE.md`.

## Étapes

1. Icônes iOS et Android depuis le logo (`flutter_launcher_icons` en dev_dependency, justifié : génération seulement), splash natif fond `bg` logo 96 pt (`flutter_native_splash`, même justification).
2. Info.plist : `NSCameraUsageDescription`, `NSFaceIDUsageDescription` (textes de docs/architecture.md) ; AndroidManifest : `CAMERA`, `POST_NOTIFICATIONS`, `USE_BIOMETRIC`, `RECEIVE_BOOT_COMPLETED`.
3. `ios/Runner/PrivacyInfo.xcprivacy` : API à raison déclarée (UserDefaults CA92.1, timestamp C617.1, disk space E174.1), aucun tracking, types de données collectées cohérents avec la section 13.
4. `CrashReportingService` (`sentry_flutter`, `beforeSend` qui retire les données utilisateur, `sendDefaultPii: false`, environnement par flavor) ; `AnalyticsService` (`posthog_flutter`, hôte UE, autocapture off, `optOut` lié à la préférence Confidentialité) ; `TelemetryRepositoryImpl` avec la liste fermée d'événements 11.3 sans montant.
5. Interrupteur « Statistiques d'usage anonymes » dans PR-03.

## Tests

| Test (comportement vérifié) | Fichier | Commande |
|---|---|---|
| TelemetryRepository refuse un événement hors liste et n'envoie rien quand l'utilisateur a désactivé l'analytics | `test/data/repositories/telemetry/telemetry_repository_test.dart` | `flutter test test/data/repositories/telemetry/telemetry_repository_test.dart` |

## Sécurité

- [ ] Aucun secret ni valeur réelle dans le diff
- [ ] Aucune dépendance hors de la liste de docs/architecture.md section 10
- [ ] Aucune donnée personnelle dans Sentry ni PostHog
- [ ] Aucune demande ATT

## Definition of Done

- [ ] Étapes réalisées
- [ ] Tests du tableau écrits et verts, aucun test superflu
- [ ] Checklist sécurité cochée (ou n/a)
- [ ] `make check` vert (plus `make test-db` et `make test-functions` si `supabase/` est touché)
- [ ] Revue `code-reviewer` : OK ou OK avec réserves consignées
- [ ] Statut `done` avec date dans ce fichier et dans `tasks/INDEX.md`
- [ ] Commit unique `feat(T-137): Icône, splash, textes de permissions, privacy manifest, Sentry et PostHog` sur `dev`, sans push (ou rien à committer pour une tâche purement manuelle)

## Notes de revue
