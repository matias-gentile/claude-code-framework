# Changelog

All notable changes to the Agent-First Engineering Framework are documented here.
The format is based on [Keep a Changelog](https://keepachangelog.com), and this
project adheres to [Semantic Versioning](https://semver.org).

## [1.2.0] — 2026-05-30

### Added
- **Coexistence mode** for users who already have their own Claude Code setup:
  - install.sh now detects component name collisions (e.g. you have your own
    `agents/planner.md`). Your file is never overwritten — the framework version
    is saved beside it as `<name>.framework` and flagged for review.
  - install.sh now MERGES the framework's hooks and permissions into your
    existing `settings.json` instead of refusing to touch it. Your permissions
    and hooks are preserved; the framework's are added only where missing.
    Idempotent, and your original is backed up as `settings.json.pre-framework`.
  - The setup command now reconciles a pre-existing CLAUDE.md: if it's your own
    (not a framework file), setup appends the missing framework sections with
    your consent instead of assuming an "Architectural Rules" section exists.
- `.claude-plugin/merge-settings.py` — the settings merger (preserves user
  config, adds framework entries, deduplicates).

### Changed
- Component install is now collision-aware (per-file, never blind `cp -r`).

## [1.1.0] — 2026-05-30

### Added
- **Update system**: `update` command + `update.sh` to pull framework
  improvements into already-installed projects without losing your
  customizations or your enriched CLAUDE.md.
- **SessionStart hook**: loads prior session context (branch, handoff notes,
  most recent ADR, test command) at the start of every session.
- **UserPromptSubmit hook**: blocks prompts containing secrets and injects the
  relevant ADR when a prompt touches a decided area.
- **PreCompact hook**: prompts a session-notes save before context is compacted.
- Custom-agent proposals in the session-review command (Category D).

### Fixed
- **Stop hook no longer errors.** It used `type:prompt`, which made the model
  evaluate whether the session was "complete" and report a Stop hook error
  mid-task. Now a passive `command` hook emitting `systemMessage` — visible,
  never evaluated.
- **Code blocks invisible in dark mode** (guide.html): light text on a
  theme-flipping light background. Now a fixed dark terminal background.
- **Three robustness bugs** found in a skeptical audit: `set -e` + grep-returns-1
  killed session-start.sh on titleless ADRs and user-prompt-submit.sh on
  short-word prompts; quality-gate couldn't verify tests under strict
  permissions (now reads the test marker with an honest fallback).
- **Plugin/copy parity**: setup now creates CLAUDE.md from a template in plugin
  mode (it can't be bundled in a plugin), so plugin installs aren't rule-less.

### Changed
- Converted to Claude Code plugin format (`.claude-plugin/`, components at root,
  `hooks/hooks.json`). Dual install preserved: plugin or copy.

## [1.0.0] — 2026-05-29

### Added
- Initial framework: 4 agents (planner, tdd-writer, code-reviewer, quality-gate),
  8 skills, 6 commands, lifecycle hooks, ADRs, the 4-phase flow, and the
  compounding loop.
- Systematic CLAUDE.md enrichment from a 5-category codebase scan.
- The session-review command that drafts rules, ADRs, and skills for approval.
- Boss-audience interactive guide (guide.html).
