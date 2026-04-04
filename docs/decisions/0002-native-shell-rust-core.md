# ADR 0002: Native shell + Rust core

## Status

Accepted

## Context

The launcher must be low-latency, keyboard-first, and native-feeling on macOS.

## Decision

- Use Swift/AppKit for launcher shell behavior.
- Use Rust for indexing, matching, ranking, and persistence-heavy logic.
- Keep shell/core interaction narrow via `bridge/ffi`.

## Consequences

- strong performance profile and deterministic core behavior
- clear separation of UI and engine concerns
- requires explicit ABI and memory ownership boundaries across FFI
