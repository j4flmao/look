# ADR 0005: In-window settings and docs panel

## Status

Accepted

## Context

Theme customization and shortcut discoverability need to be available without leaving the launcher shell.

## Decision

- Provide a built-in settings panel in the same launcher window.
- Toggle panel with `Cmd+Shift+,`.
- Include tabs for appearance, background, and shortcuts documentation.

## Consequences

- users can tune theme and learn shortcuts in context
- no extra settings window lifecycle is required
- panel content can evolve into lightweight in-app documentation
