# BetSafely

Application mobile Flutter (iOS et Android) qui aide les parieurs sportifs à faire attention à ce qu'ils misent : suivi des paris, budget, alertes, pause, aide. Freemium avec abonnement Premium (RevenueCat), backend Supabase, base locale drift, hors ligne d'abord.

## À lire avant d'agir

- `docs/architecture.md` : périmètre, navigation, features, couches, flux. Fait foi.
- `docs/database.md` : schéma SQL, RLS, Edge Functions. Fait foi.
- `docs/monetisation.md`, `docs/design-tokens.md`, `docs/workflow.md`, `docs/manual-setup.md`.
- `tasks/INDEX.md` puis le fichier de la tâche en cours. L'état vit dans ces fichiers, pas dans la conversation.
- Le brief produit (`brief.md`, hors dépôt) prime sur les docs pour les règles F-xx, N-xx, C-xx et P-xx.

## Commandes

`make setup`, `make gen`, `make format`, `make analyze`, `make test`, `make test-db`, `make test-functions`, `make test-integration`, `make check`, `make run-dev`, `make build-dev`, `make build-prod`. Toujours `make check` avant un commit.

## Stack

Flutter stable épinglé (`.fvmrc`), Dart strict, provider, go_router, freezed, drift, supabase_flutter, purchases_flutter et purchases_ui_flutter, flutter_local_notifications, l10n ARB. Flavors `dev` et `prod` via `--dart-define-from-file=env/<flavor>.json`.

## Règles absolues

- MUST respecter MVVM : View → ViewModel → Repository → Service, sens unique. Un ViewModel est un `ChangeNotifier`. MUST NOT utiliser Riverpod, BLoC, GetX ni aucun autre gestionnaire d'état.
- MUST NOT importer un SDK (`supabase_flutter`, `purchases_flutter`, `drift`, `flutter_local_notifications`, etc.) hors de `lib/data/services/` et `lib/config/`. Exception unique : `purchases_ui_flutter` dans `lib/data/services/purchases/`.
- MUST renvoyer `Result<T>` aux frontières de couche et exposer les actions des ViewModels en `Command`.
- MUST NOT écrire de chaîne affichée ni de couleur en dur : textes dans `lib/l10n/*.arb`, couleurs dans `lib/ui/core/theme/`.
- MUST stocker les montants en entiers d'unités mineures ; aucune conversion de devise, la devise est un symbole d'affichage.
- MUST appliquer C-01 à C-12 via `lib/domain/logic/bet_math.dart`, jamais réimplémentés ailleurs.
- MUST activer la RLS sur toute nouvelle table ; toute policy a son test pgTAP.
- MUST NOT mettre une clé `service_role`, un secret, une URL de projet réelle ni un identifiant RevenueCat réel dans le code ou les fichiers versionnés.
- MUST vérifier les droits Premium par l'entitlement `premium` uniquement, jamais par un identifiant de produit.
- MUST NOT envoyer une donnée de pari hors de l'appareil sans compte Premium synchronisé ; les images de scan ne sont jamais stockées ni journalisées.
- MUST NOT célébrer un gain (P-03), afficher une cote non saisie (P-02), ni lier un opérateur (P-01). Un gain s'affiche en `text-primary` avec « + », une perte en `negative` avec « − ».
- MUST NOT ajouter une fonctionnalité hors du périmètre de `docs/architecture.md`.
- MUST appliquer la politique de tests minimale de `.claude/rules/tests.md` ; aucun skip, aucun test désactivé.
- MUST écrire commentaires, commits et UI en français, identifiants de code en anglais, sans tiret cadratin ni demi-cadratin nulle part.
- MUST NOT exécuter `git push`, `git push --force`, `git reset --hard`, `supabase db reset --linked`, `rm -rf` hors `build/`, ni aucune commande d'envoi vers les stores.
- MUST committer sur `dev` uniquement ; `main` n'avance que par `make`-free `git merge --ff-only` dans `/deploy prod`.

## Conventions

- Organisation par feature sous `lib/ui/<feature>/{view_models,widgets}/` ; un ViewModel par écran ; `dispose` systématique des contrôleurs et listeners ; `const` dès que possible.
- Fichiers en `snake_case`, classes en `PascalCase`, un écran = `<feature>_screen.dart`, un ViewModel = `<feature>_view_model.dart`.
- Commits : `feat(T-XX): titre`, `fix(T-XX): titre`, `chore: titre`, `docs: titre`. Un commit par tâche, pas de push.
- Tests dans `test/` en miroir de `lib/`, fakes dans `test/testing/fakes/`.

## Vérification

`make check` enchaîne le formatage en mode vérification, l'analyse stricte, les scripts `scripts/check-*.sh` et les tests. `make test-db` et `make test-functions` quand `supabase/` change. Le hook Stop lance `flutter analyze`.
