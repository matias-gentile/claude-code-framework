# Agent-First Engineering Framework for Claude Code

A production-grade engineering harness for Claude Code — 4 specialist agents, 8 skills, automatic quality gates, and a compounding loop that turns every session's lessons into permanent rules.

→ **[Full documentation](docs/README.md)**
→ **[Interactive guide](docs/guide.html)** (open in browser)

## Install

### Option A — as a plugin (recommended, Claude Code v2.1+)

```bash
# Add this repo as a marketplace, then install
/plugin marketplace add matias-gentile/claude-code-framework
/plugin install agent-first-framework@claude-code-framework
```

Commands are then namespaced as `/agent-first-framework:setup`, `/agent-first-framework:plan`, etc.

To test locally before publishing:
```bash
git clone https://github.com/matias-gentile/claude-code-framework.git
claude --plugin-dir ./claude-code-framework
```

### Option B — copy into a single project (no plugin system)

```bash
git clone https://github.com/matias-gentile/claude-code-framework.git /tmp/claude-framework
cd your-project
bash /tmp/claude-framework/install.sh
rm -rf /tmp/claude-framework
```

This copies the framework into your project's `.claude/` directory. Commands are namespaced as `/project:setup`, etc.

## Updating an installed project

When the framework ships improvements, pull them in without losing your work.

**Plugin mode:**
```bash
/plugin marketplace update claude-code-framework
/plugin uninstall agent-first-framework
/plugin install agent-first-framework@claude-code-framework
```

**Copy mode:** run the updater, or just `/project:update` and let Claude guide you.
```bash
git clone https://github.com/matias-gentile/claude-code-framework.git /tmp/cf
cd your-project
bash /tmp/cf/update.sh
rm -rf /tmp/cf
```

The updater compares each component against what was originally shipped. Files you
have not modified are updated in place. Files you customized are left untouched, with
the new version saved beside them as `<file>.new` to compare. Your `CLAUDE.md`,
`AGENTS.md`, `.mcp.json`, and `session-notes.md` are never touched. See `CHANGELOG.md`
for what each version changes.

## After install

```bash
claude
/agent-first-framework:setup      # (plugin)  — or  /project:setup  (copied)
```

The setup command scans your codebase, fills in placeholders, enriches CLAUDE.md with project-specific rules, configures MCP, and creates verification flows.

## What you get

**Agents** (`agents/`): planner, tdd-writer, code-reviewer, quality-gate
**Skills** (`skills/`): setup, tutorial, verification, tdd-practices, runbook, session-notes, adr-recorder, api-conventions
**Commands** (`commands/`): setup, tutorial, plan, review, adr, session-review
**Hooks** (`hooks/`): SessionStart (loads prior context), UserPromptSubmit (blocks secrets, injects ADRs), PostToolUse (auto-test), PreToolUse (commit gate), PreCompact (preserve notes), Stop (compounding loop)

## License

MIT
