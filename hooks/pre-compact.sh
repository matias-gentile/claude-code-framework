#!/usr/bin/env bash
# PreCompact hook: fires before conversation compaction.
# This is the moment to ensure durable state is written to disk BEFORE
# the context window is summarized away. Trust the data, not the prose.
#
# This hook can't write the handoff itself (it has no view of the
# conversation), so it injects a reminder to run the same handoff
# routine the /handoff command uses — keeping auto-compaction and
# manual handoff on one consistent format.

set -euo pipefail

echo '{"additionalContext": "Compaction is about to occur. Before context is summarized, produce a handoff: update the ## Handoff Notes section of .claude/session-notes.md with the NEXT STEP first, then current state, branch, test status, files touched, decisions, and any gotchas. Use the handoff skill format. Generate it from concrete facts (git status, test results, files changed), not from memory of the conversation."}'

exit 0
