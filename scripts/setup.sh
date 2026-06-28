#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

if ! command -v flutter >/dev/null 2>&1; then
  echo "Flutter SDK not found. Install from https://docs.flutter.dev/get-started/install"
  exit 1
fi

if [ ! -d "android" ] || [ ! -d "ios" ]; then
  echo "Generating platform folders..."
  flutter create . --org in.drswift.diagnostics --project-name dr_swift_diagnostics
fi

flutter pub get
dart run build_runner build --delete-conflicting-outputs 2>/dev/null || true
flutter analyze

echo ""
echo "Setup complete. Run: flutter run --dart-define=ENV=dev"
