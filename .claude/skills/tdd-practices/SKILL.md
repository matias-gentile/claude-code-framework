---
name: tdd-practices
description: Enforces test-driven development. Invoke at the start of any implementation task. Defines project test conventions, structure, and the required sequence — tests before code, always.
---

# TDD Practices

## The Non-Negotiable Rule
**No implementation code without a failing test.**
If you are about to write a function, class, or endpoint and there is no failing test for it: STOP. Dispatch `tdd-writer` first, or write the test yourself before the implementation.

## The Required Sequence
```
1. Read the plan (planner agent output)
2. Dispatch tdd-writer → produces failing tests
3. Confirm tests fail: run test command, see red
4. Write implementation to make tests pass: see green
5. Refactor if needed: stay green
6. Run verification skill: confirm end-to-end
```

Never skip step 2–3. The failing test is the specification.

## Test File Conventions
*(Fill in for your project — examples below)*

- Test files live in `tests/` mirroring the `src/` structure
- Test files named `<module>.test.<ext>` or `<module>.spec.<ext>`
- Each test file imports only from the module it tests + shared test helpers
- No network calls in unit tests — mock all I/O
- Integration tests may use the test database; never production

## Test Taxonomy
| Type | Scope | Speed | Location |
|---|---|---|---|
| Unit | Single function/class | <10ms | `tests/unit/` |
| Integration | Module + DB/Queue | <500ms | `tests/integration/` |
| E2E | Full user flow | <30s | `tests/e2e/` |

## What Good Tests Look Like
- One logical assertion per test (multiple `expect` calls for the same outcome is fine)
- Descriptive names: `it("returns 404 when user does not exist")` not `it("test user")`
- AAA structure: Arrange → Act → Assert
- No logic in tests (no `if`, no loops) — if you need a loop, parameterize the test

## What Bad Tests Look Like (forbidden)
- Tests that always pass regardless of implementation
- Tests that mock the thing they're testing
- Tests that depend on test execution order
- Tests that touch production data or external APIs

## Test Commands
*(Fill in for your project)*
```bash
# Run all tests
<fill in>

# Run unit tests only
<fill in>

# Run with coverage
<fill in>
```

## Coverage Targets
*(Fill in for your project)*
- Unit coverage: ≥80% on new code
- Critical paths (auth, payments, data writes): 100%
- Coverage gates enforced in CI — do not disable

## When TDD Feels Slow
It's faster. The overhead is front-loaded; the debugging is eliminated.
The one exception: pure UI layout work. Even then, snapshot tests count.
