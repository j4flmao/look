# ADR 0006: SQLite as initial persistent storage

## Status

Accepted

## Context

`look` needs local persistence for indexed candidates, usage history, and settings with predictable migrations and easy debugging.

## Decision

- Use SQLite as the default storage backend in `core/storage`.
- Use schema migrations with explicit versioning from day one.
- Keep storage access behind Rust interfaces so alternative engines remain possible later.

## Consequences

- fast development velocity and strong tooling support
- sufficient performance for launcher workloads with proper indexing
- straightforward introspection and troubleshooting
- future swap to KV engines remains possible if profiling justifies it
