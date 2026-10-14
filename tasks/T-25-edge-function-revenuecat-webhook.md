---
id: T-25
title: Edge Function revenuecat-webhook et table entitlements
status: todo
phase: 2 Backend
depends_on: [T-22]
manual: false
estimate: M
model: fable
done_at:
---

# T-25 · Edge Function revenuecat-webhook et table entitlements

## Objectif

`revenuecat-webhook` authentifie chaque appel, est idempotente, et tient `entitlements` à jour pour tous les types d'événements gérés.

## Contexte

- docs/database.md section 3
- docs/monetisation.md section 1 (webhook) et 3 (cas limites)
- revenuecat.com/docs/integrations/webhooks
- `.claude/rules/` applicables et `CLAUDE.md`.
- Tâche marquée `model: fable` : une erreur y est coûteuse ou silencieuse ; Fable 5.1 conseillé.

## Étapes

1. `revenuecat-webhook/index.ts` : lit `Authorization`, compare à `Bearer ${REVENUECAT_WEBHOOK_SECRET}` en temps constant (`crypto.subtle.timingSafeEqual` ou équivalent), 401 sinon ; parse le corps (`api_version`, `event`) ; insère `event.id` dans `revenuecat_events` (conflit = 200 sans effet) ; `app_user_id` (ou alias) non uuid = 200 ignoré ; pour `INITIAL_PURCHASE`, `RENEWAL`, `PRODUCT_CHANGE`, `UNCANCELLATION`, `TEMPORARY_ENTITLEMENT_GRANT` : upsert `entitlements` actif avec `expires_at`, `period_type`, `product_id`, `store`, `purge_after = null` ; `CANCELLATION` : met à jour expires_at sans désactiver ; `EXPIRATION` : `is_active = false`, `purge_after = expires_at + 90 jours` ; `BILLING_ISSUE` : `billing_issue_at` ; `TRANSFER` : désactive les `transferred_from`, active les `transferred_to` ; `TEST` : 200 ; autres types : 200 ignorés.
2. Après traitement, optionnellement `GET /v1/subscribers/{uid}` pour resynchroniser l'état (recommandation RevenueCat), avec `REVENUECAT_SECRET_API_KEY`.
3. `index_test.ts` : 401 sans secret ; 200 sans effet sur `event.id` dupliqué ; `INITIAL_PURCHASE` active ; `EXPIRATION` désactive et pose purge_after.

## Tests

| Test (comportement vérifié) | Fichier | Commande |
|---|---|---|
| 401 sans secret, idempotence, activation, expiration | `supabase/functions/revenuecat-webhook/index_test.ts` | `make test-functions` |

## Sécurité

- [ ] Aucun secret ni valeur réelle dans le diff
- [ ] Aucune dépendance hors de la liste de docs/architecture.md section 10
- [ ] Comparaison du secret à temps constant
- [ ] Idempotence par event.id avant tout effet
- [ ] Aucun e-mail ni identifiant personnel dans les logs

## Definition of Done

- [ ] Étapes réalisées
- [ ] Tests du tableau écrits et verts, aucun test superflu
- [ ] Checklist sécurité cochée (ou n/a)
- [ ] `make check` vert (plus `make test-db` et `make test-functions` si `supabase/` est touché)
- [ ] Revue `code-reviewer` : OK ou OK avec réserves consignées
- [ ] Statut `done` avec date dans ce fichier et dans `tasks/INDEX.md`
- [ ] Commit unique `feat(T-25): Edge Function revenuecat-webhook et table entitlements` sur `dev`, sans push (ou rien à committer pour une tâche purement manuelle)

## Notes de revue
