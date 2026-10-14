# BetSafely · commandes de développement
# FVM si présent, sinon flutter et dart du PATH.
SHELL := /bin/bash
ifneq (,$(wildcard .fvmrc))
  ifneq (,$(shell command -v fvm 2>/dev/null))
    FLUTTER := fvm flutter
    DART := fvm dart
  else
    FLUTTER := flutter
    DART := dart
  endif
else
  FLUTTER := flutter
  DART := dart
endif

HAS_PUBSPEC := $(wildcard pubspec.yaml)
FUNCTIONS := $(wildcard supabase/functions/*/index_test.ts)

.PHONY: setup gen format format-check analyze test test-db test-functions test-integration check checks run-dev build-dev build-prod clean help

help: ## Liste des commandes
	@grep -E '^[a-zA-Z_-]+:.*?## ' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  %-18s %s\n", $$1, $$2}'

setup: ## Dépendances Flutter et scripts exécutables
	chmod +x scripts/*.sh .claude/hooks/*.sh
ifneq (,$(HAS_PUBSPEC))
	$(FLUTTER) pub get
endif

gen: ## Génération de code (freezed, json_serializable, drift, l10n)
ifneq (,$(HAS_PUBSPEC))
	$(FLUTTER) gen-l10n
	$(DART) run build_runner build --delete-conflicting-outputs
endif

format: ## Formate lib/ test/ integration_test/
ifneq (,$(HAS_PUBSPEC))
	$(DART) format lib test integration_test
endif

format-check: ## Vérifie le formatage sans modifier
ifneq (,$(HAS_PUBSPEC))
	$(DART) format --output=none --set-exit-if-changed lib test integration_test
endif

analyze: ## Analyse stricte
ifneq (,$(HAS_PUBSPEC))
	$(FLUTTER) analyze --no-pub
endif

checks: ## Scripts de contrôle (tirets, couleurs, architecture, chaînes, tâches)
	scripts/check-no-dash.sh
	scripts/check-no-hex.sh
	scripts/check-architecture.sh
	scripts/check-strings.sh
	scripts/check-tasks.sh

test: ## Tests unitaires et widgets
ifneq (,$(HAS_PUBSPEC))
	$(FLUTTER) test --no-pub
endif

test-db: ## Tests pgTAP sur la base locale (Docker)
	@if [ -d supabase/tests ] && ls supabase/tests/*.sql >/dev/null 2>&1; then \
	  supabase start >/dev/null 2>&1 || true; \
	  supabase test db --local; \
	else echo "Aucun test pgTAP"; fi

test-functions: ## Tests Deno des Edge Functions
	@if [ -n "$(FUNCTIONS)" ]; then \
	  for t in $(FUNCTIONS); do (cd $$(dirname $$t) && deno test --allow-env --allow-net --allow-read); done; \
	else echo "Aucun test de fonction"; fi

test-integration: ## Parcours critique sur un appareil ou un émulateur
ifneq (,$(HAS_PUBSPEC))
	$(FLUTTER) test integration_test/critical_path_test.dart --flavor dev --dart-define-from-file=env/dev.json
endif

check: format-check analyze checks test ## Vérification complète avant commit

run-dev: ## Lance le flavor dev
	$(FLUTTER) run --flavor dev --dart-define-from-file=env/dev.json -t lib/main_dev.dart

build-dev: ## APK debug du flavor dev
	$(FLUTTER) build apk --debug --flavor dev --dart-define-from-file=env/dev.json -t lib/main_dev.dart

build-prod: ## Builds release signés (appbundle et ipa) du flavor prod
	$(FLUTTER) build appbundle --release --flavor prod --dart-define-from-file=env/prod.json -t lib/main_prod.dart
	$(FLUTTER) build ipa --release --flavor prod --dart-define-from-file=env/prod.json -t lib/main_prod.dart

clean: ## flutter clean
ifneq (,$(HAS_PUBSPEC))
	$(FLUTTER) clean
endif
