# Install From Source

This project is a Rust + Tauri desktop app with a Node/JS frontend. The Makefile in the repo wraps the common build and dev commands.

## Prerequisites

- Rust toolchain (Cargo)
  - Recommended: install via rustup (macOS/Linux):
    ```bash
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
    ```
  - Windows: install via rustup from https://rustup.rs/
- Node.js and npm (for workspace dependencies)
  - Node 18+ recommended.
- Platform build tools per Tauri requirements
  - macOS: Xcode Command Line Tools
  - Linux: required system packages for WebKitGTK and bundling
  - Windows: Visual Studio Build Tools (MSVC)
  - See: https://tauri.app/v2/guides/prerequisites

## Install Tauri CLI from Source

Install the Tauri CLI from the dev branch as requested:

```bash
cargo install --git https://github.com/tauri-apps/tauri --branch dev tauri-cli
```

## Build with the Makefile

From the repository root:

1) Install JS workspace dependencies (uses `npm ci`):
```bash
make deps
```

2) Build the app (release installers/bundles):
```bash
make build
```

- Shortcut: run both in one go:
  ```bash
  make deps && make build
  ```
- Note: this builds for your current host OS/arch by default (not a macOS universal binary).

Artifacts will be placed under:
- `src-tauri/target/release/bundle` (host build), or
- `src-tauri/target/<target-triple>/release/bundle` (when building for a specific target)

## Development

Run the app in development mode:
```bash
make dev
```

## Optional: Per‑Target / Universal Builds

- macOS arm64:
  ```bash
  make mac-arm64
  ```
- macOS x64:
  ```bash
  make mac-x64
  ```
- macOS universal (requires both macOS targets installed):
  ```bash
  cargo tauri build --target universal-apple-darwin
  ```
  You may need to add targets first:
  ```bash
  rustup target add x86_64-apple-darwin aarch64-apple-darwin
  ```
- Linux/Windows targets:
  ```bash
  make linux-x64
  make linux-arm64
  make windows-x64
  ```

## Advanced: Config and Extra Flags

The Makefile forwards optional flags:

- Use a specific Tauri config (e.g., release config):
  ```bash
  make build CONFIG=src-tauri/tauri.release.conf.json
  ```
- Pass additional Tauri args (e.g., `--debug`):
  ```bash
  make build TAURI_ARGS=--debug
  ```
