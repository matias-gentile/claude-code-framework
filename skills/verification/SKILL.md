---
name: verification
description: Runs product verification flows to confirm a feature works end-to-end. Invoke at the end of every implementation task, before marking anything done. This is the single highest-leverage skill — invest in making it excellent.
---

# Verification Skill

## Purpose
Verification confirms that code changes produce the correct observable behaviour from the user's perspective — not just that unit tests pass. This is distinct from running the test suite.

## How to Use This Skill
1. Identify the feature or flow that was changed
2. Follow the verification steps for that flow below
3. If the relevant flow is not listed, document it here before proceeding

---

## Verification Flows

### [TEMPLATE — replace with your actual flows]

#### Flow: <Feature Name>
**Entry point:** <URL, CLI command, or API endpoint>
**Preconditions:** <any data or state required>

**Steps:**
1. <action>
2. <action>
3. <observe: what should be true>

**Pass criteria:**
- [ ] <observable outcome 1>
- [ ] <observable outcome 2>
- [ ] No errors in console / logs
- [ ] Response time < <threshold>

**Fail criteria (auto-block):**
- Any 5xx response
- Any unhandled exception in logs
- Any broken UI state

---

## Adding New Flows
When you implement a new feature, add its verification flow here before closing the task.
Format: Entry point → Preconditions → Steps → Pass criteria → Fail criteria.

## Verification vs Tests
- **Tests** = automated, run in CI, fast, cover code paths
- **Verification** = manual or browser-driven, slow, covers user-visible outcomes
Both are required. Passing tests does not replace verification.

## Escalation
If verification fails and you cannot determine the root cause within 3 tool calls: STOP, output a failure report, and request human review. Do not guess-and-loop.
