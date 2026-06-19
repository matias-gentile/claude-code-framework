# Changelog

All notable changes to the Agent-First Engineering Framework are documented here.
The format is based on [Keep a Changelog](https://keepachangelog.com), and this
project adheres to [Semantic Versioning](https://semver.org).

## [1.5.1] — 2026-05-30

### Changed
- **Agent least-privilege hardening.** All four agents now declare `disallowed-tools` in
  frontmatter (Claude Code v2.1.152+) as defense-in-depth on top of their `tools` allow
  list: planner and code-reviewer block Write/Edit/MultiEdit/Bash (read-only), quality-gate
  blocks Write/Edit/MultiEdit (keeps Bash for tests), tdd-writer blocks Edit/MultiEdit/Bash
  (keeps Write for test files only). Even if a permission rule is later loosened, these
  agents cannot mutate code they shouldn't.

### Added
- CONTRIBUTING troubleshooting section: use `--safe-mode` / `CLAUDE_CODE_SAFE_MODE` to
  isolate whether a problem is coming from the framework or from Claude Code itself.

## [1.5.0] — 2026-05-30

### Added
- **Handoff skill + `handoff` command** for resuming work cleanly when context fills up
  or you pause. Generates a structured handoff (next concrete step first, then current
  state, branch, test status, files touched, decisions, and gotchas) into the
  `## Handoff Notes` section of session-notes — which the SessionStart hook already
  surfaces next session. Works for "future you" and for handing the project to a teammate.

### Changed
- The PreCompact hook now points at the handoff format, so automatic compaction and the
  manual `handoff` command produce the same resume-ready document.

## [1.4.0] — 2026-05-30

### Added
- **Opt-in context-aware status line.** Setup now offers a status line showing model,
  branch, and context-usage % (green/yellow/red by threshold) — the visual companion to
  the framework's token-discipline goal, so you compact before being surprised by it.
  Opt-in by design: setup checks for `jq`, never overwrites an existing `statusLine`,
  and asks before configuring. Not enabled by default and not forced by install.sh.

## [1.3.0] — 2026-05-30

### Added
- **Curator skill + `curate` command** for keeping accumulated memory compact and
  current as a project ages. Three distinct, safe treatments:
  - **session-notes**: compresses completed entries into a rolling summary (with approval).
  - **ADRs**: marks superseded/deprecated status and can build an INDEX — never deletes
    or merges them, so the record of *why not* is preserved.
  - **CLAUDE.md**: proposes removal of rules with concrete evidence of being stale
    (dead file refs, old versions, contradictions, duplicates) — default keep, removal
    only on explicit per-rule approval.
  Manual and occasional by design; not automated via a hook.

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
