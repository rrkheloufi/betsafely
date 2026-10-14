---
name: review
description: Revue de code par l'agent code-reviewer sur le diff courant (/review) ou sur le commit d'une tâche (/review T-XX), avec synthèse par sévérité et verdict.
argument-hint: "[T-XX]"
effort: high
---

# /review $ARGUMENTS

1. Cible :
   - sans argument : `git diff dev` (arbre de travail, fichiers indexés ou non) ; si vide, le dernier commit `git show HEAD` ;
   - avec `T-XX` : le commit dont le message commence par `feat(T-XX)`, `fix(T-XX)` ou `chore(T-XX)` (`git log --grep`), affiché avec `git show`.
2. Lance l'agent `code-reviewer` avec la cible, l'identifiant de la tâche, son objectif et sa Definition of Done.
3. Restitue la sortie de l'agent sans la réécrire : Verdict, puis Bloquant, Important, Mineur, chaque point au format `fichier:ligne`, problème, correction attendue.
4. Ajoute une synthèse en trois lignes : nombre de points par sévérité, ce qui empêche le `done`, prochaine action (`/task T-XX` pour corriger, ou rien).
5. Ne corrige rien dans cette commande.
