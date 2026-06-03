# Agent-First Engineering Framework — Full Documentation

## What this is

A plug-and-play framework that gives Claude Code a six-layer engineering harness:

| Layer | Files | Purpose |
|---|---|---|
| **Constitution** | `CLAUDE.md` / `AGENTS.md` | Hard rules, escape hatches, 4-phase flow |
| **Domain knowledge** | `.claude/skills/` (8 skills) | API conventions, TDD, verification, runbook, session notes, ADRs |
| **Agent workforce** | `.claude/agents/` (4 agents) | planner, tdd-writer, code-reviewer, quality-gate |
| **Quality gates** | `.claude/hooks/` (3 hooks) | Auto-runs tests, blocks bad commits, prompts compounding loop |
| **External tools** | `.mcp.json` | GitHub, Context7, database, custom APIs |
| **Decision history** | `.claude/adr/` | Why things are the way they are |

## Install

The framework can be installed two ways:

### As a plugin (Claude Code v2.1+, recommended)

```bash
/plugin marketplace add matias-gentile/claude-code-framework
/plugin install agent-first-framework@claude-code-framework
```

Commands are namespaced `/agent-first-framework:setup`, etc. The plugin's components live in Claude Code's plugin cache, not your project.

**Important:** in plugin mode you MUST run the setup command first. The plugin ships the agents, skills, commands, and hooks — but CLAUDE.md (the framework's rules and 4-phase flow) is project memory that can't be bundled in a plugin. The setup command creates it from a template on first run, then enriches it with your project's conventions. Without running setup, you have the tools but not the rules.

### Copied into a single project

```bash
git clone https://github.com/matias-gentile/claude-code-framework.git /tmp/claude-framework
cd your-project
bash /tmp/claude-framework/install.sh
rm -rf /tmp/claude-framework
```

This copies components into your project's `.claude/` directory. Commands are namespaced `/project:setup`, etc.

The installer handles everything: copies only what's needed, never overwrites your files, appends to your `.gitignore`, makes hooks executable, configures your test command, and optionally adds the CI workflow.

### For a brand new project

```bash
git clone https://github.com/matias-gentile/claude-code-framework.git my-new-project
cd my-new-project
rm -rf .git
git init && git add . && git commit -m "chore: init with agent-first framework"
```

### After install

```bash
claude                     # open Claude Code in your project
/project:setup             # Claude scans your code and fills in all placeholders
/project:tutorial          # 20-min interactive walkthrough with your real code
```
(In plugin mode the commands are `/agent-first-framework:setup`, etc.)

## Updating an installed project

When the framework ships improvements, pull them in without losing your work.

**Copy mode** — run `/project:update` and Claude guides you, or run the updater directly:

```bash
git clone https://github.com/matias-gentile/claude-code-framework.git /tmp/cf
cd your-project
bash /tmp/cf/update.sh
rm -rf /tmp/cf
```

**Plugin mode** — reinstall the plugin:

```bash
/plugin marketplace update claude-code-framework
/plugin uninstall agent-first-framework
/plugin install agent-first-framework@claude-code-framework
```

The updater compares each component against what was originally shipped (using a manifest of hashes recorded at install). Components you have **not** modified are updated in place. Components you **have** customized are left untouched, with the new version saved beside them as `<file>.new` to compare. Your `CLAUDE.md`, `AGENTS.md`, `.mcp.json`, and `session-notes.md` are never touched. See `CHANGELOG.md` for what each version changes.

## Coexisting with your own setup

The framework is built to drop into a project that already has its own Claude Code configuration without destroying any of it:

- **Components with unique names** (your own agents, skills, commands) live alongside the framework's.
- **Name collisions** (e.g. you already have your own `agents/planner.md`) never overwrite your file — the framework version is saved as `<name>.framework` and flagged for you to review.
- **Your `settings.json` is merged**, not replaced: your permissions and hooks are preserved, and the framework's hooks/permissions are added only where missing. Your original is backed up as `settings.json.pre-framework`. The merge tolerates JSONC (comments and trailing commas) and is idempotent.
- **Your existing `CLAUDE.md` / `AGENTS.md` are reconciled with your consent**: setup appends the framework sections you're missing (4-phase flow, escape hatches, etc.) without rewriting or reordering your content.

## What gets installed in your project

```
your-project/                              ← your project, untouched
├── CLAUDE.md                              ← Constitution (≤120 lines, always loaded)
├── AGENTS.md                              ← Universal format for other AI tools
├── .mcp.json.example                      ← MCP template (safe, no tokens)
├── .mcp.json                              ← Your local config (gitignored)
└── .claude/                               ← everything else lives here
    ├── settings.json                      ← Permissions, deny list, hook registration
    ├── agents/
    │   ├── planner.md                     ← Read-only scout, produces plans
    │   ├── tdd-writer.md                  ← Writes failing tests only
    │   ├── reviewer.md                    ← Read-only quality gate before merges
    │   └── quality-gate.md                ← Evaluates task completeness
    ├── skills/
    │   ├── setup/         SKILL.md        ← Scans codebase, auto-fills placeholders
    │   ├── tutorial/      SKILL.md        ← Interactive 8-step console walkthrough
    │   ├── verification/  SKILL.md        ← End-to-end feature confirmation flows
    │   ├── tdd-practices/ SKILL.md        ← Test-first enforcement
    │   ├── runbook/       SKILL.md        ← Structured debugging protocol
    │   ├── session-notes/ SKILL.md        ← Structured record-keeping
    │   ├── adr-recorder/  SKILL.md        ← Captures architectural decisions
    │   └── api-conventions/ SKILL.md      ← REST design rules
    ├── hooks/
    │   ├── post-edit-test.sh              ← Runs tests after every file write
    │   ├── pre-commit-check.sh            ← Blocks commits if tests haven't passed
    │   └── session-end-reminder.sh        ← Prompts the compounding loop
    ├── adr/
    │   └── 0001-framework-setup.md        ← First ADR (template + example)
    └── docs/
        ├── stack.md                       ← Tech stack + commands
        ├── repo-structure.md              ← Directory layout + module rules
        ├── CONTRIBUTING.md                ← How to extend the framework
        ├── README.md                      ← This file
        └── guide.html                     ← Interactive visual guide
```

Only 3 files at root. Everything else is inside `.claude/`.

## The 4-phase flow

Every multi-file task follows this sequence (enforced in CLAUDE.md):

```
1. EXPLORE  → planner agent scouts the codebase (read-only)
2. PLAN     → numbered task list, approved by you
3. IMPLEMENT → tdd-writer writes failing tests, then you implement
4. VERIFY   → quality-gate + code-reviewer + verification skill
```

## The compounding loop

Every session makes the next one faster:
- Bug or mistake Claude repeats → add a rule to `CLAUDE.md`
- Workflow that takes many turns → create a new skill
- Architectural decision → record an ADR in `.claude/adr/`

## MCP setup

`.mcp.json` is gitignored. The installer creates it from `.mcp.json.example`. To configure:

```bash
# In Claude Code, type:
Help me configure my MCP integrations
```

## GitHub Actions PR review

The installer asks if you want this. If you said no and want to add it later:

```bash
mkdir -p .github/workflows
curl -fsSL https://raw.githubusercontent.com/matias-gentile/claude-code-framework/main/.github/workflows/claude-pr-review.yml \
  -o .github/workflows/claude-pr-review.yml
```

Then add `ANTHROPIC_API_KEY` to your repo secrets (Settings → Secrets → Actions). Cost: ~$0.04/review on Sonnet.

## Extending the framework

See `.claude/docs/CONTRIBUTING.md` for how to add skills, modify agents, evolve hooks, and keep CLAUDE.md under its 120-line budget.

## Interactive guide

Open `.claude/docs/guide.html` in any browser for a visual walkthrough. Supports dark mode, works offline.

## Built on

- [Anthropic Claude Code documentation](https://docs.claude.com)
- [Anthropic "Building Effective Agents"](https://www.anthropic.com/engineering/building-effective-agents)
- Thariq Shihipar's 9-category Skills taxonomy (Claude Code team, March 2026)
- Reliable-AI patterns from NVIDIA NeMo, Jason Liu (Instructor), Hamel Husain & Shreya Shankar
