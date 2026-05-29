---
name: runbook
description: Structured debugging and incident response. Invoke when something is broken in dev or production — service errors, failing tests, performance regressions, or data anomalies. Guides a systematic root-cause investigation rather than guess-and-check.
---

# Runbook

## When to invoke this skill
- A service is returning errors or crashing
- Tests are failing and the cause isn't obvious
- Performance has degraded unexpectedly
- A deployment broke something
- You've been debugging for more than 15 minutes without a clear hypothesis

## The debugging protocol

### Step 1 — Define the symptom precisely
Before touching any code, answer:
- What is the **exact** error message or observable failure?
- When did it **start**? (check `git log --since="2 hours ago"`)
- Is it **consistent** or intermittent?
- What **changed** recently? (last deploy, dependency update, config change)

Do not skip this step. Vague symptoms lead to wrong fixes.

### Step 2 — Establish the blast radius
- Is this affecting all users or a subset?
- Is it affecting all environments or just one?
- Is it one service or multiple?
- Is there a data pattern (specific IDs, times, request types)?

### Step 3 — Form a hypothesis before reading code
State one specific hypothesis:
> "I believe the error is caused by [X] because [Y evidence]"

If you can't form a hypothesis: read logs, not code. Code tells you what *should* happen. Logs tell you what *did* happen.

### Step 4 — Investigate systematically

**For service errors:**
```bash
# Recent logs (adapt to your stack)
tail -n 100 logs/error.log
journalctl -u your-service --since "30 minutes ago"

# Check what changed
git log --oneline -20
git diff HEAD~1

# Check process state
ps aux | grep your-service
```

**For failing tests:**
```bash
# Run the single failing test with verbose output
[test command] --verbose [specific test file or name]

# Check if it's a data/fixture issue
# Check if it's environment-specific
# Check if it was recently changed
git log --oneline [test file]
```

**For performance regressions:**
```bash
# Establish baseline vs current
# Check for N+1 queries (look for repeated DB calls in logs)
# Check for missing indexes on recently added queries
# Check for unbounded list operations (missing pagination)
```

### Step 5 — Fix with minimum blast radius
- Fix the specific thing confirmed by investigation
- Do NOT refactor while fixing — one change, one commit
- Write a test that reproduces the bug before fixing it
- Verify the fix in isolation before deploying

### Step 6 — Prevent recurrence
After fixing, run the compounding loop:
- Should a rule be added to CLAUDE.md to prevent this class of bug?
- Should a new verification flow be added to catch this regression?
- Should this become an ADR if it was an architectural issue?

---

## Common failure patterns and their diagnostic paths

### "Works locally, fails in CI"
1. Check environment variables — CI likely missing one
2. Check test ordering — CI may run in different order
3. Check filesystem/network assumptions — CI is sandboxed
4. Check seed data — CI DB starts empty

### "Works in staging, fails in production"
1. Check data volume — prod has more records
2. Check for hardcoded staging URLs or config
3. Check feature flags — prod may have different flags
4. Check for missing migrations — prod may be behind

### "Was working, now broken, no code changes"
1. Check for expired credentials (tokens, certs, API keys)
2. Check for external API changes (third-party updated their contract)
3. Check for infrastructure changes (disk full, memory limit, timeout)
4. Check for time-based issues (scheduled job, cron, expiry)

### "Intermittent errors"
1. Look for race conditions (concurrent requests, async operations)
2. Look for memory leaks (error rate climbs over time, resets on restart)
3. Look for timeout sensitivity (external calls with tight timeouts)
4. Look for data-dependent failures (specific record shapes trigger it)

---

## Escalation rule
If after following this protocol you have:
- Read the relevant logs
- Formed and tested at least 2 hypotheses
- Still cannot identify the root cause

→ STOP. Write a clear incident summary:
```
## Incident Summary
**Symptom:** [exact error]
**Started:** [when]
**Blast radius:** [who/what affected]
**Investigated:** [what you looked at]
**Hypotheses tested:** [what you tried and why it wasn't it]
**Current state:** [what you know for certain]
**Request:** [specific help needed]
```

Then escalate to a human. Do not loop on guesses.

---

## Add project-specific runbooks below

### [Template: Service Name]
**Common failure:** ...
**First check:** ...
**Resolution:** ...
