# look User Guide

look is a fast, keyboard-first launcher for macOS.

It helps you do three things quickly in one window:

- launch installed apps
- search local files and folders by name
- run quick commands (calculator and shell)

The interface is local-first, lightweight, and designed for low-friction daily use.

## What makes look different

- one focused launcher window instead of many utility apps
- keyboard-first workflow with instant mode switching
- transparent, blur-based UI that can be themed
- optional command mode for utility tasks without leaving context

## Core usage

### 1) Launch apps and find files

Type in the main search bar to filter results.

This includes:

- installed apps
- local files/folders (Desktop/Documents/Downloads)
- curated System Settings entries (for example display, network, bluetooth)

- press `Tab` to move down the list
- press `Shift+Tab` to move up the list
- press `Enter` to open the selected result

### 2) Web search handoff

If you want to search the web from the same query:

- press `Cmd+Enter`

Current default provider: Google.

### 3) Command mode

To enter command mode:

- type `/`

Command mode starts with `calc` selected by default.

In command mode:

- `Tab` / `Shift+Tab` switches command type
- `Enter` runs the current command input
- `Shift+Esc` exits command mode

Available commands:

- `calc`: evaluate math expressions
- `shell`: run shell commands

Examples:

- `2/5` -> `0.4000`
- `v9` -> `3.0000` (`v` maps to sqrt)
- `2 x 5` -> `10.0000` (`x` maps to `*`)

Math output formatting:

- 4 digits after decimal
- grouped thousands (example: `1,000,000.0000`)

Safety cues:

- shell input containing `sudo` shows an orange warning border

## Settings and customization

To open settings:

- press `Cmd+Shift+,`

Settings are shown inside the same launcher window and include:

- appearance: tint color, blur style, blur opacity
- background: image picker, layout mode, image blur, image opacity
- shortcuts: built-in documentation tab

Background image modes:

- `Center`
- `Fill`
- `Stretch`
- `Duplicate`

## Keyboard shortcuts reference

- `Tab`: next result / next command
- `Shift+Tab`: previous result / previous command
- `Enter`: open selected result or run active command
- `/`: enter command mode
- `Shift+Esc`: exit command mode
- `Cmd+Enter`: search query on Google
- `Cmd+Shift+,`: open/close settings panel

## What look is for

look is built for:

- users who prefer keyboard navigation
- fast app/file lookup without distractions
- quick command-style utility actions in one place

It is not trying to be a full plugin ecosystem or cloud assistant. The core goal is speed, clarity, and predictable local behavior.
