---
id: T-131
title: Verrouillage biométrique LK-01 et confidentialité PR-03
status: todo
phase: 13 Profil et finitions
depends_on: [T-130]
manual: false
estimate: M
model: opus
done_at:
---

# T-131 · Verrouillage biométrique LK-01 et confidentialité PR-03

## Objectif

Le verrouillage s'active dans Confidentialité (proposé une fois après le 5e pari), demande la biométrie ou le code à l'ouverture et après 5 minutes en arrière-plan, masque l'aperçu du sélecteur d'apps quand il est actif, et PR-03 porte aussi les notifications discrètes et les montants du widget.

## Contexte

- brief F-21, F-20 (Confidentialité)
- docs/design-tokens.md (LK-01, PR-03)
- cadrage décision 41
- `.claude/rules/` applicables et `CLAUDE.md`.

## Étapes

1. `LocalAuthService` (`local_auth`, `biometricOnly: false`), `AppLockRepositoryImpl` (préférence, horodatage d'arrière-plan).
2. `AppLockViewModel` et superposition LK-01 pilotée par `WidgetsBindingObserver` (pas une route) ; libellé selon la biométrie disponible (Face ID, Touch ID, empreinte, code).
3. Aperçu masqué : iOS vue de masquage sur `inactive`, Android `FLAG_SECURE` seulement quand le verrouillage est actif (canal de plateforme minimal).
4. `PrivacySettingsViewModel` et PR-03 (3 interrupteurs, texte de confidentialité) ; proposition unique après le 5e pari (`settings.lock_proposed`).

## Tests

| Test (comportement vérifié) | Fichier | Commande |
|---|---|---|
| AppLockViewModel : verrouillé à l'ouverture si activé, après 5 min en arrière-plan, déverrouillé après authentification réussie (fake) | `test/ui/lock/view_models/app_lock_view_model_test.dart` | `flutter test test/ui/lock/view_models/app_lock_view_model_test.dart` |

## Sécurité

- [ ] Aucun secret ni valeur réelle dans le diff
- [ ] Aucune dépendance hors de la liste de docs/architecture.md section 10
- [ ] Texte NSFaceIDUsageDescription conforme

## Definition of Done

- [ ] Étapes réalisées
- [ ] Tests du tableau écrits et verts, aucun test superflu
- [ ] Checklist sécurité cochée (ou n/a)
- [ ] `make check` vert (plus `make test-db` et `make test-functions` si `supabase/` est touché)
- [ ] Revue `code-reviewer` : OK ou OK avec réserves consignées
- [ ] Statut `done` avec date dans ce fichier et dans `tasks/INDEX.md`
- [ ] Commit unique `feat(T-131): Verrouillage biométrique LK-01 et confidentialité PR-03` sur `dev`, sans push (ou rien à committer pour une tâche purement manuelle)

## Notes de revue
