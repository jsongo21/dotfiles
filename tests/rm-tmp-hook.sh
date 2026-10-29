#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
HOOK="$SCRIPT_DIR/../home/.claude/hooks/rm-tmp.py"

# decision <cwd> <command> prints allow, ask or none
decision() {
  jq -nc --arg cwd "$1" --arg command "$2" '{cwd: $cwd, tool_input: {command: $command}}' |
    python3 -I "$HOOK" |
    { jq -r '.hookSpecificOutput.permissionDecision' || true; } |
    { read -r line || line=none; echo "${line:-none}"; }
}

check() {
  local expected="$1" cwd="$2" command="$3" actual
  actual="$(decision "$cwd" "$command")"
  if [[ "$actual" != "$expected" ]]; then
    echo "FAIL: [$command] in $cwd expected $expected, got $actual" >&2
    exit 1
  fi
}

check allow /work/project "rm /tmp/pr.md"
check allow /work/project "rm -f /tmp/a /private/tmp/b"
check allow /work/project "rm -rf /tmp/work/dir"
check allow /work/project "rm -rf -- /private/tmp/claude-0/x/scratchpad/y"
check allow /tmp "rm -f notes.md"
check allow /work/project "rm /var/folders/ab/cd/T/file"

check ask /work/project "rm /tmp"
check ask /work/project "rm -rf /tmp/"
check ask /work/project "rm /tmp/x /etc/hosts"
check ask /work/project "rm /tmp/../work/file"
check ask /work/project "rm notes.md"
check ask /work/project "rm -f"
check ask /work/project "rm /tmp/x; rm /etc/hosts"
check ask /work/project "rm /tmp/*"
check ask /work/project 'rm $HOME/file'
check ask /work/project 'rm "/tmp/a b"'
check ask /work/project "rm ~/file"
check ask /work/project "rm /tmp/\$(whoami)"

check ask /work/project "cd /tmp && rm /etc/hosts"
check ask /work/project "rm -f uv.lock; ls /tmp"
check ask /work/project "rm /tmp/x; rm notes.md"
check ask /work/project "FOO=1 rm /etc/hosts"
check ask /work/project "ls && rm /tmp/x /etc/hosts"
check ask /work/project "rm /tmp/x \$(whoami)"

# Chained commands whose rm targets are all in tmp: no opinion, defer to normal checks.
check none /work/project "rm /tmp/x && echo done"
check none /work/project "ls | rm /tmp/x"
check none /work/project "echo hi
rm /tmp/x"
check allow /work/project "(rm /tmp/x)"
check none /work/project "rm -f /tmp/a; S=/tmp/b && python3 \$S/x.py 2>&1 | head"
check none /work/project "FOO=1 rm /tmp/x && ls"
check allow /work/project "rm -f /tmp/x 2>&1"
check allow /work/project "rm -f /tmp/x > /dev/null"

check none /work/project "ls /tmp"
check none /work/project "rmdir /tmp/x"
check none /work/project "echo rm /tmp/x"

# A symlink inside /tmp that points outside must not count as temp.
link_dir="$(mktemp -d)"
trap 'rm -rf "$link_dir"' EXIT
ln -s "$HOME" "$link_dir/home"
check ask /work/project "rm $link_dir/home/some-file"

echo "rm-tmp hook: ok"
