#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
APP_DIR="$ROOT_DIR/apps/macos/LauncherApp"
SCHEME="Look"
CONFIGURATION="Debug"
DERIVED_DATA="$ROOT_DIR/.build/xcode"
APP_BUNDLE="$DERIVED_DATA/Build/Products/$CONFIGURATION/Look.app"

echo "[1/3] Killing existing Look.app processes"
pkill -x "Look" 2>/dev/null || true
sleep 0.5

echo "[2/3] Building macOS app ($CONFIGURATION)"
xcodebuild \
  -project "$APP_DIR/look-app.xcodeproj" \
  -scheme "$SCHEME" \
  -configuration "$CONFIGURATION" \
  -derivedDataPath "$DERIVED_DATA" \
  build

if [[ ! -d "$APP_BUNDLE" ]]; then
  echo "Build failed: app bundle not found at $APP_BUNDLE" >&2
  exit 1
fi

echo "[3/3] Launching Look.app"
open "$APP_BUNDLE"
