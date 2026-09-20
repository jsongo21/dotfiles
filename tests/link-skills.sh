#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
REPO_DIR="$(cd -- "$SCRIPT_DIR/.." >/dev/null 2>&1 && pwd)"
LINKER="$REPO_DIR/install/link-skills.sh"
SOURCE="$REPO_DIR/home/.agents/skills/find-skills"
LOCAL_SOURCE="$REPO_DIR/home/.claude/skills/code-review"
TEST_ROOT="$(mktemp -d)"
trap 'rm -rf "$TEST_ROOT"' EXIT

run_linker() {
  AGENT_SKILLS_DIR="$TEST_ROOT/shared" SKILL_HARNESS_DIRS="$1" "$LINKER" "${2:---dry-run}"
}

dry_run_dir="$TEST_ROOT/dry-run"
dry_run_output="$(run_linker "$dry_run_dir" --dry-run)"
[[ ! -e "$dry_run_dir" ]]
[[ "$dry_run_output" = *"dry-run"* ]]

apply_dir="$TEST_ROOT/apply"
run_linker "$apply_dir" --apply >/dev/null
[[ -L "$apply_dir/find-skills" ]]
[[ -L "$TEST_ROOT/shared/find-skills" ]]
[[ "$(readlink "$TEST_ROOT/shared/find-skills")" = "$SOURCE" ]]
[[ "$(readlink "$apply_dir/find-skills")" = "$TEST_ROOT/shared/find-skills" ]]

local_dir="$TEST_ROOT/local"
run_linker "$local_dir" --apply >/dev/null
[[ "$(readlink "$TEST_ROOT/shared/code-review")" = "$LOCAL_SOURCE" ]]
[[ "$(readlink "$local_dir/code-review")" = "$TEST_ROOT/shared/code-review" ]]

real_dir="$TEST_ROOT/real"
mkdir -p "$real_dir/find-skills"
run_linker "$real_dir" --apply >/dev/null
[[ -d "$real_dir/find-skills" && ! -L "$real_dir/find-skills" ]]

relink_dir="$TEST_ROOT/relink"
mkdir -p "$relink_dir"
ln -s "$TEST_ROOT/old-target" "$relink_dir/find-skills"
run_linker "$relink_dir" --apply >/dev/null
[[ "$(readlink "$relink_dir/find-skills")" = "$TEST_ROOT/shared/find-skills" ]]

if SKILL_HARNESS_DIRS="relative/path" "$LINKER" --dry-run >/dev/null 2>&1; then
  printf 'Expected relative harness path to fail\n' >&2
  exit 1
fi

printf 'link-skills tests passed\n'
