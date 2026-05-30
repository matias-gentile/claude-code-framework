#!/usr/bin/env bash
# PostToolUse hook: runs after Write/Edit/MultiEdit
# Runs ONLY the test file matching the edited file (fast).
# Falls back to full suite if no matching test found.

set -euo pipefail

CHANGED_FILE="${CLAUDE_TOOL_OUTPUT_FILE:-}"
MARKER="/tmp/claude-tests-passed"

# Only run if a test runner is configured
if [ ! -f ".claude/hooks/.test-command" ]; then
  exit 0
fi

TEST_CMD=$(cat .claude/hooks/.test-command)

# If we know which file changed, try to find its matching test
if [ -n "$CHANGED_FILE" ]; then
  BASENAME=$(basename "${CHANGED_FILE%.*}")

  # Look for matching test file (common patterns)
  MATCHING_TEST=$(find . -path ./node_modules -prune -o -path ./.git -prune -o \
    \( -name "${BASENAME}.test.*" -o -name "${BASENAME}.spec.*" -o -name "test_${BASENAME}.*" \) \
    -print 2>/dev/null | head -1)

  if [ -n "$MATCHING_TEST" ]; then
    # Run only the matching test (fast path)
    if $TEST_CMD "$MATCHING_TEST" > /tmp/claude-test-output 2>&1; then
      touch "$MARKER"
      exit 0
    else
      echo "⚠️  Test failed: $MATCHING_TEST"
      tail -20 /tmp/claude-test-output
      rm -f "$MARKER"
      exit 1
    fi
  fi
fi

# Fallback: run full suite (slow path — only when no matching test found)
if ! $TEST_CMD > /tmp/claude-test-output 2>&1; then
  echo "⚠️  Tests failed after edit."
  tail -20 /tmp/claude-test-output
  rm -f "$MARKER"
  exit 1
fi

touch "$MARKER"
exit 0
