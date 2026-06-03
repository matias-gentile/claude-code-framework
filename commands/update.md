---
description: Update the framework to the latest version. Pulls new agents, skills, commands, and hooks into this project without touching your CLAUDE.md or your customizations. Shows what changed and flags any files you've modified.
---

You are running the framework update process for this project.

## Step 1 — Determine the install mode

Check how the framework was installed:
- If `.claude/.framework-version` exists → **copy mode**. Proceed with the steps below.
- If there is no `.claude/.framework-version` but the project uses the plugin (commands are namespaced `/agent-first-framework:`) → **plugin mode**. Tell the user to update via the plugin system instead:
  ```
  /plugin marketplace update claude-code-framework
  /plugin uninstall agent-first-framework
  /plugin install agent-first-framework@claude-code-framework
  ```
  Explain that in plugin mode the components live in Claude Code's plugin cache, so the update happens there — their project files (CLAUDE.md, etc.) are never affected. Then STOP; the steps below are for copy mode only.

## Step 2 — Report current vs available version (copy mode)

- Read `.claude/.framework-version` for the installed version.
- Tell the user you'll fetch the latest framework and compare.

## Step 3 — Run the updater

Guide the user to run, from the project root:

```bash
git clone https://github.com/matias-gentile/claude-code-framework.git /tmp/cf
bash /tmp/cf/update.sh
rm -rf /tmp/cf
```

The `update.sh` script does the safe work deterministically:
- Components you have NOT modified are updated in place.
- Components you HAVE modified are left untouched; the new version is saved beside them as `<file>.new` for you to compare.
- CLAUDE.md, AGENTS.md, .mcp.json, and session-notes.md are never touched.

Do NOT try to copy files yourself — the script handles hash comparison to detect customizations. Running it manually is safer than reproducing its logic.

## Step 4 — Help interpret the result

After the script runs, if it reported any `.new` files (customized components), offer to help the user reconcile them:
- For each `<file>.new`, read both versions and summarize what changed.
- Recommend whether to keep theirs, take the new version, or merge specific changes.
- Apply the user's decision: `rm <file>.new` to keep theirs, or `mv <file>.new <file>` to take the new one.

## Step 5 — Confirm

Read `.claude/.framework-version` again to confirm it now shows the new version. Summarize what was updated and remind the user their project memory (CLAUDE.md) and customizations were preserved.

## Constraints
- Never overwrite a customized component without the user's explicit decision.
- Never touch CLAUDE.md, AGENTS.md, .mcp.json, or session-notes.md.
- If the user is in plugin mode, do not run update.sh — direct them to the plugin update flow.
