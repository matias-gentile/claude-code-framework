---
name: adr-recorder
description: Records architectural decisions as numbered markdown files in .claude/adr/. Invoke whenever a significant architectural choice is made — library selection, pattern adoption, structural constraint, or a deliberate trade-off. Keeps CLAUDE.md small by externalizing decisions.
---

# ADR Recorder

## When to Record an ADR
Record a decision when:
- You chose one library/framework/pattern over another
- You established a structural constraint (e.g., "all DB access goes through the repository layer")
- You accepted a trade-off (e.g., "we denormalize this table for query performance")
- You ruled something out (e.g., "we will not use WebSockets for this use case")
- A future developer might otherwise reverse the decision without knowing why

Rule of thumb: if you would need to explain *why* in a PR review, it belongs in an ADR.

## How to Record

1. Find the next available number: `ls .claude/adr/ | sort | tail -1`
2. Create `.claude/adr/NNNN-<kebab-case-title>.md`
3. Fill in the template below
4. Add a one-line entry to the ADR index in CLAUDE.md under `## References`

## ADR Template

```markdown
# ADR-NNNN: <Title>

**Date:** YYYY-MM-DD
**Status:** Accepted | Superseded by ADR-XXXX | Deprecated

## Context
<What situation, requirement, or problem forced this decision?>

## Decision
<What was decided, stated as an active voice declaration.>

## Alternatives Considered
- **<Option A>** — rejected because <reason>
- **<Option B>** — rejected because <reason>

## Consequences
- ✅ <positive outcome>
- ⚠️ <trade-off or accepted downside>
- 🚫 <what this rules out>

## References
- <link to PR, ticket, or discussion>
```

## What Happens After Recording
- CLAUDE.md gets a one-line reference: `- ADR-NNNN: <title> — <one-line summary>`
- Future agents read the ADR before modifying the relevant area
- To supersede an ADR: create a new ADR, set `Status: Superseded by ADR-XXXX` on the old one

## ADR Index
*(Keep this updated manually — add one line per ADR after recording it)*

| ADR | Title | Status |
|-----|-------|--------|
| 0001 | Framework Setup | Accepted |
