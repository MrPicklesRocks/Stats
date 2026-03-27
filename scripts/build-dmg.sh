#!/bin/sh
set -eu

ROOT="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"
DERIVED_DATA_PATH="${DERIVED_DATA_PATH:-$ROOT/.build/DerivedData-dmg}"
CONFIGURATION="${CONFIGURATION:-Release}"
TOOLS_DIR="$ROOT/.build/tools"
CREATE_DMG_DIR="$TOOLS_DIR/create-dmg"
ARTIFACTS_DIR="$ROOT/.build/artifacts"
APP_PATH="$DERIVED_DATA_PATH/Build/Products/$CONFIGURATION/MacStats.app"
DMG_PATH="${DMG_PATH:-$ROOT/MacStats.dmg}"

mkdir -p "$TOOLS_DIR" "$ARTIFACTS_DIR"

xcodebuild \
  -project "$ROOT/Stats.xcodeproj" \
  -scheme Stats \
  -configuration "$CONFIGURATION" \
  -destination 'platform=macOS,arch=x86_64' \
  -derivedDataPath "$DERIVED_DATA_PATH" \
  build

if [ ! -d "$APP_PATH" ]; then
  echo "Built app not found at $APP_PATH" >&2
  exit 1
fi

if [ ! -d "$CREATE_DMG_DIR" ]; then
  git clone --depth 1 https://github.com/create-dmg/create-dmg "$CREATE_DMG_DIR"
fi

mkdir -p "$(dirname "$DMG_PATH")"
rm -f "$DMG_PATH"

"$CREATE_DMG_DIR/create-dmg" \
  --volname "MacStats" \
  --background "$ROOT/Stats/Supporting Files/background.png" \
  --window-pos 200 120 \
  --window-size 500 320 \
  --icon-size 80 \
  --icon "MacStats.app" 125 175 \
  --hide-extension "MacStats.app" \
  --app-drop-link 375 175 \
  --no-internet-enable \
  "$DMG_PATH" \
  "$APP_PATH"

echo "$DMG_PATH"
