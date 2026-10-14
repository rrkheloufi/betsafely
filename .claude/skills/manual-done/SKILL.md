---
name: manual-done
description: Confirme qu'une étape manuelle de T-XX a été faite, vérifie ce qui est automatisable, repasse la tâche en in_progress et relance /task. Usage /manual-done T-XX.
argument-hint: T-XX
disable-model-invocation: true
effort: medium
---

# /manual-done $0

1. Lis `tasks/$0-*.md`. La tâche doit être `blocked_manual` (ou `todo` avec `manual: true`). Sinon, dis-le et arrête.
2. Coche la case « Confirmé par (date : AAAA-MM-JJ) » de la section Étape manuelle avec la date du jour.
3. Exécute les vérifications automatisables listées dans la section Étape manuelle (par exemple : présence de `env/dev.json` avec les clés attendues, sans en afficher les valeurs ; `supabase status` ; `flutter doctor` ; existence d'un fichier). Une vérification qui échoue : décoche la case, affiche ce qui manque, arrêt.
4. Mets le statut à `in_progress` dans le fichier et dans `tasks/INDEX.md`.
5. Relance la procédure de `.claude/skills/task/SKILL.md` pour `$0` à partir de l'étape 2 (plan).

Ne lis jamais le contenu d'un fichier de secrets ; vérifie seulement son existence et la présence des clés attendues (`jq 'keys'`).
