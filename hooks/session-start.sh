#!/usr/bin/env bash
# SessionStart hook: fires when a session starts, resumes, or clears.
# stdout from this hook is added to Claude's context (per official docs).
# This is where we surface prior session state so the compounding loop closes.

set -euo pipefail

# The source tells us how the session began: startup, resume, clear, compact
SOURCE="${CLAUDE_HOOK_SOURCE:-startup}"

OUT=""

# 1. Current branch — cheap orientation
if git rev-parse --git-dir >/dev/null 2>&1; then
  BRANCH=$(git branch --show-current 2>/dev/null || echo "detached")
  OUT="${OUT}Current branch: ${BRANCH}. "
fi

# 2. Prior session notes — the handoff from last session (trust the data)
if [ -f ".claude/session-notes.md" ]; then
  # Extract just the Handoff Notes section if present
  HANDOFF=$(awk '/## Handoff Notes/{flag=1; next} /^## /{flag=0} flag' .claude/session-notes.md 2>/dev/null | head -20 | tr '\n' ' ')
  if [ -n "$HANDOFF" ] && [ "$HANDOFF" != " " ]; then
    OUT="${OUT}Handoff from last session: ${HANDOFF}. "
  fi
fi

# 3. Recent ADRs — surface decisions so they aren't reversed
if [ -d ".claude/adr" ] || [ -d "adr" ]; then
  ADR_DIR=".claude/adr"
  [ -d "adr" ] && ADR_DIR="adr"
  RECENT_ADR=$(ls -t "$ADR_DIR"/*.md 2>/dev/null | head -1)
  if [ -n "$RECENT_ADR" ]; then
    ADR_TITLE=$(grep -m1 "^# " "$RECENT_ADR" 2>/dev/null | sed 's/^# //' || true)
    if [ -n "$ADR_TITLE" ]; then
      OUT="${OUT}Most recent architectural decision: ${ADR_TITLE}. "
    fi
  fi
fi

# 4. Test command reminder if configured
if [ -f ".claude/hooks/.test-command" ]; then
  TEST_CMD=$(cat .claude/hooks/.test-command)
  OUT="${OUT}Test command: ${TEST_CMD}. "
fi

# Only emit if we have something useful (and not on compact, which already has context)
if [ -n "$OUT" ] && [ "$SOURCE" != "compact" ]; then
  echo "Framework context — ${OUT}Follow the 4-phase flow (Explore, Plan, Implement, Verify) for any multi-file task."
fi

exit 0
