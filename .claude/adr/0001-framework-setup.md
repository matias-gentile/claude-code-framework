# ADR-0001: Agent-First Engineering Framework Adoption

**Date:** 2025-01-01 (update to actual date)
**Status:** Accepted

## Context
The team needed a standardized, version-controlled structure for AI-assisted development that:
- Works identically for every developer from the moment they clone the repo
- Enforces architectural rules before code is written ("shift left")
- Scales from a single developer to a multi-agent parallel workflow
- Keeps human intent in control of system boundaries while AI handles syntax

## Decision
We adopt an agent-first engineering framework defined by six layers committed to source control:
CLAUDE.md (constitution) → Skills (on-demand domain knowledge) → Subagents (specialized workers) → Hooks (quality gates) → MCP servers (external integrations) → ADRs (decision history).

## Alternatives Considered
- **Ad-hoc prompting** — rejected because it produces inconsistent results and no team-level knowledge accumulates
- **Global ~/.claude config only** — rejected because it can't be version-controlled or shared
- **Third-party AI scaffolding tools** — rejected because they add external dependencies and obscure the framework's internals

## Consequences
- ✅ Every session starts with the same architectural constraints, regardless of who is working
- ✅ Decisions accumulate in `adr/` and compound over time via the compounding loop
- ✅ Safe to use parallel agents — hooks and worktree isolation limit blast radius
- ⚠️ Requires initial investment to populate verification flows and project-specific skill content
- ⚠️ Hooks require a `.claude/hooks/.test-command` file to be configured per-project
- 🚫 Do not bypass this framework for "quick" tasks — one-off hacks are how the compounding loop breaks down

## References
- Anthropic Claude Code documentation: https://docs.anthropic.com/en/docs/claude-code
- Thariq Shihipar (Claude Code team), "How We Use Skills", March 2026
