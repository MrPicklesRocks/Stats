#!/bin/sh
set -eu

ROOT="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"
APP_SOURCE="$ROOT/.build/DerivedData/Build/Products/Debug/MacStats.app"
APP_DEST="/Applications/MacStats.app"

if [ ! -d "$APP_SOURCE" ]; then
  echo "Built app not found at $APP_SOURCE" >&2
  echo "Run scripts/build-signed.sh first." >&2
  exit 1
fi

pkill -x MacStats 2>/dev/null || true
rm -rf "$APP_DEST"
cp -R "$APP_SOURCE" "$APP_DEST"
open "$APP_DEST"
