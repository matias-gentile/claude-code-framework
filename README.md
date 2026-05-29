# Agent-First Engineering Framework for Claude Code

A plug-and-play framework that gives Claude Code a production-grade engineering harness. Drops into any existing project without touching your files.

→ **[Full documentation](.claude/docs/README.md)** — setup paths, directory structure, extending the framework
→ **[Interactive guide](.claude/docs/guide.html)** — visual walkthrough (open in browser)

## Install

```bash
# 1. Clone somewhere temporary
git clone https://github.com/matias-gentile/claude-code-framework.git /tmp/claude-framework

# 2. Go into your project and run the installer
cd your-project
bash /tmp/claude-framework/install.sh

# 3. Clean up
rm -rf /tmp/claude-framework
```

The installer copies only what's needed, never overwrites your existing files, and walks you through configuration interactively.

## What gets installed

**3 files at your project root** (required by Claude Code):
- `CLAUDE.md` — the rules every agent follows
- `AGENTS.md` — universal format for other AI tools
- `.mcp.json.example` — MCP integration template

**Everything else inside `.claude/`:**
- `agents/` — 4 specialists: planner, tdd-writer, code-reviewer, quality-gate
- `skills/` — 8 on-demand knowledge modules
- `hooks/` — 3 automatic quality gates
- `adr/` — architectural decision records
- `docs/` — stack docs, repo structure, contributing guide, interactive guide

**Not installed unless you opt in:**
- `.github/workflows/` — CI workflow (installer asks you)

## After install

```bash
claude                    # open Claude Code
Run the setup skill       # auto-fills placeholders from your codebase
Run the tutorial skill    # 20-min interactive walkthrough
```
