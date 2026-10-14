---
id: T-11
title: Projet RevenueCat, Test Store, produits, paywall, webhook
status: todo
phase: 1 Comptes et services
depends_on: [T-10]
manual: true
estimate: M
model: opus
done_at:
---

# T-11 · Projet RevenueCat, Test Store, produits, paywall, webhook

## Objectif

Le projet RevenueCat est configuré (entitlement, offering, produits par store et Test Store, paywall, webhook dev et prod), clés dans `env/*.json`, secrets posés sur Supabase.

## Contexte

- docs/manual-setup.md, T-11
- docs/monetisation.md
- `.claude/rules/` applicables et `CLAUDE.md`.

## Étape manuelle

**Actions**
1. Suivre docs/manual-setup.md, section T-11

- [ ] Confirmé par Rayan (date : )

**Vérifications automatisables**
- env/dev.json contient RC_API_KEY_IOS et RC_API_KEY_ANDROID
- `supabase secrets list` liste REVENUECAT_WEBHOOK_SECRET et REVENUECAT_SECRET_API_KEY

## Étapes

1. Après confirmation manuelle : vérifier `supabase secrets list` (noms seulement).
2. Rien à committer.

## Tests

Aucun test exigé par la politique pour cette tâche (configuration, action manuelle ou relais sans logique). Un test ajouté ici serait superflu.

## Sécurité

- [ ] Aucune clé RevenueCat dans un commit
- [ ] Le secret du webhook fait 32 octets aléatoires

## Definition of Done

- [ ] Étapes réalisées
- [ ] Tests du tableau écrits et verts, aucun test superflu
- [ ] Checklist sécurité cochée (ou n/a)
- [ ] `make check` vert (plus `make test-db` et `make test-functions` si `supabase/` est touché)
- [ ] Revue `code-reviewer` : OK ou OK avec réserves consignées
- [ ] Statut `done` avec date dans ce fichier et dans `tasks/INDEX.md`
- [ ] Commit unique `chore(T-11): Projet RevenueCat, Test Store, produits, paywall, webhook` sur `dev`, sans push (ou rien à committer pour une tâche purement manuelle)

## Notes de revue
