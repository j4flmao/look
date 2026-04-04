#!/usr/bin/env bash
set -euo pipefail

echo "Checking Rust toolchain"
rustup show active-toolchain >/dev/null

echo "Checking Rust workspace"
cargo check --manifest-path core/Cargo.toml --workspace

echo "Checking FFI bridge"
cargo check --manifest-path bridge/ffi/Cargo.toml

echo "Bootstrap complete"
