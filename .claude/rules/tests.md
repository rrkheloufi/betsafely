---
paths:
  - test/**
  - integration_test/**
  - supabase/tests/**
  - supabase/functions/**/*_test.ts
---

# Politique de tests : minimale et ciblée

Un test n'existe que s'il protège une règle métier ou un risque réel. Un comportement, un test, au niveau le plus bas qui le prouve.

## À tester

- **Logique pure** (`lib/domain/logic/`) : C-01 à C-12 et conversions de cote (tous obligatoires, brief 10), constats, détecteur de chasse aux pertes, planificateur de notifications, évaluateur de budget, calculs d'analyses et de récap. Tests paramétrés avec valeurs du brief et de `docs/design-tokens.md` (jeu de données d'exemple).
- **ViewModels** : transitions d'état (chargement, succès, erreur) et commandes, avec des fakes de repositories (`test/testing/fakes/`).
- **Repositories porteurs de logique** : mapping, cache, fusion de synchro, reprise d'erreur. Un repository qui relaie sans transformer n'est pas testé.
- **Widgets** : seulement les écrans critiques (saisie d'un pari AD-02, règlement BE-03, onboarding âge ON-02), sur le comportement (un tap produit un appel de commande, un message d'erreur apparaît), jamais sur le rendu.
- **RLS** : un test pgTAP par policy, prouvant le refus à un autre utilisateur, à l'anonyme Supabase, et le refus d'écriture sans entitlement.
- **Edge Functions** : chemin nominal et rejet principal (401 sans session ou sans secret, 400 sur entrée invalide, 200 sans effet sur événement dupliqué).
- **Intégration** : un unique `integration_test/critical_path_test.dart` (onboarding, saisie, règlement, mois), lancé avant chaque mise en production.

## Interdits

Golden tests ; tests de getters, de constructeurs, de code généré (freezed, drift, json_serializable) ; tests du framework ou des SDK ; doublons entre niveaux ; mock là où un fake suffit (`mocktail` réservé aux frontières SDK) ; `skip`, `@Skip`, test commenté ou désactivé ; `expect(true, isTrue)`.

## Fakes

- `test/testing/fakes/fake_<x>_repository.dart` : implémentation en mémoire de l'interface, avec des listes publiques pour injecter l'état et des compteurs d'appels. Un fake peut être configuré pour renvoyer `Result.error`.
- Pas de fake de service : les services ne sont pas testés, les repositories qui les enveloppent le sont via `mocktail` si nécessaire.

## Nommage

- `test/<chemin miroir>/<fichier>_test.dart`, `group` par méthode ou commande, `test('<comportement attendu en français>')`.
- pgTAP : `supabase/tests/<table>_rls_test.sql`, `supabase/tests/<fonction>_test.sql`.
- Deno : `supabase/functions/<name>/index_test.ts`.
