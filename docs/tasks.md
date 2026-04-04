# Implementation Tasks

This is the execution breakdown for the next backend-focused milestone.

## Milestone A: Storage foundation (SQLite)

- [x] add `core/storage` SQLite layer and connection manager
- [x] define schema (`candidates`, `usage_events`, `settings`, `index_state`)
- [x] add migration system with schema versioning
- [x] add CRUD APIs for candidates and usage events
- [x] add unit tests for migration and basic read/write

## Milestone B: Unified engine model

- [ ] define shared `ResultKind` and `ActionKind` in core
- [ ] refactor engine query output to typed action results
- [ ] move calc evaluation logic from Swift to Rust core
- [ ] move shell command validation rules to core
- [ ] ensure result payloads can cross FFI boundary cleanly

## Milestone C: Indexing pipeline

- [x] implement app index source (`/Applications`, `/System/Applications`, `~/Applications`)
- [x] implement file/folder index source with root config defaults
- [x] add System Settings source from `.appex`/`.prefPane` discovery
- [ ] support exclude paths and hidden file policy
- [x] add startup full scan + snapshot upsert
- [x] persist index snapshots to SQLite

## Milestone D: Bridge and app integration

- [ ] finalize FFI API (`init`, `search`, `record_action`, `update_settings`)
- [x] switch SwiftUI launcher from seed data to engine results
- [x] wire action execution path (open app/path/web, run command)
- [ ] route settings updates to backend persistence
- [ ] add structured error mapping for UI feedback

## Milestone E: Ranking and safety

- [ ] log execution events to `usage_events`
- [ ] implement recency/frequency score boost
- [ ] apply shell safety policy (`sudo` warning, confirm mode option)
- [ ] add numeric guardrails for calc
- [ ] add tests for scoring and safety rules

## Milestone F: Performance and polish

- [ ] benchmark query latency and indexing throughput
- [ ] add in-memory cache for top-N results
- [ ] optimize startup path and background index scheduling
- [ ] add diagnostics/debug toggles for development
- [ ] update docs and user guide for finalized behavior

## Milestone G: Reliability (errors, tests, logs)

- [ ] add structured error model across engine/storage/ffi boundaries
- [ ] add safe user-facing fallback messages for action failures
- [ ] add unit tests for search scoring and empty-query top-picks behavior
- [ ] add unit tests for curated settings catalog integrity (id/title/target validity)
- [x] add storage tests for usage-event writes and candidate upsert semantics
- [ ] add ffi-level smoke tests for `look_search_json` and `look_record_usage`
- [ ] add debug logging hooks (startup indexing summary, query timing, action execution outcome)
- [ ] add a log-level toggle (`error`/`info`/`debug`) via env var for local troubleshooting
