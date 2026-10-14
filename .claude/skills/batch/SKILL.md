---
name: batch
description: Enchaîne les tâches prêtes de tasks/INDEX.md sans solliciter l'utilisateur, en appliquant /task à chacune, et s'arrête à la première action manuelle. Usage /batch, /batch N (N tâches) ou /batch T-XX (jusqu'à T-XX incluse).
argument-hint: "[N | T-XX]"
disable-model-invocation: true
effort: high
---

# /batch $ARGUMENTS

Tu enchaînes les tâches sans me solliciter. Argument : vide (jusqu'au premier arrêt), un entier N (au plus N tâches), ou un identifiant T-XX (arrêt après T-XX).

## Procédure

1. **Préconditions :** branche `dev` ; arbre propre, ou modifications appartenant à la tâche `in_progress` en cours de reprise. Sinon, arrêt.
2. **Début de chaque itération :** relis `tasks/INDEX.md` et le fichier de la tâche. L'état vit dans les fichiers, pas dans la conversation. Ne te fie pas à ta mémoire de l'itération précédente.
3. **Prochaine tâche :** celle en `in_progress` s'il y en a une, sinon la première `todo` (ordre de l'index) dont toutes les dépendances sont `done`. Aucune tâche prête : arrêt avec la liste des tâches bloquées et leurs dépendances manquantes.
4. **Tâche `manual: true` sans confirmation cochée :** statut `blocked_manual` dans le fichier et l'index, affiche les actions à faire (section Étape manuelle du fichier de tâche et `docs/manual-setup.md`), affiche la commande de reprise : `/manual-done T-XX` puis `/batch`. Arrêt.
5. **Sinon :** applique à la lettre la procédure de `.claude/skills/task/SKILL.md` (préconditions, plan, implémentation, vérification, revue, clôture) jusqu'au commit.
6. **Action manuelle découverte en cours de tâche** (clé, compte, console, appareil réel, achat sandbox) : même traitement qu'au point 4, le travail reste dans l'arbre sans commit. Arrêt.
7. **Échec :** `make check` ou tests rouges après deux tentatives de correction, ou point Bloquant de revue non résolu après une correction : statut `in_progress`, arrêt, diagnostic en dix lignes (fichier, erreur, ce qui a été tenté). Jamais de contournement : pas de skip, pas d'ignore de lint, pas de policy assouplie, pas de spécification modifiée.
8. **Après chaque tâche :** une ligne de journal dans la conversation (ID, titre, nombre de tests ajoutés, verdict de revue, hash du commit), mise à jour de l'index, puis tâche suivante sans attendre de confirmation.
9. **Arrêt aussi** après N tâches, ou après T-XX si l'argument est fourni.
10. Une tâche `model: fable` exécutée dans une session d'un autre modèle est signalée dans le journal (« exécutée hors Fable »), sans arrêt.

## Interdits

`git push`, `/deploy`, modification de l'ordre ou des dépendances de l'index, passage à une tâche non prête, modification de plusieurs tâches dans un même commit, suppression d'un test pour passer au vert.

## Rapport final

- Tâches terminées avec leur hash de commit.
- Tâche et raison de l'arrêt.
- Actions manuelles à faire, dans l'ordre, avec renvoi au fichier de tâche.
- Commande suivante à lancer (`/manual-done T-XX` puis `/batch`, ou `/batch`, ou `/deploy dev`).
