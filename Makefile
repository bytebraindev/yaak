SHELL := /bin/bash

# Tools (override if needed, e.g. `make build TAURI='~/.cargo/bin/cargo tauri'`)
NPM ?= npm
TAURI ?= cargo tauri
CARGO ?= cargo

# Locations
ROOT := $(CURDIR)
TAURI_DIR := $(ROOT)/src-tauri

# Extra args you can pass to Tauri, e.g. `make build TAURI_ARGS=--debug`
TAURI_ARGS ?=
# Optional extra config path, e.g. `make build CONFIG=src-tauri/tauri.release.conf.json`
CONFIG ?=

.PHONY: help deps install bootstrap icons dev build check clean \
        mac-arm64 mac-x64 linux-x64 linux-arm64 windows-x64

.DEFAULT_GOAL := help

help: ## Show available targets
	@awk 'BEGIN {FS = ":.*##"; printf "\nTargets:\n"} /^[a-zA-Z0-9_.-]+:.*##/ { printf "  %-18s %s\n", $$1, $$2 }' $(MAKEFILE_LIST)

deps install: ## Install JS deps (uses npm ci)
	@echo "Installing JS dependencies..."
	$(NPM) ci

bootstrap: ## Vendor toolchain/plugins and bootstrap workspaces
	$(NPM) run bootstrap

icons: ## Generate app icons
	$(NPM) run icons

dev: ## Run Tauri in dev mode (cargo tauri)
	$(TAURI) dev --no-watch --config ./src-tauri/tauri.development.conf.json $(TAURI_ARGS)

build: ## Build release installers via cargo tauri
	$(TAURI) build $(TAURI_ARGS) $(if $(CONFIG),--config $(CONFIG),)

check: ## Cargo check the Rust code
	$(CARGO) check --manifest-path $(TAURI_DIR)/Cargo.toml

clean: ## Remove build artifacts and vendored assets
	@echo "Cleaning artifacts..."
	rm -rf $(TAURI_DIR)/target dist $(TAURI_DIR)/vendored

# Convenience cross-target builds (requires appropriate toolchains)
mac-arm64: ## Build for macOS arm64
	$(TAURI) build --target aarch64-apple-darwin $(TAURI_ARGS) $(if $(CONFIG),--config $(CONFIG),)

mac-x64: ## Build for macOS x64
	$(TAURI) build --target x86_64-apple-darwin $(TAURI_ARGS) $(if $(CONFIG),--config $(CONFIG),)

linux-x64: ## Build for Linux x64
	$(TAURI) build --target x86_64-unknown-linux-gnu $(TAURI_ARGS) $(if $(CONFIG),--config $(CONFIG),)

linux-arm64: ## Build for Linux arm64
	$(TAURI) build --target aarch64-unknown-linux-gnu $(TAURI_ARGS) $(if $(CONFIG),--config $(CONFIG),)

windows-x64: ## Build for Windows x64
	$(TAURI) build --target x86_64-pc-windows-msvc $(TAURI_ARGS) $(if $(CONFIG),--config $(CONFIG),)
