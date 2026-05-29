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
If you discovered project-specific rules that Claude should always follow (e.g., a specific import pattern, a required wrapper function, a naming convention enforced in the codebase), add them to the Architectural Rules section.
Keep CLAUDE.md under 120 lines total.

## Step 7 — Report what you did

Output a summary in this format:

```
## Framework Setup Complete

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
