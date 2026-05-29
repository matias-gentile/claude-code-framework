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

```bash
git clone https://github.com/matias-gentile/claude-code-framework.git /tmp/claude-framework
cd your-project
bash /tmp/claude-framework/install.sh
rm -rf /tmp/claude-framework
```

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
Run the setup skill        # Claude scans your code and fills in all placeholders
Run the tutorial skill     # 20-min interactive walkthrough with your real code
```

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
