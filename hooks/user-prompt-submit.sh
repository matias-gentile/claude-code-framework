#!/usr/bin/env bash
# UserPromptSubmit hook: fires when the user submits a prompt, before Claude processes it.
# stdout is added as context Claude sees with the prompt.
# Exit 2 blocks the prompt entirely.
#
# Two jobs:
#   1. Block prompts that contain obvious secrets (pre-guard)
#   2. Inject the relevant ADR when the prompt touches a decided area

set -euo pipefail

# Read the prompt from stdin (JSON)
INPUT=$(cat)
PROMPT=$(echo "$INPUT" | python3 -c "import sys,json; print(json.load(sys.stdin).get('prompt',''))" 2>/dev/null || echo "")

# ── Guard 1: block obvious secrets in the prompt ──
if echo "$PROMPT" | grep -qiE '(sk-ant-[a-zA-Z0-9_-]{20,}|ghp_[a-zA-Z0-9]{30,}|AKIA[A-Z0-9]{16}|-----BEGIN (RSA |EC )?PRIVATE KEY-----)'; then
  echo "BLOCKED: Your prompt appears to contain a secret (API key, token, or private key). Remove it and reference the credential by name instead." >&2
  exit 2
fi

# ── Guard 2: inject relevant ADR context ──
# If the prompt mentions a topic covered by an ADR, surface that ADR
ADR_DIR=".claude/adr"
[ -d "adr" ] && ADR_DIR="adr"

if [ -d "$ADR_DIR" ]; then
  # Extract meaningful words from the prompt (4+ chars)
  KEYWORDS=$(echo "$PROMPT" | tr '[:upper:]' '[:lower:]' | grep -oE '[a-z]{4,}' | sort -u | head -20)

  for adr in "$ADR_DIR"/*.md; do
    [ -f "$adr" ] || continue
    ADR_TITLE=$(grep -m1 "^# " "$adr" 2>/dev/null | sed 's/^# //' | tr '[:upper:]' '[:lower:]')
    # If any prompt keyword appears in the ADR title, surface it
    for kw in $KEYWORDS; do
      if echo "$ADR_TITLE" | grep -q "$kw"; then
        TITLE=$(grep -m1 "^# " "$adr" | sed 's/^# //')
        echo "Relevant decision on file: ${TITLE} (see ${adr}). Respect this decision unless the user explicitly asks to revisit it."
        exit 0
      fi
    done
  done
fi

exit 0
