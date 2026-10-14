---
name: next
description: Affiche la première tâche todo dont toutes les dépendances sont done, ainsi que les tâches en cours ou bloquées. Usage /next.
effort: low
---

# /next

1. Lis `tasks/INDEX.md`.
2. Affiche :
   - les tâches `in_progress` (ID, titre) ;
   - les tâches `blocked_manual` (ID, titre, commande de reprise `/manual-done T-XX`) ;
   - la première tâche `todo` dont toutes les dépendances sont `done`, avec son titre, son estimation, `manual` et `model` ;
   - les 3 tâches prêtes suivantes, dans l'ordre de l'index.
3. Termine par la commande suggérée : `/task T-XX`, ou `/batch` si la tâche prête n'est pas manuelle et que les suivantes non plus.
4. Ne modifie aucun fichier.
