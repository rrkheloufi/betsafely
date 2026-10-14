---
id: T-135
title: Traductions ES, PT-BR, IT, DE
status: todo
phase: 13 Profil et finitions
depends_on: [T-134]
manual: false
estimate: M
model: opus
done_at:
---

# T-135 · Traductions ES, PT-BR, IT, DE

## Objectif

Les ARB `es`, `pt`, `it`, `de` sont complets (mêmes clés que `fr`), avec la terminologie de paris du brief, et les libellés des référentiels existent dans les 6 langues.

## Contexte

- brief 5.1, 12
- lib/l10n/app_fr.arb
- `.claude/rules/` applicables et `CLAUDE.md`.

## Étapes

1. Traduire depuis FR puis EN ; glossaire : acumulada, múltipla, multipla, Kombiwette ; +35 % de longueur vérifié sur HO-01 et AD-02 en allemand.
2. Migration Supabase ajoutant les labels `es`, `pt`, `it`, `de` dans `sports`, `markets`, `help_resources.hours`, `market_facts.texts`, `equivalents` ; instantané régénéré.
3. Locales supportées déclarées dans `App` (fr, en, es, pt, it, de).

## Tests

| Test (comportement vérifié) | Fichier | Commande |
|---|---|---|
| Toutes les locales ont les mêmes clés que fr (test de cohérence des ARB) | `test/l10n/arb_consistency_test.dart` | `flutter test test/l10n/arb_consistency_test.dart` |

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
- [ ] Commit unique `feat(T-135): Traductions ES, PT-BR, IT, DE` sur `dev`, sans push (ou rien à committer pour une tâche purement manuelle)

## Notes de revue
