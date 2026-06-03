#!/usr/bin/env bash
# Maintainer tool: regenerate the component manifest before publishing a release.
# Records a hash of every framework-managed component file.
set -euo pipefail
cd "$(dirname "$0")/.."

MANIFEST=".claude-plugin/manifest.txt"
: > "$MANIFEST"

# Framework-managed component paths (NOT user content like CLAUDE.md or session-notes)
for dir in agents skills commands hooks; do
  find "$dir" -type f \( -name "*.md" -o -name "*.sh" -o -name "*.json" \) 2>/dev/null | sort | while read -r f; do
    hash=$(sha256sum "$f" | cut -d' ' -f1)
    echo "$hash  $f" >> "$MANIFEST"
  done
done

echo "Manifest written: $(wc -l < "$MANIFEST") files tracked"
