#!/usr/bin/env python3
"""PreToolUse hook for Bash: let `rm` in temp directories run, ask elsewhere.

Claude Code ignores an allow rule when an ask rule matches the same command,
so the policy for `rm` lives here and settings.json has no `rm` ask rule.
Deny rules still apply after this hook.

- A single plain `rm` with every target in a temp directory is allowed.
- In a chained command, each `rm` is checked on its own. If all are safe, the
  hook gives no opinion, so the other commands keep their normal checks.
- Any `rm` that is outside temp directories, quoted, globbed or expanded asks.
"""
import json
import os
import re
import sys
import tempfile

TEMP_ROOTS = {"/tmp", "/var/folders", os.environ.get("TMPDIR", tempfile.gettempdir())}
# Only plain words. Quotes, globs, expansions and operators fall back to ask.
SAFE_RM = re.compile(r"^rm(\s+[A-Za-z0-9_./+=@%:,-]+)+$")
HARMLESS_REDIRECT = re.compile(r"\s\d*>&\d|\s\d*>>?\s*/dev/null")
ENV_PREFIX = re.compile(r"^(?:[A-Za-z_][A-Za-z0-9_]*=\S*\s+)+")


def decide(decision, reason):
    print(json.dumps({"hookSpecificOutput": {
        "hookEventName": "PreToolUse",
        "permissionDecision": decision,
        "permissionDecisionReason": reason,
    }}))


def in_temp(path, cwd):
    resolved = os.path.realpath(os.path.join(cwd, path))
    for root in TEMP_ROOTS:
        root = os.path.realpath(root)
        if resolved != root and resolved.startswith(root + os.sep):
            return True
    return False


def rm_targets(segment):
    targets, options_done = [], False
    for word in segment.split()[1:]:
        if not options_done and word == "--":
            options_done = True
        elif options_done or not word.startswith("-"):
            targets.append(word)
    return targets


def main():
    payload = json.load(sys.stdin)
    command = payload.get("tool_input", {}).get("command", "").strip()
    cwd = payload.get("cwd") or os.getcwd()

    cleaned = HARMLESS_REDIRECT.sub("", command)
    segments = [ENV_PREFIX.sub("", s.strip()) for s in re.split(r"[;&|\n(){}`]", cleaned)]
    rm_segments = [s for s in segments if re.match(r"^rm(\s|$)", s)]
    if not rm_segments:
        return

    for segment in rm_segments:
        targets = rm_targets(segment) if SAFE_RM.match(segment) else []
        if not targets:
            return decide("ask", "rm is quoted, globbed, expanded or has no target")
        if not all(in_temp(target, cwd) for target in targets):
            return decide("ask", "rm target is outside temp directories")

    if len([s for s in segments if s]) == 1:
        decide("allow", "all rm targets are inside temp directories")


main()
