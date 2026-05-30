---
name: setup
description: First-time framework setup. Scans the codebase to auto-detect the tech stack, directory structure, test commands, and key conventions — then fills in all placeholder files automatically. Run once when dropping this framework into an existing project.
---

# Setup Skill

You are performing a one-time framework setup for this project.
Your job is to read the actual codebase and populate every placeholder file with real, accurate content.

## Step 1 — Detect the tech stack

Read these files to identify the stack (read ALL that exist):
- `package.json` → language, framework, test runner, build tool, key dependencies
- `pyproject.toml` or `requirements.txt` → Python stack
- `Gemfile` → Ruby stack
- `go.mod` → Go stack
- `Cargo.toml` → Rust stack
- `pom.xml` or `build.gradle` → Java/Kotlin stack
- `Makefile` → available make targets
- `docker-compose.yml` or `Dockerfile` → runtime environment
- `.env.example` → required environment variables
- `tsconfig.json` or `jsconfig.json` → TypeScript config
- `.eslintrc*`, `.prettierrc*` → linting and formatting setup
- Any `*.config.*` files at root level

## Step 2 — Map the directory structure

Run `ls -la` and `find . -type f -name "*.ts" -o -name "*.py" -o -name "*.go" | head -60` (adapt to detected language) to understand:
- Where source code lives (`src/`, `app/`, `lib/`, etc.)
- Where tests live (`tests/`, `__tests__/`, `spec/`, etc.)
- Whether there are monorepo packages (`packages/`, `apps/`, `services/`)
- Key config directories

## Step 3 — Find the test command

Look for test commands in:
1. `package.json` → `scripts.test`
2. `Makefile` → `make test` target
3. `pyproject.toml` → `[tool.pytest.ini_options]`
4. `.github/workflows/*.yml` → what CI runs

Determine the single command that runs the full test suite.

## Step 4 — Infer module responsibilities

Read 2–3 files from each major directory to understand what each module owns and what it does NOT touch.

## Step 5 — Identify the top 3–5 user-facing flows

One verification flow is a template. Three to five flows is a safety net.

Look for all of these and rank by user impact:
- Route handlers / controllers → list every significant endpoint
- Auth flows → signup, login, password reset, token refresh
- Core business actions → the thing the app exists to do (checkout, publish, send, book, etc.)
- Data mutation paths → create, update, delete on primary resources
- README.md and any existing tests → what does the project treat as critical?

Select the **top 3–5** by asking: "if this broke silently, how long before a user noticed?"
The answer is your priority order.

## Step 6 — Write the output files

Now write all placeholder files with real content. Be specific and accurate — generic content is worse than nothing.

### Write: `.claude/docs/stack.md`
Replace ALL `<fill in>` placeholders with real values from what you found.
Include exact versions, exact command strings, and exact env variable names.

### Write: `.claude/docs/repo-structure.md`
Replace the example directory tree with the ACTUAL tree.
Fill in the module responsibility table with what you discovered.
Fill in the naming conventions you observed in the actual code.

### Write the test command file:
```bash
echo "[ACTUAL TEST COMMAND]" > .claude/hooks/.test-command
```

### Update: `.claude/skills/verification/SKILL.md`
Add a verification flow for EACH of the top 3–5 flows you identified in Step 5.
Use the template already in the file. Replace the `[TEMPLATE]` example with the first real flow,
then append additional flows below it.

For each flow, be specific: exact entry point, exact preconditions, exact pass/fail criteria.
Generic flows ("check the page loads") are useless. Specific flows ("status 201 + userId in response + welcome email in logs") catch real regressions.

Aim for at least 3 flows. A project with fewer than 3 verification flows is under-instrumented.

### Update: `CLAUDE.md`

Do a deliberate scan to extract project-specific rules. Work through each category below and add only rules that pass the filter.

**Category 1 — Module boundaries**
Read 5-10 import statements across different layers (controllers, services, repositories, utils).
Ask: are there import patterns that are always followed? Always violated?
Good rule: "Services must never import from the controllers/ directory"
Bad rule: "Follow clean architecture" (too vague)

**Category 2 — Wrapper conventions**
Grep for custom wrappers: HTTP clients, loggers, error classes, DB connectors.
Ask: is there a project-specific class or function that should always be used instead of the raw library?
Good rule: "Never use axios directly — import httpClient from src/lib/http.ts"
Bad rule: "Use the HTTP client" (no path, no enforcement)

**Category 3 — Naming conventions that differ from language defaults**
Scan 10-20 filenames and function names. Look for surprises.
Good rule: "Files are kebab-case, but DB column names are snake_case — never mix them"
Bad rule: "Use camelCase for variables" (JavaScript default — Claude already knows this)

**Category 4 — Data shape invariants**
Look for comments, types, or tests that assert facts about data.
Good rule: "Prices are always stored in cents (integer) — never dollars or floats"
Bad rule: "Handle money carefully" (not actionable)

**Category 5 — Error handling patterns**
Find how errors are thrown, caught, and surfaced.
Good rule: "All thrown errors must extend AppError from src/errors/base.ts"
Bad rule: "Handle errors properly" (not actionable)

**The filter — before adding any rule, ask:**
1. Would Claude get this wrong without being told? (If no → skip)
2. Is it already enforced by a linter, formatter, or TypeScript? (If yes → skip)
3. Is it specific enough that Claude knows exactly what to do? (If no → rewrite it)
4. Does adding it keep CLAUDE.md under 120 lines? (If no → pick the most important ones)

Add only rules that pass all four. Aim for 2-5 new rules. Quality beats quantity.

## Step 7 — Configure MCP integrations

Read `.mcp.json` and check which servers are still unconfigured (have `<YOUR_` placeholders).

For each unconfigured server, determine if it's relevant to this project:

**GitHub MCP** — relevant if:
- The project is a git repository (`git remote -v` returns a GitHub URL)
- If relevant: ask the user for their GitHub personal access token
  - Explain: "I need a GitHub token to read PRs, issues, and repo context directly."
  - Explain: "Create one at https://github.com/settings/tokens (needs 'repo' scope)"
  - Once provided: write it to `.mcp.json` under `github.headers.Authorization`

**Context7 MCP** — relevant if:
- The project uses any external libraries (check package.json, requirements.txt, etc.)
- If relevant: no token needed. Just verify the npx command works:
  `npx -y @upstash/context7-mcp --help 2>/dev/null`
  - If it works: mark as configured in `.mcp.json`
  - If it fails: note it needs Node.js/npx installed

**Database MCP** — relevant if:
- The project has a database connection string anywhere (.env.example, docker-compose.yml, config files)
- If relevant: ask the user for their local/dev database connection string
  - Explain: "This gives Claude read-only access to query your database for debugging."
  - Emphasize: "This is stored locally in .mcp.json which is gitignored — it will never be committed."
  - Once provided: write it to `.mcp.json`

**Custom API MCP** — skip unless the user mentions a specific service they want to connect.

Remove any server blocks from `.mcp.json` that are not relevant to this project
(delete the entire block, don't leave unconfigured placeholders).

If the user declines to configure any server: remove that block from `.mcp.json` and note it in the report.

## Step 8 — Initialize session notes

Create `.claude/session-notes.md` with a starter template so the session-notes skill
and `/project:session-review` have a file to work with from the first session:

```markdown
# Session Notes

## Current Task
(No task in progress — run /project:setup to complete initial configuration)

## Progress Log
| # | Step | Status | Notes |
|---|------|--------|-------|

## Decisions Made
| Decision | Rationale | ADR? |
|----------|-----------|------|

## Open Questions
- [ ] Complete /project:tutorial for hands-on walkthrough

## Files Changed
- (none yet)

## Test Results
- (none yet)
```

## Step 9 — Report what you did

Output a summary in this format:

```
## Framework Setup Complete

### CLAUDE.md enriched (this is your /init)
The framework scanned your codebase and added project-specific rules.
These rules will be followed automatically in every future session.

Rules added:
- [list each rule that was added to CLAUDE.md]

CLAUDE.md is now [X] lines (budget: 120).

### Stack detected
- Language: ...
- Framework: ...
- Test runner: ...
- Test command written to .claude/hooks/.test-command: ...

### Files populated
- ✅ .claude/docs/stack.md
- ✅ .claude/docs/repo-structure.md
- ✅ .claude/hooks/.test-command
- ✅ .claude/skills/verification/SKILL.md (added [N] verification flows)
- ✅ CLAUDE.md (added [N] project-specific rules)

### MCP integrations
- [GitHub: configured / skipped / not relevant]
- [Context7: configured / skipped / not relevant]
- [Database: configured / skipped / not relevant]

### Could not detect (fill in manually)
- ⚠️ [anything you couldn't determine from the code]

### Recommended next steps
1. [any MCP server you'd recommend based on the stack]
2. [any skill you'd suggest creating based on what you found]
3. [any gap in the framework for this specific project]
```

## Important constraints
- Do NOT delete any existing content in these files — only replace `<fill in>` placeholders and add new content
- Do NOT fabricate commands — only write commands you verified exist in the project files
- If you cannot determine something, leave the placeholder and note it in the "Could not detect" section
- Run the test command after writing it to verify it actually works
