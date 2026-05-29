#!/usr/bin/env bash
# PreToolUse hook: fires before Bash commands
# Only enforces the quality gate when the command is a git commit

set -euo pipefail

BASH_CMD="${CLAUDE_TOOL_INPUT_CMD:-}"
MARKER="/tmp/claude-tests-passed"

# Only gate git commits
if [[ "$BASH_CMD" != git\ commit* ]]; then
  exit 0
fi

# Require tests to have passed since last edit
if [ ! -f "$MARKER" ]; then
  echo "🚫 Commit blocked: tests have not passed since the last edit."
  echo "   Run tests first, or trigger the verification skill."
  exit 1
fi

# Remind about compounding loop
echo "💡 Before committing: should any lesson from this session go into CLAUDE.md, a skill, or an ADR?"
rm -f "$MARKER"
exit 0
