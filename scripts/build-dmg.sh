#!/bin/sh
set -eu

ROOT="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"
DERIVED_DATA_PATH="${DERIVED_DATA_PATH:-$ROOT/.build/DerivedData-dmg}"
CONFIGURATION="${CONFIGURATION:-Release}"
TOOLS_DIR="$ROOT/.build/tools"
CREATE_DMG_DIR="$TOOLS_DIR/create-dmg"
ARTIFACTS_DIR="$ROOT/.build/artifacts"
APP_PATH="$DERIVED_DATA_PATH/Build/Products/$CONFIGURATION/MacStats.app"
APP_OUTPUT_PATH="${APP_OUTPUT_PATH:-$ROOT/MacStats.app}"
DMG_PATH="${DMG_PATH:-$ROOT/MacStats.dmg}"
SKIP_CODE_SIGNING="${SKIP_CODE_SIGNING:-1}"
export SKIP_SWIFTLINT="${SKIP_SWIFTLINT:-1}"
export SKIP_WIDGET_VERSION_SCRIPT="${SKIP_WIDGET_VERSION_SCRIPT:-1}"

mkdir -p "$TOOLS_DIR" "$ARTIFACTS_DIR"

if [ "$SKIP_CODE_SIGNING" = "1" ]; then
  xcodebuild \
    -project "$ROOT/Stats.xcodeproj" \
    -scheme Stats \
    -configuration "$CONFIGURATION" \
    -destination 'platform=macOS,arch=x86_64' \
    -derivedDataPath "$DERIVED_DATA_PATH" \
    CODE_SIGNING_ALLOWED=NO \
    CODE_SIGNING_REQUIRED=NO \
    build
else
  xcodebuild \
    -project "$ROOT/Stats.xcodeproj" \
    -scheme Stats \
    -configuration "$CONFIGURATION" \
    -destination 'platform=macOS,arch=x86_64' \
    -derivedDataPath "$DERIVED_DATA_PATH" \
    build
fi

if [ ! -d "$APP_PATH" ]; then
  echo "Built app not found at $APP_PATH" >&2
  exit 1
fi

rm -rf "$APP_OUTPUT_PATH"
ditto "$APP_PATH" "$APP_OUTPUT_PATH"

mkdir -p "$(dirname "$DMG_PATH")"
rm -f "$DMG_PATH"
STAGING_DIR="$(mktemp -d "$ARTIFACTS_DIR/dmg-staging.XXXXXX")"
cleanup() {
  rm -rf "$STAGING_DIR"
}
trap cleanup EXIT INT TERM

ditto "$APP_OUTPUT_PATH" "$STAGING_DIR/MacStats.app"
ln -s /Applications "$STAGING_DIR/Applications"

hdiutil create \
  -volname "MacStats" \
  -srcfolder "$STAGING_DIR" \
  -ov \
  -format UDZO \
  "$DMG_PATH"

echo "$DMG_PATH"
