#!/usr/bin/env bash
# Stop hook: PASSIVE notice only. Must not cause Claude to respond.
# Emits a systemMessage that Claude Code shows in the UI without the
# model evaluating it as an instruction. This avoids the type:prompt
# anti-pattern where the model reasons about whether to act and can error.

# Stop hooks must output only {} or {"systemMessage":"..."} on exit 0.
printf '{"systemMessage":"Tip: when this session wraps up, run the session-review command to capture lessons as rules, ADRs, or skills."}'
exit 0
