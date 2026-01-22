#!/bin/bash

# MTE Relay Client Flutter Plugin (CocoaPods) - Release Script
# Usage: ./release.sh 4.4.0

# --- CONFIGURATION ---
REPO_URL="https://github.com/Eclypses/mte-relay-client-flutter-pod"
PUBSPEC_PATH="pubspec.yaml"
PODSPEC_PATH="ios/mte_relay_client_plugin.podspec"
EXAMPLE_PUBSPEC_PATH="example/pubspec.yaml"
CHANGELOG_PATH="CHANGELOG.md"
BRANCH="develop"
# ---------------------

# 1. Validation
if [ -z "$1" ]; then
  echo "Error: No version supplied."
  echo "Usage: ./release.sh <new_version>"
  echo "Example: ./release.sh 4.4.0"
  exit 1
fi

# STRIP 'v' if the user accidentally typed it (e.g. v4.4.0 -> 4.4.0)
CLEAN_VERSION="${1#v}"
TAG_VERSION="v$CLEAN_VERSION"
DATE=$(date +%Y-%m-%d)

echo "🚀 Preparing release: $TAG_VERSION on $DATE"
echo ""

# 2. Update pubspec.yaml version
echo "📝 Updating $PUBSPEC_PATH..."
sed -i '' "s/^version: .*/version: $CLEAN_VERSION/" "$PUBSPEC_PATH"

# 3. Update podspec version
echo "📝 Updating $PODSPEC_PATH..."
sed -i '' "s/s.version[[:space:]]*= '[^']*'/s.version          = '$CLEAN_VERSION'/" "$PODSPEC_PATH"

# 4. Update example/pubspec.yaml git ref
echo "📝 Updating $EXAMPLE_PUBSPEC_PATH..."
sed -i '' "s/ref: .*/ref: $CLEAN_VERSION/" "$EXAMPLE_PUBSPEC_PATH"

# 5. Update CHANGELOG.md Headers
# NOTE: Requires a '## [Unreleased]' section in your CHANGELOG.md to work.
echo "📝 Updating $CHANGELOG_PATH..."
SEARCH="## \[Unreleased\]"
REPLACE="## [Unreleased]\\
\\
### Added\\
-\\
\\
### Changed\\
-\\
\\
### Fixed\\
-\\
\\
\\
## [$CLEAN_VERSION] - $DATE"

sed -i '' "s/$SEARCH/$REPLACE/" "$CHANGELOG_PATH"

# 6. Update CHANGELOG.md Reference Links
# Link format: [4.4.0]: .../releases/tag/v4.4.0
NEW_LINK="[$CLEAN_VERSION]: $REPO_URL/releases/tag/$TAG_VERSION"

echo "" >> "$CHANGELOG_PATH"
echo "$NEW_LINK" >> "$CHANGELOG_PATH"

# 7. Git Operations
echo ""
echo "📦 Committing changes..."
git add "$PUBSPEC_PATH" "$PODSPEC_PATH" "$EXAMPLE_PUBSPEC_PATH" "$CHANGELOG_PATH"
git commit -m "chore: bump version to $CLEAN_VERSION"

echo "🏷️  Tagging version $TAG_VERSION..."
git tag -a "$TAG_VERSION" -m "Release version $CLEAN_VERSION"

echo ""
echo "✅ Done! Validate the changes, then run:"
echo "   git push origin $BRANCH && git push origin $TAG_VERSION"
