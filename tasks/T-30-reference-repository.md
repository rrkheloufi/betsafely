---
id: T-30
title: Référentiel embarqué et ReferenceRepository
status: todo
phase: 3 Référentiel et préférences
depends_on: [T-09, T-20]
manual: false
estimate: M
model: opus
done_at:
---

# T-30 · Référentiel embarqué et ReferenceRepository

## Objectif

`ReferenceRepository` sert bookmakers, sports, marchés, aides, phrases, équivalents, durées et config depuis la base locale, remplie par l'instantané embarqué puis rafraîchie depuis Supabase si la version distante est plus récente.

## Contexte

- docs/architecture.md sections 3.2 et 3.4
- docs/database.md section 1 (référentiels)
- cadrage décisions 20, 21
- `.claude/rules/` applicables et `CLAUDE.md`.

## Étapes

1. `assets/reference/snapshot.json` généré par `scripts/export-reference-snapshot.sh` (T-20) et versionné.
2. `SupabaseService` minimal (T-40 l'étend) : lecture publique des tables de référence.
3. `ReferenceRepositoryImpl` : au premier lancement, import de l'instantané dans drift ; `refresh()` compare `reference_version` distante et locale, télécharge tout si plus récente, dans une transaction ; lecture toujours locale ; ordre par pays et favoris en tête.
4. Libellés localisés par `labels[locale] ?? labels['en']`.

## Tests

| Test (comportement vérifié) | Fichier | Commande |
|---|---|---|
| Import de l'instantané puis refresh seulement si la version distante est supérieure (fake du service) | `test/data/repositories/reference/reference_repository_test.dart` | `flutter test test/data/repositories/reference/reference_repository_test.dart` |

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
- [ ] Commit unique `feat(T-30): Référentiel embarqué et ReferenceRepository` sur `dev`, sans push (ou rien à committer pour une tâche purement manuelle)

## Notes de revue
