#!/usr/bin/env python3
"""Merge framework settings into a user's existing .claude/settings.json.

Principles:
- Never remove or overwrite the user's permissions or hooks.
- Add framework hooks ONLY for events/commands the user doesn't already have.
- Add framework permission allow/deny entries the user is missing.
- The user's file remains the source of truth for anything that overlaps.

Usage: merge-settings.py <user_settings.json> <framework_settings.json>
Writes the merged result back to <user_settings.json>.
Prints a summary of what was added.
"""
import json
import re
import sys


def _strip_jsonc(text):
    """Remove // and /* */ comments so we can parse JSONC settings files.
    Conservative: skips anything inside double-quoted strings."""
    out = []
    i, n = 0, len(text)
    in_str = False
    while i < n:
        ch = text[i]
        if in_str:
            out.append(ch)
            if ch == "\\" and i + 1 < n:
                out.append(text[i + 1]); i += 2; continue
            if ch == '"':
                in_str = False
            i += 1; continue
        if ch == '"':
            in_str = True; out.append(ch); i += 1; continue
        if ch == "/" and i + 1 < n and text[i + 1] == "/":
            while i < n and text[i] != "\n":
                i += 1
            continue
        if ch == "/" and i + 1 < n and text[i + 1] == "*":
            i += 2
            while i + 1 < n and not (text[i] == "*" and text[i + 1] == "/"):
                i += 1
            i += 2; continue
        out.append(ch); i += 1
    # also drop trailing commas which JSONC tolerates
    cleaned = "".join(out)
    cleaned = re.sub(r",(\s*[}\]])", r"\1", cleaned)
    return cleaned


def load(path):
    try:
        with open(path) as f:
            raw = f.read()
    except FileNotFoundError:
        return {}
    try:
        return json.loads(raw)
    except json.JSONDecodeError:
        # Retry tolerating JSONC (comments / trailing commas)
        try:
            return json.loads(_strip_jsonc(raw))
        except json.JSONDecodeError:
            return {}


def hook_command(hook_entry):
    """Extract the command string from a hook entry for dedup comparison."""
    cmds = []
    for h in hook_entry.get("hooks", []):
        c = h.get("command", "") or h.get("prompt", "")
        cmds.append(c)
    return tuple(sorted(cmds))


def main():
    user_path, fw_path = sys.argv[1], sys.argv[2]
    user = load(user_path)
    fw = load(fw_path)
    added = []

    # ---- permissions ----
    uperm = user.setdefault("permissions", {})
    fperm = fw.get("permissions", {})
    for bucket in ("allow", "deny"):
        u = uperm.setdefault(bucket, [])
        for entry in fperm.get(bucket, []):
            if entry not in u:
                u.append(entry)
                added.append(f"permission {bucket}: {entry}")

    # ---- hooks ----
    uhooks = user.setdefault("hooks", {})
    fhooks = fw.get("hooks", {})
    for event, fw_entries in fhooks.items():
        u_entries = uhooks.setdefault(event, [])
        # Build a set of command-signatures the user already has for this event
        existing_sigs = {hook_command(e) for e in u_entries}
        for fe in fw_entries:
            sig = hook_command(fe)
            if sig not in existing_sigs:
                u_entries.append(fe)
                existing_sigs.add(sig)
                added.append(f"hook {event}: {' '.join(sig)}")

    # ---- top-level scalar settings (only if user lacks them) ----
    for k, v in fw.items():
        if k in ("permissions", "hooks"):
            continue
        if k not in user:
            user[k] = v
            added.append(f"setting {k}")

    with open(user_path, "w") as f:
        json.dump(user, f, indent=2)
        f.write("\n")

    if added:
        print(f"MERGED {len(added)} framework setting(s) into your existing settings.json:")
        for a in added:
            print(f"  + {a}")
    else:
        print("Your settings.json already had everything the framework needs — no changes.")


if __name__ == "__main__":
    main()
