---
paths:
  - lib/**
---

# Architecture MVVM

## Couches et sens des dépendances

```
lib/ui/<feature>/widgets        View : widgets, aucune logique métier, ne connaît que son ViewModel
lib/ui/<feature>/view_models    ViewModel : ChangeNotifier, un par écran, ne connaît que des Repositories (et use cases)
lib/domain/use_cases            Use case : uniquement record_bet et settle_bet (partagés par plusieurs ViewModels)
lib/domain/logic                Logique pure : calculs, détecteurs, planificateurs. Aucun import Flutter ni SDK
lib/domain/models               Modèles métier freezed, immuables
lib/data/repositories           Repository : interface abstraite + implémentation, renvoie Result<T>, cache et hors ligne
lib/data/services               Service : enveloppe fine d'un SDK, sans état métier
lib/data/models                 DTO sérialisés (json_serializable)
lib/config                      Environnement, initialisation des SDK, injection (provider)
```

Imports autorisés :
- `lib/ui/**` importe `lib/ui/**`, `lib/domain/**`, `lib/data/repositories/**` (interfaces seulement, pour les types), `lib/utils/**`, `lib/l10n/**`, `lib/routing/**`. Jamais `lib/data/services/**` ni un SDK.
- `lib/ui/**/widgets/**` n'importe rien de `lib/data/**`.
- `lib/domain/**` importe `lib/domain/**` et `lib/utils/**` seulement. Jamais `package:flutter/`, jamais `lib/data/**`.
- `lib/data/repositories/**` importe `lib/data/**`, `lib/domain/**`, `lib/utils/**`.
- `lib/data/services/**` importe les SDK et `lib/data/models/**`.
- `supabase_flutter` et `purchases_flutter` ne sont importés que dans `lib/data/services/` et `lib/config/`. `purchases_ui_flutter` seulement dans `lib/data/services/purchases/`.

`scripts/check-architecture.sh` vérifie ces règles ; `make check` l'exécute.

## Patron ViewModel et Command

```dart
class BudgetViewModel extends ChangeNotifier {
  BudgetViewModel({required BudgetRepository budgets}) : _budgets = budgets {
    load = Command0(_load)..execute();
    setAmount = Command1(_setAmount);
  }

  final BudgetRepository _budgets;

  late final Command0<void> load;
  late final Command1<void, int> setAmount;

  Budget? _budget;
  Budget? get budget => _budget;          // état exposé en lecture seule

  Future<Result<void>> _load() async {
    final result = await _budgets.current();
    switch (result) {
      case Ok(:final value):
        _budget = value;
        notifyListeners();
        return const Result.ok(null);
      case Error(:final error):
        return Result.error(error);
    }
  }

  Future<Result<void>> _setAmount(int amountMinor) async { /* idem */ }
}
```

- `Command` expose `running`, `error`, `completed`, `execute` et `clearResult`. La View affiche un `Skeleton` sur `running`, un message sur `error`.
- Un ViewModel reçoit ses Repositories par constructeur, fournis par `lib/config/dependencies.dart` (`ChangeNotifierProvider`, `ProxyProvider`).
- Un ViewModel annule ses abonnements (`StreamSubscription.cancel`) et appelle `super.dispose()`.
- Aucune navigation dans un ViewModel : il expose un état, la View navigue.
- Pas de `BuildContext` dans un ViewModel.
