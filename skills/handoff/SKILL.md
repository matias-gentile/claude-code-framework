---
name: handoff
description: Generate a complete, structured handoff document when context is filling up or work is being paused. Captures the next concrete step, current state, what's in progress, files touched, decisions made, and gotchas — so the next session (you tomorrow, or another person) can resume without re-deriving everything. Writes into session-notes so the SessionStart hook surfaces it automatically next session.
---

You are producing a HANDOFF: a self-contained record that lets whoever opens the next
session — future-you or a teammate — resume work immediately, without reading this entire
conversation. This runs when context is filling up, at the end of a work block, or before
switching tasks.

Trust the data, not the prose: build this from concrete facts (files, commands, test
results, decisions), not from a vague memory of the conversation.

## Step 1 — Gather the facts

Before writing, collect:
- The current branch (`git branch --show-current`) and working-tree state (`git status --short`).
- Which files were created/modified this session and the one-line reason for each.
- Test status: did the last run pass? (check `/tmp/claude-tests-passed` or the last test output).
- Any decisions made this session (and whether they're already recorded as ADRs).
- The single most important thing: what is the very next concrete action.

## Step 2 — Write the handoff into session-notes

Write (replacing any prior handoff) the `## Handoff Notes` section of `.claude/session-notes.md`.
**Order matters**: the SessionStart hook surfaces the first ~20 lines of this section next
session, so put the resume-critical information FIRST.

Use exactly this structure:

```markdown
## Handoff Notes
<!-- Updated <date> -->

**NEXT STEP:** <the single most concrete next action — a command to run, a function to
write, a bug to fix. Specific enough to act on without thinking.>

**Current state:** <one or two sentences: what works right now, what's half-done.>

**Branch:** <branch> (<clean / N files modified / N staged>)
**Tests:** <passing / failing: which / not run>

### In progress
- <task partially done> — <what's left>

### Files touched this session
- `<path>` — <why>

### Decisions made
- <decision> — <recorded as ADR-XXXX / not yet recorded>

### Do NOT
- <gotchas: approaches already tried that failed, things that look tempting but are wrong,
  constraints the next session must respect>

### Open questions
- <anything blocked or needing a human decision>
```

If a section has nothing, write "- none" rather than deleting the heading — the consistent
shape makes it scannable.

## Step 3 — Offer to record decisions and lessons

If Step 1 surfaced decisions not yet captured as ADRs, or rules worth keeping, remind the
user: "There are uncaptured decisions here — want me to run the session-review to record
them before you go?" The handoff preserves *working state*; session-review preserves
*permanent lessons*. They're complementary.

## Step 4 — Confirm

Tell the user the handoff is written to `.claude/session-notes.md`, and that the next
session will surface the NEXT STEP and current state automatically (via the SessionStart
hook). It's safe to `/clear` or close the session now.

## Constraints
- The NEXT STEP must be concrete and actionable — "continue working on auth" is useless;
  "add the password-reset email template in src/email/reset.ts, then wire it to
  AuthService.requestReset()" is a handoff.
- Replace the prior Handoff Notes section, don't append — stale handoffs mislead.
- Never invent state. If you're unsure whether something works, say "unverified" and tell
  the next session to check it first.
- Keep the resume-critical part (NEXT STEP + current state + branch + tests) in the first
  few lines so the SessionStart hook captures it.
