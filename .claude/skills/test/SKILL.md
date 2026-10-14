---
name: test
description: Rejoue les tests d'une tâche (/test T-XX) ou de tout le projet (/test), signale les tests manquants et superflus au regard de la politique de tests, sans jamais en ignorer.
argument-hint: "[T-XX]"
effort: low
---

# /test $ARGUMENTS

1. Sans argument : `make test`, puis `make test-db` et `make test-functions` si `supabase/` contient des tests. Avec `T-XX` : lance exactement les commandes de la section Tests du fichier `tasks/T-XX-*.md`.
2. Rapporte : nombre de tests, échecs avec fichier et message, durée.
3. Compare avec `.claude/rules/tests.md` et la section Tests de la tâche :
   - **Manquants :** règle métier, ViewModel, policy RLS ou Edge Function du diff sans test exigé.
   - **Superflus :** golden, getter, constructeur, code généré, doublon entre niveaux, mock là où un fake suffit.
   - **Interdits présents :** `skip`, `@Skip`, test commenté.
4. Ne modifie aucun test. Propose la liste des ajouts et suppressions, à faire dans la tâche concernée.
5. Jamais de `--skip`, jamais de test désactivé pour obtenir le vert.
