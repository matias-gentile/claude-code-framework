# Agent Instructions
# This file is the universal source of truth for all coding agents (Claude Code, Cursor, Codex, Windsurf, Aider).
# Claude Code users: CLAUDE.md is a symlink to this file. Edit here.

## Stack & Commands
- See .claude/docs/stack.md for tech stack, build commands, and test runners
- See .claude/docs/repo-structure.md for directory layout and module responsibilities

## Architectural Rules (HARD)
- All external integrations declared in `.mcp.json` — never add inline HTTP calls
- All API calls routed through the gateway service — no direct third-party calls from feature code
- Modular, decoupled design — no cross-module imports except through defined interfaces
- Strict type-checking and explicit error handling — no silent catches, no `any`
- See `.claude/adr/` for all recorded architectural decisions — read the relevant ADR before touching that area

## The 4-Phase Flow (MANDATORY for any task touching >1 file)
1. **Explore** — use Plan mode (read-only) to understand the affected surface
2. **Plan** — write a numbered task list before writing a single line of code
3. **Implement** — dispatch agents or write code; tests first (see `tdd-practices` skill)
4. **Verify** — run the verification skill; do not mark done until it passes

## Compounding Loop (IMPORTANT)
- After every non-trivial task: ask "should this go in CLAUDE.md, a skill, or an ADR?"
- If a bug or architectural choice surprised you: record it before closing the session
- Use the `adr-recorder` skill to capture decisions; use `/compact` to summarize before `/clear`

## Agent Workforce
- Dispatch `planner` before any multi-file task — it produces the plan, you review it
- Dispatch `code-reviewer` before any merge — it blocks on critical issues
- Dispatch `tdd-writer` to write failing tests before dispatching any implementation agent
- Dispatch `quality-gate` before marking any task complete — it evaluates whether you're actually done
- Do not use general agents when a specialized one exists

## Escape Hatches (HARD)
- If you have attempted the same fix 3 times without progress: STOP, summarize what you tried, ask the human
- If a tool call returns the same output 3 times in a row: you are in a loop — break out, change approach or escalate
- If debugging exceeds 10 tool calls without a clear hypothesis: invoke the `runbook` skill immediately
- Never exceed 15 tool calls on a single sub-task without checking in with the human
- When stuck: write what you know, what you tried, and what you need — then ask. Do not guess-and-loop

## Commits
- Conventional commits: `feat:`, `fix:`, `chore:`, `docs:`, `refactor:`, `test:`
- One concern per commit — no bundled unrelated changes
- Never commit `.env*`, `*.key`, `*.pem`, or secrets of any kind

## Active Skills
- `api-conventions` — REST design rules; invoke for any endpoint work
- `verification` — product verification flows; invoke before marking any feature done
- `tdd-practices` — test-first rules; invoke at the start of any implementation task
- `adr-recorder` — capture architectural decisions; invoke after any significant choice
- `runbook` — structured debugging; invoke when something is broken or investigation exceeds 15 min
- `session-notes` — structured record-keeping during work; summaries come from notes, not memory

## Token & Cache Discipline
- Most stable content is at the TOP of this file — do not reorder sections (cache hit rate depends on it)
- Use `/compact` before switching tasks; use `/clear` between unrelated work — stale context is the #1 cost driver
- Default model is Sonnet; only escalate to Opus for architectural decisions that need deep reasoning

## MCP Integrations
- See `.mcp.json` for configured servers
- If placeholders are unconfigured: tell me and I will walk you through setup interactively

## References
- .claude/adr/ — architectural decision records
- .claude/docs/ — detailed stack and repo docs

## Key Contacts (fill in for your team)
- Architecture decisions: @<owner>
- Infrastructure / MCP config: @<owner>
- On-call runbook: see `.claude/skills/runbook/`
