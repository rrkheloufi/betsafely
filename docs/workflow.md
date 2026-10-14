# Workflow de développement avec Claude Code

## Cycle

1. `/next` : affiche la prochaine tâche prête (toutes ses dépendances `done`) et les tâches en cours ou bloquées.
2. `/task T-XX` : exécute une tâche jusqu'à son commit (plan, implémentation par couche, tests, `make check`, revue par `code-reviewer`, clôture). Ou `/batch` pour enchaîner les tâches prêtes sans intervention, jusqu'à la première action manuelle, un échec, N tâches ou T-XX.
3. Action manuelle (jeton à déposer dans `secrets/`, fiche app à créer, appareil réel, achat sandbox, relecture native) : la tâche passe en `blocked_manual`, les instructions sont dans le fichier de tâche et `docs/manual-setup.md`. Une fois faite : `/manual-done T-XX` (coche la confirmation, vérifie la présence des jetons sans les lire, relance la tâche), puis `/batch`. Tout ce qu'une API permet est fait par `scripts/ops/` : Claude ne renvoie jamais vers une console quand un jeton suffit.
4. `/test [T-XX]`, `/review [T-XX]`, `/status` à tout moment.
5. `/db new|test|diff|push` pour les migrations sur le projet dev.
6. `/deploy dev` quand une série de tâches est terminée : migrations et fonctions sur le projet dev, build dev, push de `dev`.
7. `/deploy prod` pour une version : version et build incrémentés, test d'intégration, confirmation explicite, migrations et fonctions prod, `main` avancée en fast-forward, tag, builds release signés. Puis `/ops upload`, `/ops metadata` et `/ops submit X.Y.Z` (phrase de confirmation) pour l'envoi et la soumission aux stores.
8. `/ops <service>` pour provisionner ou reprovisionner un service par script (Supabase, RevenueCat, Apple, Play, observabilité, Brevo).

## Statuts

| Statut | Sens |
|---|---|
| `todo` | Non commencée |
| `in_progress` | En cours, ou arrêtée sur un échec à diagnostiquer |
| `blocked_manual` | En attente d'une action manuelle de Rayan |
| `done` | Terminée, commitée, date dans le frontmatter et dans l'index |

L'état vit dans `tasks/INDEX.md` et dans le frontmatter de chaque tâche. Les deux doivent rester identiques (`scripts/check-tasks.sh`).

## Modèle et effort par skill

| Skill | Invocation par Claude | Effort | Modèle |
|---|---|---|---|
| `/task` | désactivée | high | celui de la session ; Fable 5.1 conseillé si la tâche est `model: fable` |
| `/batch` | désactivée | high | idem |
| `/manual-done` | désactivée | medium | session |
| `/db` | désactivée | medium | session |
| `/deploy` | désactivée | high | session |
| `/ops` | désactivée | high | session ; Fable 5.1 conseillé pour `submit` et `apple` |
| `/test` | autorisée | low | session |
| `/review` | autorisée | high | agent `code-reviewer` en Fable 5.1 |
| `/next`, `/status` | autorisée | low | session |

L'agent `code-reviewer` tourne toujours en Fable 5.1, en lecture seule.

## Bonnes pratiques de session

- Lancer `/batch` dans une session Fable 5.1 quand les tâches suivantes sont majoritairement marquées `fable` (RLS, auth et liens profonds, webhook, suppression de compte, synchro, notifications en arrière-plan). Opus 5.5 convient pour le reste.
- Une tâche par session suffit pour les tâches L ; `/batch` convient aux séries de S et M.
- Avant `/batch`, vérifier avec `/next` que la série ne bute pas sur une tâche manuelle évitable : faire les actions manuelles en avance (phase 1 du graphe).
- Ne jamais pousser depuis Claude : `git push` est réservé à Rayan, sauf dans `/deploy`.
- Si une tâche échoue deux fois, lire le diagnostic, corriger la spécification de la tâche si elle est en cause, puis relancer `/task T-XX`.
- Le hook Stop lance `flutter analyze` à chaque fin de tour une fois le projet créé ; un tour qui se termine sur une analyse rouge est à corriger avant de continuer.
- `/compact` entre deux tâches longues ; la reprise se fait depuis les fichiers, pas depuis la conversation.
