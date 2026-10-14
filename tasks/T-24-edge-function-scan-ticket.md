---
id: T-24
title: Edge Function scan-ticket
status: todo
phase: 2 Backend
depends_on: [T-23]
manual: false
estimate: L
model: opus
done_at:
---

# T-24 · Edge Function scan-ticket

## Objectif

`scan-ticket` reçoit une image JPEG, vérifie session et quota, appelle le modèle de vision avec le schéma JSON du brief, renvoie les brouillons, rembourse en cas d'échec, sans jamais stocker ni logger l'image.

## Contexte

- docs/database.md section 3
- brief F-04 (chaîne technique, schéma JSON, erreurs)
- .claude/rules/supabase.md
- `.claude/rules/` applicables et `CLAUDE.md`.

## Étapes

1. `supabase/functions/_shared/` : `supabase_client.ts` (client service_role depuis `SUPABASE_SERVICE_ROLE_KEY` et client utilisateur depuis le JWT), `http.ts` (réponses JSON typées), `cors.ts`.
2. `scan-ticket/index.ts` : POST multipart ou base64 (taille max 2 Mo, type image/jpeg), JWT obligatoire (anonyme accepté), `has_active_premium` ou secours API RevenueCat (`GET /v1/subscribers/{uid}` avec `REVENUECAT_SECRET_API_KEY`), `reserve_scan`, appel au modèle `claude-haiku-5-5` (Messages API, image en base64, outil ou JSON strict d'après le schéma du brief, délai 20 s), validation du JSON (zod), normalisation (`odds_decimal` calculé si absent via C-08), `refund_scan` si échec technique ou liste vide ou `no_ticket`, réponse `{ bets: [...], bookmaker_guess, quota: { remaining, total } }` ou erreur typée (`unreadable`, `no_ticket`, `timeout`, `quota_exceeded`).
3. Jamais l'image ni le JSON de sortie dans `console.log` ; seulement durée, statut, taille.
4. `index_test.ts` : 401 sans JWT ; 429 `quota_exceeded` quand `reserve_scan` refuse (client Supabase factice) ; 200 avec brouillons quand le modèle répond (fetch factice) ; remboursement appelé sur `no_ticket`.

## Tests

| Test (comportement vérifié) | Fichier | Commande |
|---|---|---|
| 401 sans session, 429 quota, 200 nominal, remboursement sur no_ticket | `supabase/functions/scan-ticket/index_test.ts` | `make test-functions` |

## Sécurité

- [ ] Aucun secret ni valeur réelle dans le diff
- [ ] Aucune dépendance hors de la liste de docs/architecture.md section 10
- [ ] Clé Anthropic via Deno.env uniquement
- [ ] Aucune image dans les logs
- [ ] Entrée validée (taille, type) avant tout appel

## Definition of Done

- [ ] Étapes réalisées
- [ ] Tests du tableau écrits et verts, aucun test superflu
- [ ] Checklist sécurité cochée (ou n/a)
- [ ] `make check` vert (plus `make test-db` et `make test-functions` si `supabase/` est touché)
- [ ] Revue `code-reviewer` : OK ou OK avec réserves consignées
- [ ] Statut `done` avec date dans ce fichier et dans `tasks/INDEX.md`
- [ ] Commit unique `feat(T-24): Edge Function scan-ticket` sur `dev`, sans push (ou rien à committer pour une tâche purement manuelle)

## Notes de revue
