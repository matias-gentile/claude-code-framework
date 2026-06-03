#!/usr/bin/env bash
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Agent-First Engineering Framework — Installer
#
# Usage:
#   git clone https://github.com/matias-gentile/claude-code-framework.git /tmp/claude-framework
#   cd your-project
#   bash /tmp/claude-framework/install.sh
#   rm -rf /tmp/claude-framework
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

set -euo pipefail

# ── Where are the source files? ────────────────────
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SOURCE_DIR="$SCRIPT_DIR"
TARGET_DIR="$(pwd)"

# ── Colors ─────────────────────────────────────────
BOLD='\033[1m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
RED='\033[0;31m'
DIM='\033[2m'
RESET='\033[0m'

# ── Helpers ─────────────────────────────────────────
print_header() {
  echo ""
  echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
  echo -e "${BOLD}  $1${RESET}"
  echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
}

print_ok() {
  echo -e "  ${GREEN}✅ $1${RESET}"
}

print_warn() {
  echo -e "  ${YELLOW}⚠️  $1${RESET}"
}

print_info() {
  echo -e "  ${DIM}$1${RESET}"
}

confirm() {
  local prompt="$1"
  echo -en "  ${BOLD}→ $prompt${RESET} ${DIM}[Y/n]${RESET}: "
  read -r answer
  [[ "$answer" =~ ^[Nn]$ ]] && return 1 || return 0
}

ask() {
  local prompt="$1"
  local default="${2:-}"
  if [ -n "$default" ]; then
    echo -en "  ${BOLD}→ $prompt${RESET} ${DIM}[$default]${RESET}: "
  else
    echo -en "  ${BOLD}→ $prompt${RESET}: "
  fi
  read -r user_input
  if [ -z "$user_input" ] && [ -n "$default" ]; then
    echo "$default"
  else
    echo "$user_input"
  fi
}

ISSUES=()
COMPLETED=()

# ── Welcome ─────────────────────────────────────────
clear
echo ""
echo -e "${CYAN}${BOLD}"
cat << 'EOF'
   ___                _      ___ _          _
  / _ \__ _ ___ _ _ | |_   | __(_)_ _ ___ | |_
 | (_) / _` / -_) ' \|  _| | _|| | '_(_-<  _|
  \___/\__, \___|_||_|\__| |_| |_|_| /__/\__|
       |___/
  Engineering Framework — Installer
EOF
echo -e "${RESET}"
echo -e "  Installing into: ${BOLD}$TARGET_DIR${RESET}"
echo -e "  Source:           ${DIM}$SOURCE_DIR${RESET}"
echo ""
echo -e "  ${DIM}This will add the framework to your project."
echo -e "  Your existing files will NOT be overwritten.${RESET}"
echo ""
read -rp "  Press ENTER to start..."

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# STEP 1 — Check for existing .claude/ config
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
print_header "Step 1 of 5 — Checking for existing config"

if [ -d "$TARGET_DIR/.claude" ]; then
  if [ -f "$TARGET_DIR/.claude/settings.json" ] && ! grep -q "post-edit-test" "$TARGET_DIR/.claude/settings.json" 2>/dev/null; then
    echo ""
    echo -e "  ${YELLOW}You have an existing .claude/ config that wasn't created${RESET}"
    echo -e "  ${YELLOW}by this framework.${RESET}"
    echo ""
    if confirm "Back up .claude/ to .claude-backup/ before continuing?"; then
      cp -r "$TARGET_DIR/.claude" "$TARGET_DIR/.claude-backup"
      print_ok "Backed up to .claude-backup/"
      print_info "You can diff later: diff -r .claude-backup/ .claude/"
      COMPLETED+=("Existing .claude/ backed up")
    else
      print_warn "Existing .claude/ will be merged — some files may be overwritten"
      ISSUES+=("Existing .claude/ not backed up — check for conflicts")
    fi
  else
    print_ok "Existing .claude/ looks like a previous framework install — will update"
  fi
else
  print_ok "No existing .claude/ config found — clean install"
fi

COMPLETED+=("Existing config checked")

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# PRE-CHECK — Claude Code version
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

if command -v claude &>/dev/null; then
  CLAUDE_VER=$(claude --version 2>/dev/null | head -1 || echo "unknown")
  print_ok "Claude Code installed: ${CYAN}$CLAUDE_VER${RESET}"
else
  print_warn "Claude Code CLI not found in PATH"
  echo -e "  Install: ${CYAN}npm install -g @anthropic-ai/claude-code${RESET}"
  ISSUES+=("Claude Code CLI not installed")
fi
echo -e "  ${DIM}Slash commands require Claude Code v2.1.101+${RESET}"
echo -e "  ${DIM}Commands are invoked as /project:command-name${RESET}"

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# STEP 2 — Copy framework files
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
print_header "Step 2 of 5 — Installing framework files"

# Root files (only 3 — won't overwrite existing)
for f in CLAUDE.md AGENTS.md .mcp.json.example; do
  if [ -f "$TARGET_DIR/$f" ]; then
    print_warn "$f already exists — skipping (remove manually to replace)"
    ISSUES+=("$f not installed — already exists in project root")
  else
    cp "$SOURCE_DIR/$f" "$TARGET_DIR/$f"
    print_ok "$f"
  fi
done

# .claude/ directory (merge, don't destroy)
# Collision-aware: never overwrite a file the user already has. If a framework
# component collides with an existing file, install it as <name>.framework and
# flag it so the user can reconcile — their version is never silently replaced.
COLLISIONS=0
for subdir in agents skills hooks adr docs commands; do
  if [ -d "$SOURCE_DIR/$subdir" ]; then
    while IFS= read -r src; do
      rel="${src#$SOURCE_DIR/}"
      dst="$TARGET_DIR/.claude/$rel"
      mkdir -p "$(dirname "$dst")"
      if [ -f "$dst" ]; then
        # Compare — if identical, nothing to do; if different, it's a collision
        if ! cmp -s "$src" "$dst"; then
          cp "$src" "$dst.framework"
          [ "${src##*.}" = "sh" ] && chmod +x "$dst.framework" 2>/dev/null || true
          print_warn "collision: .claude/$rel exists — framework version saved as $rel.framework"
          ISSUES+=("$rel collided with your file — review $rel.framework")
          COLLISIONS=$((COLLISIONS+1))
        fi
      else
        cp "$src" "$dst"
        [ "${src##*.}" = "sh" ] && chmod +x "$dst" 2>/dev/null || true
      fi
    done < <(find "$SOURCE_DIR/$subdir" -type f 2>/dev/null)
    print_ok ".claude/$subdir/"
  fi
done
if [ "$COLLISIONS" -gt 0 ]; then
  print_info "$COLLISIONS component name collision(s) — your files kept, framework versions saved as *.framework"
fi

# settings.json — merge intelligently so the user's config is preserved
if [ ! -f "$TARGET_DIR/.claude/settings.json" ]; then
  cp "$SOURCE_DIR/.claude/settings.json" "$TARGET_DIR/.claude/settings.json"
  print_ok ".claude/settings.json"
elif grep -q "post-edit-test" "$TARGET_DIR/.claude/settings.json" 2>/dev/null; then
  # Previous framework install — safe to refresh
  cp "$SOURCE_DIR/.claude/settings.json" "$TARGET_DIR/.claude/settings.json"
  print_ok ".claude/settings.json (refreshed)"
else
  # User has their own settings.json — MERGE framework hooks/permissions in,
  # preserving everything they already have. This is what activates the
  # framework's hooks without clobbering the user's config.
  if command -v python3 &>/dev/null && [ -f "$SOURCE_DIR/.claude-plugin/merge-settings.py" ]; then
    cp "$TARGET_DIR/.claude/settings.json" "$TARGET_DIR/.claude/settings.json.pre-framework"
    MERGE_OUT=$(python3 "$SOURCE_DIR/.claude-plugin/merge-settings.py" \
      "$TARGET_DIR/.claude/settings.json" \
      "$SOURCE_DIR/.claude/settings.json" 2>&1)
    print_ok ".claude/settings.json (merged — backup at settings.json.pre-framework)"
    echo "$MERGE_OUT" | sed 's/^/      /'
  else
    print_warn ".claude/settings.json exists — python3 unavailable, cannot auto-merge"
    ISSUES+=("settings.json: merge framework hooks manually (see .claude/settings.json in the repo)")
  fi
fi


# Record framework version + manifest so update.sh has a baseline
if [ -f "$SOURCE_DIR/.claude-plugin/plugin.json" ]; then
  VER=$(python3 -c "import json;print(json.load(open('$SOURCE_DIR/.claude-plugin/plugin.json'))['version'])" 2>/dev/null || echo "unknown")
  echo "$VER" > "$TARGET_DIR/.claude/.framework-version"
  print_ok "Recorded framework version: $VER"
fi
if [ -f "$SOURCE_DIR/.claude-plugin/manifest.txt" ]; then
  cp "$SOURCE_DIR/.claude-plugin/manifest.txt" "$TARGET_DIR/.claude/.framework-manifest"
fi

COMPLETED+=("Framework files installed")

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# STEP 3 — Gitignore, hooks, MCP
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
print_header "Step 3 of 5 — Configuring project"

# Append to .gitignore (never overwrite)
GITIGNORE_ENTRIES=(
  ""
  "# Claude Code framework"
  ".mcp.json"
  ".claude/session-notes.md"
  ".claude/worktrees/"
  ".claude/settings.json.pre-framework"
  "*.framework"
)

if [ -f "$TARGET_DIR/.gitignore" ]; then
  for entry in "${GITIGNORE_ENTRIES[@]}"; do
    if [ -z "$entry" ]; then
      continue
    fi
    if ! grep -qF "$entry" "$TARGET_DIR/.gitignore" 2>/dev/null; then
      echo "$entry" >> "$TARGET_DIR/.gitignore"
    fi
  done
  print_ok ".gitignore updated (appended framework entries)"
else
  printf '%s\n' "${GITIGNORE_ENTRIES[@]}" > "$TARGET_DIR/.gitignore"
  print_ok ".gitignore created"
fi

# Make hooks executable
for hook in "$TARGET_DIR/.claude/hooks/"*.sh; do
  if [ -f "$hook" ]; then
    chmod +x "$hook"
  fi
done
print_ok "Hooks made executable"

# Copy .mcp.json from example if it doesn't exist
if [ ! -f "$TARGET_DIR/.mcp.json" ] && [ -f "$TARGET_DIR/.mcp.json.example" ]; then
  cp "$TARGET_DIR/.mcp.json.example" "$TARGET_DIR/.mcp.json"
  print_ok "Created .mcp.json from template (gitignored — your tokens stay local)"
fi

COMPLETED+=("Project configured")

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# STEP 4 — Test command
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
print_header "Step 4 of 5 — Test command"

TEST_CMD_FILE="$TARGET_DIR/.claude/hooks/.test-command"

if [ -f "$TEST_CMD_FILE" ] && [ -s "$TEST_CMD_FILE" ]; then
  existing_cmd=$(cat "$TEST_CMD_FILE")
  print_ok "Already configured: ${CYAN}$existing_cmd${RESET}"
  COMPLETED+=("Test command already configured")
else
  echo ""
  echo -e "  ${DIM}The automatic test hook needs to know what command runs"
  echo -e "  your test suite. This is whatever you'd type in the terminal"
  echo -e "  to run all tests. For example:${RESET}"
  echo ""
  echo -e "    npm test"
  echo -e "    npx vitest run"
  echo -e "    pytest"
  echo -e "    go test ./..."
  echo -e "    cargo test"
  echo -e "    make test"
  echo ""

  # Try auto-detect
  detected_cmd=""
  if [ -f "$TARGET_DIR/package.json" ]; then
    if grep -q '"vitest"' "$TARGET_DIR/package.json" 2>/dev/null; then
      detected_cmd="npx vitest run"
    elif grep -q '"jest"' "$TARGET_DIR/package.json" 2>/dev/null; then
      detected_cmd="npx jest"
    elif grep -q '"test"' "$TARGET_DIR/package.json" 2>/dev/null; then
      detected_cmd="npm test"
    fi
  elif [ -f "$TARGET_DIR/pyproject.toml" ] || [ -f "$TARGET_DIR/pytest.ini" ]; then
    detected_cmd="pytest"
  elif [ -f "$TARGET_DIR/Cargo.toml" ]; then
    detected_cmd="cargo test"
  elif [ -f "$TARGET_DIR/go.mod" ]; then
    detected_cmd="go test ./..."
  elif [ -f "$TARGET_DIR/Makefile" ] && grep -q "^test:" "$TARGET_DIR/Makefile" 2>/dev/null; then
    detected_cmd="make test"
  fi

  if [ -n "$detected_cmd" ]; then
    print_info "Auto-detected: ${CYAN}$detected_cmd${RESET}"
  fi

  test_cmd=$(ask "Your test command" "$detected_cmd")

  if [ -n "$test_cmd" ]; then
    echo "$test_cmd" > "$TEST_CMD_FILE"
    print_ok "Saved: $test_cmd"
    COMPLETED+=("Test command configured: $test_cmd")
  else
    print_warn "Skipped — create .claude/hooks/.test-command manually later"
    ISSUES+=("Test command not configured — hooks will be inactive")
  fi
fi

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# STEP 5 — Optional: GitHub Actions
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
print_header "Step 5 of 5 — GitHub Actions (optional)"

echo ""
echo -e "  ${DIM}The framework includes a GitHub Actions workflow that"
echo -e "  automatically reviews PRs using Claude (~\$0.04/review).${RESET}"
echo ""

if confirm "Add automated Claude PR review to this project?"; then
  mkdir -p "$TARGET_DIR/.github/workflows"
  cp "$SOURCE_DIR/.github/workflows/claude-pr-review.yml" \
     "$TARGET_DIR/.github/workflows/claude-pr-review.yml"
  print_ok "Workflow added"
  echo ""
  echo -e "  ${BOLD}To activate it:${RESET}"
  echo -e "  1. Go to your GitHub repo → Settings → Secrets → Actions"
  echo -e "  2. Add secret: ${CYAN}ANTHROPIC_API_KEY${RESET} (starts with sk-ant-...)"
  echo -e "  3. Comment ${CYAN}@claude${RESET} on any PR to trigger a review"
  COMPLETED+=("GitHub Actions PR review added")
else
  print_info "Skipped — add later from the framework repo"
fi

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# SUMMARY
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
print_header "Installation Complete"

echo ""
if [ ${#COMPLETED[@]} -gt 0 ]; then
  echo -e "  ${GREEN}${BOLD}Done:${RESET}"
  for item in "${COMPLETED[@]}"; do
    echo -e "  ${GREEN}✅ $item${RESET}"
  done
fi

echo ""
if [ ${#ISSUES[@]} -gt 0 ]; then
  echo -e "  ${YELLOW}${BOLD}Needs attention:${RESET}"
  for issue in "${ISSUES[@]}"; do
    echo -e "  ${YELLOW}⚠️  $issue${RESET}"
  done
fi

# ─── Next steps ───────────────────────────────────────
echo ""
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
echo -e "${BOLD}  Next steps${RESET}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
echo ""
echo -e "  ${BOLD}1. Clean up the cloned framework:${RESET}"
echo -e "     ${CYAN}rm -rf /tmp/claude-framework${RESET}"
echo ""
echo -e "  ${BOLD}2. Open Claude Code in your project:${RESET}"
echo -e "     ${CYAN}claude${RESET}"
echo ""
echo -e "  ${BOLD}3. Let Claude scan your codebase and fill in placeholders:${RESET}"
echo -e "     ${CYAN}/project:setup${RESET}"
echo ""
echo -e "  ${BOLD}4. Run the interactive tutorial (20 min):${RESET}"
echo -e "     ${CYAN}/project:tutorial${RESET}"
echo ""
echo -e "  ${DIM}Full docs: .claude/docs/README.md${RESET}"
echo -e "  ${DIM}Interactive guide: open .claude/docs/guide.html in a browser${RESET}"
echo ""
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
echo ""
