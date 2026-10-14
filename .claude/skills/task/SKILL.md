---
name: task
description: Exécute une tâche T-XX de tasks/ de bout en bout (préconditions, plan, implémentation par couche, tests, make check, revue, commit). Usage /task T-XX.
argument-hint: T-XX
disable-model-invocation: true
effort: high
---

# /task $0

Tu exécutes la tâche `$0` jusqu'à son commit, en suivant cette procédure à la lettre. L'état vit dans `tasks/INDEX.md` et `tasks/$0-*.md`, pas dans la conversation.

## 1. Préconditions

1. `git branch --show-current` est `dev`. Sinon, arrêt.
2. `git status --porcelain` est vide, ou les modifications appartiennent à `$0` déjà `in_progress` (reprise). Sinon, arrêt avec la liste des fichiers.
3. Lis `tasks/INDEX.md` et le fichier `tasks/$0-*.md`. Toutes les tâches de `depends_on` sont `done` dans l'index. Sinon, arrêt en nommant la dépendance manquante.
4. Si le frontmatter a `manual: true` et que la case « Confirmé par » de la section Étape manuelle n'est pas cochée : statut `blocked_manual` dans le fichier et l'index, affiche les actions à faire (fichier de tâche et `docs/manual-setup.md`), affiche la commande de reprise `/manual-done $0`, arrêt.
5. Si le frontmatter indique `model: fable` et que la session tourne sur un autre modèle, rappelle en une ligne que Fable 5.1 est conseillé, puis continue.
6. Passe le statut à `in_progress` dans le fichier et dans l'index.

## 2. Plan

Lis les documents cités dans Contexte. Rédige un plan en sous-tâches (une ligne chacune), par couche dans l'ordre : domaine, service, repository, ViewModel, écran, route, textes ARB. Ne commence pas à coder avant d'avoir le plan.

## 3. Implémentation

- Applique `.claude/rules/` (architecture, ui, data, supabase, monetisation, tests, securite).
- Écris les tests exigés par la politique **pendant** l'implémentation, rien de plus. Pas de test pour un getter, un constructeur, du code généré.
- `make gen` si des modèles freezed, json_serializable ou drift changent.
- Si une action manuelle apparaît en cours de route (clé, compte, console, appareil réel, achat sandbox) : laisse le travail dans l'arbre sans commit, statut `blocked_manual`, ajoute l'action à la section Étape manuelle du fichier de tâche et à `docs/manual-setup.md`, affiche les instructions, arrêt.

## 4. Vérification

1. `make check` (format en mode vérification, analyse, scripts de contrôle, tests). Rouge : corrige, relance. Aucun contournement (skip, ignore de lint, policy assouplie, spécification modifiée).
2. Les tests listés dans la section Tests de la tâche passent, avec la commande indiquée.
3. Si `supabase/` est touché : `make test-db` et `make test-functions`.
4. Coche la checklist Sécurité de la tâche (chaque case cochée ou « n/a »).

## 5. Revue

1. Lance l'agent `code-reviewer` sur `git diff` (arbre de travail contre `dev`), en lui donnant l'identifiant et l'objectif de la tâche.
2. Corrige tous les points Bloquant et Important. Les points Mineur sont corrigés si le coût est faible, sinon notés dans « Notes de revue ».
3. Si un point Bloquant a été corrigé, relance la revue. Boucle jusqu'à Verdict OK ou OK avec réserves.
4. Reporte le verdict et les réserves dans la section « Notes de revue » du fichier de tâche.

## 6. Clôture

1. Vérifie la Definition of Done ligne par ligne.
2. Statut `done` avec la date (AAAA-MM-JJ) dans le frontmatter et dans l'index (colonne « Terminé le »).
3. `git add -A` puis un commit unique : `feat($0): <titre de la tâche>` (ou `chore`/`fix` si la tâche l'indique). Pas de push.
4. Rapport en dix lignes au maximum : ce qui a été fait, tests ajoutés, verdict de revue, hash du commit, réserves, prochaine tâche suggérée.

## Interdits

`git push`, modification de `main`, modification d'une autre tâche que `$0`, ajout de fonctionnalité hors périmètre, ajout d'une dépendance non listée dans `docs/architecture.md`, skip ou désactivation d'un test, `// ignore:` d'un lint, assouplissement d'une policy RLS, modification du brief ou de `docs/` pour faire passer un test, commandes listées dans `CLAUDE.md`.
