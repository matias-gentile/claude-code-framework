---
name: session-notes
description: Maintains structured session notes during work. Invoke at the start of any multi-step task to begin note-taking, and periodically during the task to update. Summaries and handoff documents are generated FROM these notes, not from context-window memory. Trust the data, not the prose.
---

# Session Notes

## Why This Exists
LLMs lose information as context grows. By writing structured notes to a file during work, you create a durable record that survives compaction, context limits, and session boundaries. When you need to summarize, hand off, or resume — generate from the notes file, not from memory.

## The Core Rule
**Trust the data, not the prose.** Never summarize a session from your context window. Always read `.claude/session-notes.md` and generate from that.

## When to Invoke This Skill
- At the START of any multi-step task (creates the notes file)
- After completing each major step (appends structured update)
- Before `/compact` (ensures nothing is lost to compaction)
- Before handing off to another agent or session
- When the quality-gate agent checks for completeness

## The Notes File

Location: `.claude/session-notes.md` (gitignored — local working memory, not committed)

### Creating Notes (start of task)

Write this structure to `.claude/session-notes.md`:

```markdown
# Session Notes — [date]

## Current Task
[one-line description]

## Plan
[paste or reference the planner's numbered task list]

## Progress Log
| # | Step | Status | Notes |
|---|------|--------|-------|
| 1 | [step from plan] | ⬜ pending | |
| 2 | [step from plan] | ⬜ pending | |

## Decisions Made
| Decision | Rationale | ADR? |
|----------|-----------|------|
| | | |

## Open Questions
- [ ] [anything unresolved]

## Files Changed
- [file path] — [what changed and why]

## Test Results
- [timestamp] — [pass/fail, which tests]

## Handoff Notes
[filled in at end of session — what the next session needs to know]
```

### Updating Notes (during work)

After completing each step:
1. Update the Progress Log status: ⬜ → ✅ (done) or ❌ (blocked)
2. Add any decisions to the Decisions table
3. Add changed files to Files Changed
4. Log test results

### Generating Summaries (end of session)

When asked to summarize, or when `/compact` is about to run:
1. READ `.claude/session-notes.md`
2. Generate the summary FROM the notes, not from your context
3. Fill in the Handoff Notes section
4. This file persists across compaction — your context does not

## What Goes in Notes vs. What Goes in ADRs

| In session notes | In an ADR |
|---|---|
| "Chose to refactor UserService first" | "We use the repository pattern for all DB access" |
| "Tests failed because of stale fixtures" | "We rejected Prisma in favour of Drizzle for X reason" |
| "Blocked on missing env var for Stripe" | "API versioning lives in the URL path, not headers" |

Session notes are ephemeral working memory. ADRs are permanent architectural decisions.

## Gitignore

Add this line to `.gitignore` if not already present:
```
.claude/session-notes.md
```
Session notes are working memory — they should not be committed.
