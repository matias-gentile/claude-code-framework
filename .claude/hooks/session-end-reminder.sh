#!/usr/bin/env bash
# NOTE: This script is no longer executed by the Stop hook.
# The Stop hook now uses type:prompt to inject a message directly
# into the Claude Code conversation (see settings.json).
#
# This file is kept as reference. You can safely delete it.
# The prompt in settings.json says:
#   "Session complete. Before /clear, run /project:session-review..."

echo "This script is not used — the Stop hook is now a prompt type."
echo "See .claude/settings.json for the active prompt."
