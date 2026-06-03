#!/usr/bin/env bash
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Agent-First Engineering Framework — Updater
#
# Pulls framework improvements into an already-installed project.
# Safe by design:
#   - Never touches CLAUDE.md, AGENTS.md, .mcp.json, session-notes.md
#   - Components you have NOT modified: updated in place
#   - Components you HAVE modified: left alone, reported, .new written beside
#
# Usage (copy-mode projects):
#   git clone https://github.com/matias-gentile/claude-code-framework.git /tmp/cf
#   cd your-project
#   bash /tmp/cf/update.sh
#   rm -rf /tmp/cf
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SOURCE_DIR="$SCRIPT_DIR"
TARGET_DIR="$(pwd)"

BOLD='\033[1m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
CYAN='\033[0;36m'; RED='\033[0;31m'; DIM='\033[2m'; RESET='\033[0m'

ok(){ echo -e "  ${GREEN}✅ $1${RESET}"; }
warn(){ echo -e "  ${YELLOW}⚠️  $1${RESET}"; }
info(){ echo -e "  ${DIM}$1${RESET}"; }
hdr(){ echo ""; echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"; echo -e "${BOLD}  $1${RESET}"; echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"; }

# ── Sanity: is this a framework-installed project? ──
if [ ! -d "$TARGET_DIR/.claude" ]; then
  echo -e "${RED}No .claude/ directory found here.${RESET}"
  echo "Run this from the root of a project where the framework was installed (copy mode)."
  echo "If you installed as a plugin, update via: /plugin uninstall then /plugin install."
  exit 1
fi

# ── Version comparison ──
hdr "Framework Update"
NEW_VER=$(python3 -c "import json;print(json.load(open('$SOURCE_DIR/.claude-plugin/plugin.json'))['version'])" 2>/dev/null || echo "unknown")
CUR_VER="none"
if [ -f "$TARGET_DIR/.claude/.framework-version" ]; then
  CUR_VER=$(cat "$TARGET_DIR/.claude/.framework-version")
fi
echo ""
echo -e "  Installed version: ${BOLD}${CUR_VER}${RESET}"
echo -e "  Available version: ${BOLD}${NEW_VER}${RESET}"

if [ "$CUR_VER" = "$NEW_VER" ]; then
  echo ""
  ok "Already up to date. Nothing to do."
  exit 0
fi

# ── Show changelog slice ──
if [ -f "$SOURCE_DIR/CHANGELOG.md" ]; then
  echo ""
  echo -e "  ${BOLD}What's new:${RESET}"
  # Print the top changelog entry block
  awk '/^## \[/{c++} c==1{print "  "$0} c==2{exit}' "$SOURCE_DIR/CHANGELOG.md" | head -30
fi

echo ""
read -rp "  Proceed with update? [Y/n]: " ans
[[ "$ans" =~ ^[Nn]$ ]] && { echo "  Cancelled."; exit 0; }

# ── Three-way component sync ──
hdr "Updating components"

MANIFEST="$SOURCE_DIR/.claude-plugin/manifest.txt"
if [ ! -f "$MANIFEST" ]; then
  warn "No manifest in source — cannot detect customizations safely. Aborting."
  exit 1
fi

UPDATED=0; SKIPPED=0; MODIFIED=0; NEW=0

# The manifest from the PREVIOUS installed version, if we saved it
OLD_MANIFEST="$TARGET_DIR/.claude/.framework-manifest"

while read -r new_hash relpath; do
  src="$SOURCE_DIR/$relpath"
  dst="$TARGET_DIR/.claude/$relpath"

  # File doesn't exist in target → brand new component → install it
  if [ ! -f "$dst" ]; then
    mkdir -p "$(dirname "$dst")"
    cp "$src" "$dst"
    [ "${relpath##*.}" = "sh" ] && chmod +x "$dst"
    ok "new: $relpath"
    NEW=$((NEW+1))
    continue
  fi

  cur_hash=$(sha256sum "$dst" | cut -d' ' -f1)

  # Already at new version → skip
  if [ "$cur_hash" = "$new_hash" ]; then
    SKIPPED=$((SKIPPED+1))
    continue
  fi

  # Did the user modify it? Compare against the OLD shipped hash.
  old_hash=""
  if [ -f "$OLD_MANIFEST" ]; then
    old_hash=$(grep -F "  $relpath" "$OLD_MANIFEST" 2>/dev/null | cut -d' ' -f1 || true)
  fi

  if [ -n "$old_hash" ] && [ "$cur_hash" = "$old_hash" ]; then
    # Unmodified by user (matches what we shipped) → safe to update
    cp "$src" "$dst"
    [ "${relpath##*.}" = "sh" ] && chmod +x "$dst"
    ok "updated: $relpath"
    UPDATED=$((UPDATED+1))
  else
    # User modified it (or we have no old hash to be sure) → DO NOT overwrite
    cp "$src" "$dst.new"
    warn "you customized $relpath — left as-is; new version saved as $relpath.new"
    MODIFIED=$((MODIFIED+1))
  fi
done < "$MANIFEST"

# ── Record new version + manifest for next time ──
echo "$NEW_VER" > "$TARGET_DIR/.claude/.framework-version"
cp "$MANIFEST" "$TARGET_DIR/.claude/.framework-manifest"

# ── Summary ──
hdr "Update Complete"
echo ""
ok "$UPDATED updated"
[ "$NEW" -gt 0 ] && ok "$NEW new components added"
info "$SKIPPED already current"
if [ "$MODIFIED" -gt 0 ]; then
  warn "$MODIFIED customized files left untouched (.new versions saved beside them)"
  echo ""
  info "Review each with:  diff <file> <file>.new"
  info "Keep yours: rm <file>.new   |   Take new: mv <file>.new <file>"
fi
# ── Remind about any unresolved collision artifacts from install ──
PENDING=$(find "$TARGET_DIR/.claude" -name "*.framework" 2>/dev/null | wc -l | tr -d ' ')
if [ "$PENDING" != "0" ]; then
  echo ""
  warn "$PENDING unresolved collision file(s) from a previous install (*.framework)"
  info "These are framework versions saved beside your customized components."
  info "Review with: find .claude -name '*.framework'"
fi

echo ""
echo -e "  Now at version ${BOLD}${NEW_VER}${RESET}."
echo -e "  ${DIM}Your CLAUDE.md, AGENTS.md, .mcp.json, and session-notes were not touched.${RESET}"
echo ""
