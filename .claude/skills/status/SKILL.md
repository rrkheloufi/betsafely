---
name: status
description: Avancement du projet par phase, tâches en cours et bloquées, incohérences entre tasks/INDEX.md et les frontmatters. Usage /status.
effort: low
---

# /status

1. Lis `tasks/INDEX.md` et le frontmatter de chaque `tasks/T-*.md` (`scripts/check-tasks.sh` fait la comparaison).
2. Affiche par phase : nombre de tâches `done` / total, tâches `in_progress`, `blocked_manual`.
3. Liste les incohérences : tâche dans l'index sans fichier ou l'inverse ; `status`, `depends_on`, `manual` différents entre index et frontmatter ; dépendance vers un ID inexistant ; dépendance circulaire ; tâche `done` sans date ; tâche `done` dont une dépendance n'est pas `done`.
4. Affiche la dernière ligne de `git log --oneline -5` et l'état de l'arbre (`git status --short`).
5. Termine par la commande suggérée (`/next`, `/batch`, `/manual-done T-XX`, ou la correction d'une incohérence).
6. Ne modifie aucun fichier.
