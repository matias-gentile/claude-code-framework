---
description: Review this session and draft any lessons into permanent artifacts. Reads what happened, identifies rules for CLAUDE.md, decisions worth recording as ADRs, and workflows worth becoming skills — then drafts each one for your approval before writing. Run at the end of any non-trivial session.
---

You are running the end-of-session compounding loop review.

Your job is to look back at what happened this session and draft concrete artifacts — not ask vague questions. The human approves or edits each draft before it gets written. This is the difference between the framework getting smarter and the framework staying flat.

## Step 1 — Reconstruct what happened

Read recent context to understand the session:
- What task was worked on?
- What files were changed and why?
- What did Claude get wrong or have to be corrected on?
- What decisions were made (library choice, pattern, structure)?
- What workflows took multiple back-and-forth turns to get right?
- Were any bugs fixed? What caused them?

## Step 2 — Identify candidates

For each category, identify specific candidates. If none, say so — don't fabricate.

**Category A — CLAUDE.md rules**
A rule is worth adding if:
- Claude got something wrong and had to be corrected (it will get it wrong again next session without a rule)
- A project-specific convention was used that differs from language defaults
- A module boundary was enforced that Claude tried to cross

NOT worth adding if:
- Claude already follows it without being told
- The linter or TypeScript already enforces it
- It's a general best practice, not project-specific

**Category B — ADRs**
A decision is worth recording if:
- A library, pattern, or approach was chosen over alternatives
- A structural constraint was established
- Something was deliberately ruled out

NOT worth recording if:
- It was a tactical/implementation detail, not architectural
- It's already in an existing ADR

**Category C — New skills**
A workflow is worth making a skill if:
- It took 3+ back-and-forth turns to get right
- It will recur in future sessions
- The instructions are reusable, not task-specific

**Category D — Custom agents**
A custom agent is worth proposing if:
- A specific workflow appeared this session that required a distinct role (e.g., DB migrations, API client generation, localization)
- The workflow needed restricted tool access (read-only, write to specific directories only)
- It will recur across multiple sessions

NOT worth proposing if:
- A skill would cover it (skills are cheaper than agents — less context overhead)
- It's a one-time task that won't recur
- The existing 4 agents already handle it

## Step 3 — Draft artifacts

For each candidate identified, draft the actual artifact. Do not ask the human to write it — draft it yourself and ask for approval.

### For CLAUDE.md rules:
Present as:
```
━━ PROPOSED RULE FOR CLAUDE.md ━━━━━━━━━━━━━━━━━━━
Section: Architectural Rules

"[exact rule text — one line, specific, actionable]"

Why: [what happened this session that makes this necessary]
Budget: CLAUDE.md is currently [X] lines. Adding this → [X+1] lines.

Approve? [Y/n/edit]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

If approved: add to CLAUDE.md AND AGENTS.md under Architectural Rules.
If edited: use the human's version.
If rejected: skip.

### For ADRs:
Present as:
```
━━ PROPOSED ADR ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
File: .claude/adr/NNNN-[kebab-title].md

Title: [decision title]
Decision: [one sentence — what was decided]
Context: [why this decision was needed]
Alternatives considered: [what was ruled out and why]
Consequences: [trade-offs accepted]

Approve? [Y/n/edit]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

If approved: write the full ADR to `.claude/adr/` and add a one-line reference to CLAUDE.md and AGENTS.md.

### For new skills:
Present as:
```
━━ PROPOSED NEW SKILL ━━━━━━━━━━━━━━━━━━━━━━━━━━━━
File: .claude/skills/[name]/SKILL.md

name: [skill-name]
description: [when Claude should load this skill]

Content preview:
[first 10 lines of the skill body]

Approve? [Y/n/edit]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

If approved: create the full skill file.

### For custom agents:
Present as:
```
━━ PROPOSED NEW AGENT ━━━━━━━━━━━━━━━━━━━━━━━━━━━━
File: .claude/agents/[name].md

name: [agent-name]
description: [when to dispatch this agent]
tools: [only the tools it needs — least privilege]
model: claude-sonnet-4-20250514
isolation: worktree

Role summary:
[2-3 sentences describing what the agent does and what it cannot do]

Approve? [Y/n/edit]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

If approved: create the full agent file with output contract, turn contract, and escape hatch.
Add a reference to CLAUDE.md and AGENTS.md under Agent Workforce.

## Step 4 — Update session notes

After processing all candidates, update `.claude/session-notes.md`:
- Mark the session as reviewed
- Add a one-line summary of what was captured

## Step 5 — Final report

```
━━ Session Review Complete ━━━━━━━━━━━━━━━━━━━━━━━━

Captured:
  [N] rules added to CLAUDE.md
  [N] ADRs recorded in .claude/adr/
  [N] skills created in .claude/skills/
  [N] agents created in .claude/agents/

Skipped:
  [N] candidates rejected or not found

CLAUDE.md is now [X] lines ([120-X] remaining).

Safe to /clear.
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

## Constraints
- Never add a rule to CLAUDE.md if it would push past 120 lines — flag it and ask the human which existing rule to remove first
- Never fabricate decisions that weren't made this session
- If nothing worth capturing happened: say so clearly — "No candidates found this session" is a valid and honest result
- Present one candidate at a time — wait for approval before moving to the next
