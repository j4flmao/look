# ADR 0003: Optional configurable web search

## Status

Accepted

## Context

Users want occasional web query handoff without turning the launcher into an online-first tool.

## Decision

- Keep local app/file/folder search as the default path.
- Add optional web-search action behind settings.
- Support configurable provider selection (`duckduckgo`, `google`, `bing`).

## Consequences

- user can keep strict local-first mode by leaving the option disabled
- a small settings surface is added for engine selection
- no cloud dependency is required for core local search behavior
