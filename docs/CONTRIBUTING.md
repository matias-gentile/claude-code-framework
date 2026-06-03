# Contributing to the Framework

This document explains how to extend, improve, and evolve the agent-first engineering framework itself. The framework is designed to compound — every improvement you make should make the next one easier.

---

## Adding a new skill

Skills are the most common extension. Add one whenever a workflow takes more than 2 back-and-forth turns to get right.

**1. Create the directory and SKILL.md:**
```bash
mkdir -p .claude/skills/your-skill-name
touch .claude/skills/your-skill-name/SKILL.md
```

**2. Write the frontmatter (required):**
```yaml
---
name: your-skill-name
description: One or two sentences. This is what Claude reads at startup to decide
             whether to load this skill. Make it specific to the trigger scenario.
---
```

**3. Write the skill body** in plain markdown. No length limit — the body is only read on demand. Include:
- When to use this skill (be specific)
- The step-by-step process Claude should follow
- Examples of correct output
- What NOT to do

**4. Add to CLAUDE.md** under `## Active Skills`:
```markdown
- `your-skill-name` — one-line description of when to invoke it
```

**5. Test it:** Open Claude Code and describe a scenario that should trigger the skill. Observe whether Claude loads it correctly. If not, sharpen the `description` field in the frontmatter.

---

## Modifying an agent

Agents live in `.claude/agents/`. Each is a markdown file with YAML frontmatter.

```yaml
---
name: agent-name
description: When Claude Code should use this agent (shown in agent picker)
tools: Read, Write, Bash, Glob, Grep  # only grant what the agent needs
model: claude-sonnet-4-20250514
isolation: worktree                    # each agent gets its own git worktree
---
```

**Rules when modifying agents:**
- Only grant tools the agent actually needs — least privilege
- `isolation: worktree` should always be set for agents that write files
- If an agent keeps overstepping its role, add an explicit "YOU MUST NOT" rule to its system prompt
- Test after changes by dispatching the agent on a real task

**Adding a new agent:** follow the same structure. Good candidates are specialized roles that appear more than once in your workflow — a `db-migrator`, `docs-writer`, or `security-scanner`.

---

## Modifying hooks

Hooks live in `.claude/hooks/` and are registered in `.claude/settings.json`.

**Hook lifecycle events available:**
- `PostToolUse` — after Claude uses a tool (Write, Edit, Bash, etc.)
- `PreToolUse` — before Claude uses a tool (can block it)
- `Stop` — when Claude finishes a task
- `SessionStart` — when a new session opens
- `Notification` — when Claude sends a notification

**Adding a new hook:**
1. Write your script in `.claude/hooks/your-hook.sh`
2. Make it executable: `chmod +x .claude/hooks/your-hook.sh`
3. Register it in `.claude/settings.json` under `hooks`

**Critical rule:** Never add hooks that fire on every individual `Write`/`Edit` call and feed output back to Claude — this creates a token-consuming feedback loop. Run formatters between sessions, not as in-session hooks.

**Known evolution point for `post-edit-test.sh`:** The current hook runs the full test suite after every file write. On suites over ~10 seconds this creates friction. The mature pattern is to detect which test file corresponds to the edited file and run only that. When this becomes a pain point, update the hook to:
```bash
# Run only the test file matching the edited file, fall back to full suite
EDITED="${CLAUDE_TOOL_OUTPUT_FILE:-}"
MATCHING_TEST=$(find tests/ -name "$(basename ${EDITED%.*}).test.*" 2>/dev/null | head -1)
TEST_CMD=$(cat .claude/hooks/.test-command)
if [ -n "$MATCHING_TEST" ]; then
  eval "$TEST_CMD $MATCHING_TEST"
else
  eval "$TEST_CMD"
fi
```

---

## Evolving CLAUDE.md

CLAUDE.md has a **120-line hard budget**. Before adding a line, consider whether an existing line can be removed.

**Add a line when:**
- Claude repeated the same mistake more than once
- A rule is project-specific and can't be inferred from the code
- An architectural constraint must be enforced before any implementation starts

**Remove a line when:**
- Claude consistently follows the rule without being reminded (it has compounded in)
- The rule is better expressed as a skill or ADR
- The rule is now enforced by a linter or hook

**Never add to CLAUDE.md:**
- Personality or tone instructions
- Anything your linter already catches
- Workflow steps that belong in a skill
- Architectural history that belongs in an ADR

---

## Recording a framework-level ADR

When you make a significant decision *about the framework itself* (not just the project), record it in `adr/`. Use the `adr-recorder` skill:

```
Use the adr-recorder skill to record our decision to [framework decision]
```

Examples of framework-level ADRs:
- "We chose worktree isolation over shared context for agents"
- "We use the tdd-writer agent pattern instead of inline test instructions"
- "We cap CLAUDE.md at 120 lines rather than using a longer file"

---

## Updating `.mcp.json.example`

`.mcp.json` is gitignored (to protect tokens). `.mcp.json.example` is the committed template.

When adding a new MCP integration:
1. Edit `.mcp.json.example` with the new server block (use `<PLACEHOLDER>` for all credentials)
2. Edit your local `.mcp.json` with the real credentials
3. Commit only `.mcp.json.example`
4. Update the install.sh if the new server needs special setup

---

## The framework contribution checklist

Before committing any framework change:

**Always:**
- [ ] CLAUDE.md is still under 120 lines
- [ ] New skills have accurate `description` frontmatter (test by triggering them)
- [ ] New agents have `isolation: worktree` and least-privilege `tools`
- [ ] New hooks don't fire on every individual edit
- [ ] `.mcp.json` is NOT committed (only `.mcp.json.example`)
- [ ] The change is captured in an ADR if it's a significant framework decision

**Documentation sync (the docs lag the code if you skip this):**
- [ ] **Added/removed a command?** Update the command count in `docs/guide.html`
      (hero stat) AND the command list in the "Your AI team" tab AND `README.md`.
- [ ] **Added/removed an agent, skill, or hook?** Update the corresponding count
      in the `docs/guide.html` hero stats and the relevant tab.
- [ ] **Added a user-facing feature** (install/update/coexistence behavior)?
      Update `README.md`, `docs/README.md`, AND `docs/guide.html` — all three.
- [ ] Directory structure changed? Update the tree in `docs/README.md`.

**Release bookkeeping:**
- [ ] Bump `version` in `.claude-plugin/plugin.json` (semver).
- [ ] Add a `CHANGELOG.md` entry under the new version.
- [ ] If components changed, regenerate the manifest:
      `bash .claude-plugin/generate-manifest.sh`

> Rule of thumb: a change isn't done when the code works — it's done when the
> three user-facing docs (README, docs/README, guide.html) describe what the
> code now does. Counts and command lists are the first things to drift.

---

## Per-module rules (nested CLAUDE.md)

Claude Code supports nested CLAUDE.md files. If you create `src/billing/CLAUDE.md`, its rules apply only when Claude is working on files inside `src/billing/`.

**When to use nested CLAUDE.md files:**
- Monorepos where modules have genuinely different conventions
- A module uses a different DB access pattern, error handling, or naming convention than the rest
- A module has strict rules that don't apply globally (e.g., "all prices in cents, never floats")

**When NOT to use them:**
- Single-service repos where the same rules apply everywhere — just use root CLAUDE.md
- To repeat rules from root CLAUDE.md — nested files add to root rules, they don't replace them

**How to create one:**
```bash
echo "# Billing Module Rules" > src/billing/CLAUDE.md
echo "- All monetary amounts are integers in cents — never floats, never dollars" >> src/billing/CLAUDE.md
```

These rules load automatically when Claude touches files in that directory.

---

## Worktree folders (.claude/worktrees/)

When agents run with `isolation: worktree` (all agents in this framework do), Claude Code creates temporary working directories at `.claude/worktrees/agent-xxxx/`. Each agent gets its own copy of the codebase so agents can't interfere with each other.

**What they are:** ephemeral scratch directories. They contain the agent's work-in-progress during execution.

**Why they appear in VS Code:** VS Code's Source Control panel detects them as git worktrees and shows uncommitted changes. This is confusing but harmless — those changes are either already merged to your main branch (if the agent succeeded) or should be discarded (if it failed).

**How to clean up:**
```bash
rm -rf .claude/worktrees/
```
This is always safe. Claude Code creates fresh worktrees on each agent dispatch.

**Why they don't get committed:** the install.sh adds `.claude/worktrees/` to your `.gitignore`. If you installed the framework before this entry was added, add it manually:
```bash
echo ".claude/worktrees/" >> .gitignore
```

---

## The compounding rule for framework changes

Every time you improve the framework, write one sentence in the commit message explaining *why* you made the change, not just *what* you changed.

```bash
# Good
git commit -m "feat: add runbook skill — debugging was taking 10+ turns without it"

# Not useful
git commit -m "feat: add runbook skill"
```

This makes the git log a readable history of what the team learned.
