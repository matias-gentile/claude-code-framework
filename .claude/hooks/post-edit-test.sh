#!/usr/bin/env bash
# PostToolUse hook: runs after Write/Edit/MultiEdit
# IMPORTANT: This hook runs BETWEEN tool calls, not mid-edit.
# Do not use hooks to block individual edits — let Claude finish a pass first.

set -euo pipefail

CHANGED_FILE="${CLAUDE_TOOL_OUTPUT_FILE:-}"
MARKER="/tmp/claude-tests-passed"

# Only run if a test runner is configured
if [ ! -f ".claude/hooks/.test-command" ]; then
  exit 0
fi

TEST_CMD=$(cat .claude/hooks/.test-command)

# Run tests silently; surface failures only
if ! $TEST_CMD > /tmp/claude-test-output 2>&1; then
  echo "⚠️  Tests failed after edit. Claude will see this output and should fix before proceeding."
  cat /tmp/claude-test-output
  rm -f "$MARKER"
  exit 1
fi

# Mark passing for pre-commit hook
touch "$MARKER"
echo "✅ Tests passed."
