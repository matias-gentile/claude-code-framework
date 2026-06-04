---
name: curator
description: Consolidate and prune accumulated framework artifacts when they grow large or go stale. Compresses old session notes, flags superseded ADRs (without deleting them), and proposes removal of obsolete CLAUDE.md rules. Run occasionally when the project's memory feels heavy — never automatically. Each artifact type gets a different, safe treatment.
---

You are performing framework curation: keeping the project's accumulated memory
compact and current without destroying anything valuable. Each artifact type needs a
DIFFERENT treatment — do not apply one blanket "consolidate everything" pass.

Core principle (same as session-review): you DRAFT and PROPOSE; the human approves.
You never delete history or edit rules silently.

## Treatment 1 — session-notes.md (compress what's done)

Session notes are an append-only log whose only job is to carry context forward. Old
entries that have served their purpose can be compressed.

1. Read `.claude/session-notes.md`.
2. If it's under ~150 lines, report "session notes are still compact — nothing to do" and skip.
3. Otherwise, identify entries that are clearly complete (tasks marked done, decisions
   already promoted to ADRs, resolved questions).
4. Draft a compressed version: collapse completed sessions into a short rolling summary
   at the bottom under "## Archived Summary", keep the most recent 2-3 sessions and any
   open items verbatim at the top.
5. Show the user a before/after line count and the proposed compressed file. On approval,
   write it. Compression is safe here — these notes are working memory, not a permanent record.

## Treatment 2 — ADRs (mark status, never delete)

ADRs are valuable precisely because they're immutable. A reverted decision still records
that the approach was tried and why it was dropped. NEVER delete or merge ADRs.

1. List `.claude/adr/`.
2. For each ADR, determine its current relevance by reading the codebase and CLAUDE.md:
   - Still in force → leave it.
   - Replaced by a later decision → propose adding a status line at the top:
     `Status: Superseded by ADR-XXXX` (and a matching `Supersedes: ADR-YYYY` on the newer one).
   - No longer applicable but not replaced → propose `Status: Deprecated — <one-line reason>`.
3. Present the proposed status annotations. On approval, add ONLY the status lines —
   do not change the body of any ADR, do not delete any file.
4. If there are many ADRs (15+), offer to create `.claude/adr/INDEX.md` listing each ADR
   with its title and status, so the active ones are easy to find without reading all of them.

## Treatment 3 — CLAUDE.md (propose removal of stale rules, never auto-edit)

A stale rule is worse than no rule — the agent follows it blindly. But you cannot be sure
a rule is stale, so you PROPOSE removals and the human decides.

1. Read CLAUDE.md rule by rule.
2. Flag a rule as a removal CANDIDATE only with concrete evidence it's stale:
   - It references a file or directory that no longer exists.
   - It references a library, version, or API the codebase no longer uses.
   - It contradicts a more recent ADR or a more recent rule in the same file.
   - It duplicates another rule.
3. For each candidate, present:
   ```
   ━━ POSSIBLY STALE RULE ━━━━━━━━━━━━━━━━━━━━━━━━━━━
   Rule: "[exact text]"
   Evidence it may be stale: [the concrete finding above]
   Recommendation: remove / keep / rewrite as "[suggestion]"
   Remove this rule? [y/N]
   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   ```
4. Default to KEEP. Only remove on explicit confirmation. If unsure whether a rule is
   stale, do NOT flag it — false removals are worse than a slightly long file.
5. After approved removals, report the new line count against the 120-line budget.

## Treatment 4 — Skills & agents (report only)

Briefly note any skill or agent that hasn't plausibly been used (no references in
session notes, no matching ADRs). Do NOT propose deletion — just surface it so the human
knows it exists and can decide. Custom components the user added are theirs.

## Final report

```
━━ Curation Complete ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

session-notes: [compressed N→M lines / already compact]
ADRs:          [N marked superseded, N deprecated, N unchanged]
CLAUDE.md:     [N stale rules removed with approval / none found] — now X/120 lines
Observations:  [any unused components, for your awareness]

Nothing was deleted. ADR history is intact. Rules were removed only with your approval.
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

## Constraints
- Never delete an ADR or merge ADRs — only add status annotations.
- Never edit a CLAUDE.md rule without explicit per-rule approval; default to keep.
- session-notes compression is the only operation that rewrites a file substantially,
  and only with approval after showing the before/after.
- If nothing needs curation, say so honestly — "everything is still compact and current"
  is a valid and good result.
- This is a manual, occasional operation. Do not suggest automating it via a hook.
