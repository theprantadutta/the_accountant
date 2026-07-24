#!/usr/bin/env bash
#
# Toggle "simulator mode" for The Accountant.
#
# Google ML Kit ships no arm64 iOS-simulator slice, so the app can't be built
# for Apple Silicon iOS 26+ simulators while the google_mlkit_* packages are
# present. This script swaps the OCR service for a stub and removes the ML Kit
# dependencies so the app builds (arm64) and runs in the simulator. Receipt OCR
# is disabled in this mode (it needs a real camera anyway); everything else works.
#
#   tools/simulator_mode.sh on    # enter simulator mode (ML Kit stubbed out)
#   tools/simulator_mode.sh off   # restore the real ML Kit build (for device/release)
#
# "off" restores pubspec.yaml and ocr_service.dart from git, so commit or stash
# any unrelated changes to those files before toggling.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

OCR="lib/features/ai/services/ocr_service.dart"
STUB="tools/simulator_mode/ocr_service_stub.dart.tmpl"

usage() { echo "usage: $0 {on|off}"; exit 1; }
[ $# -eq 1 ] || usage

case "$1" in
  on)
    echo "==> Entering simulator mode (ML Kit stubbed out)…"
    cp "$STUB" "$OCR"
    # Comment out the three google_mlkit_* dependency lines.
    sed -i '' -E 's/^  (google_mlkit_[a-z_]+:)/  # SIMULATOR-MODE-DISABLED \1/' pubspec.yaml
    flutter pub get
    ( cd ios && pod install )
    echo ""
    echo "==> Simulator mode ON. Now run, e.g.:"
    echo "      flutter run -d \"iPhone 17\""
    echo "    Undo with: tools/simulator_mode.sh off"
    ;;
  off)
    echo "==> Restoring real ML Kit build…"
    git checkout -- "$OCR" pubspec.yaml
    flutter pub get
    ( cd ios && pod install )
    echo "==> Device/release mode restored (ML Kit active)."
    ;;
  *) usage;;
esac
