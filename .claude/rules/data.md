---
paths:
  - lib/data/**
---

# Règles de la couche données

## Services

- Un service par SDK, dans `lib/data/services/<sdk>/`. Il expose des `Future` et des `Stream`, lance ses exceptions natives, ne contient aucune règle métier, aucun cache, aucun état autre que la configuration.
- Le service est le seul endroit où le SDK est importé. Les types du SDK ne sortent pas du service : il renvoie des DTO de `lib/data/models/` ou des types Dart simples.
- `LocalDatabase` (drift) expose des DAO ; les requêtes agrégées (mois, filtres, recherche) sont des requêtes drift, pas des boucles Dart sur toute la table.

## Repositories

- Interface abstraite `XRepository` dans `x_repository.dart`, implémentation `XRepositoryImpl` dans `x_repository_impl.dart`, injectée par `lib/config/dependencies.dart`.
- Toute méthode faillible renvoie `Future<Result<T>>`. Les `Stream` servent à l'observation de la base locale.
- Mapping DTO → domaine dans le repository (ou un mapper dédié `x_mapper.dart`), jamais dans un service ni un ViewModel. Les modèles de domaine sont des `freezed`.
- Un repository ne connaît pas un autre repository. Ce qui combine plusieurs repositories est un use case (`record_bet`, `settle_bet`) ou un ViewModel.

## Cache et hors ligne

- La base locale fait foi. Toute écriture utilisateur est locale d'abord, marquée `dirty = true`, puis synchronisée si et seulement si l'utilisateur a un compte Premium synchronisé.
- Référentiels : instantané embarqué `assets/reference/snapshot.json` au premier lancement, puis rafraîchissement si `reference_version` distante est plus récente. Jamais d'appel réseau bloquant pour afficher un référentiel.
- Synchro : envoi par lots des lignes `dirty` (upsert sur `id`), récupération par curseur `server_updated_at`, application si `remote.updated_at >= local.updated_at`. La dernière écriture gagne, ligne par ligne.
- Aucune fonctionnalité locale n'attend le réseau. Scan, synchro, achats et compte affichent un message clair hors ligne (F-22).

## Erreurs

- Les exceptions des services sont traduites en `AppError` (`network`, `timeout`, `unauthorized`, `quotaExceeded`, `conflict`, `notFound`, `validation`, `unknown`) dans le repository. Jamais d'exception qui remonte au ViewModel.
- Les messages utilisateur sont choisis par la View à partir du type d'`AppError`, via l10n.
- Aucune donnée personnelle ni contenu de pari dans un log ou un événement Sentry. Les erreurs de `scan-ticket` ne contiennent jamais l'image.
