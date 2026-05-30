#!/usr/bin/env bash
# PreCompact hook: fires before conversation compaction.
# This is the moment to ensure durable state is written to disk BEFORE
# the context window is summarized away. Trust the data, not the prose.
#
# This hook can't write the notes itself (it has no view of the conversation),
# but it injects a reminder so Claude writes session-notes before compaction.

set -euo pipefail

echo '{"additionalContext": "Compaction is about to occur. Before context is summarized, update .claude/session-notes.md with: (1) current task status, (2) any decisions made, (3) files changed, (4) what the next session needs to know. Generate the summary from concrete facts, not from memory of the conversation."}'

exit 0
