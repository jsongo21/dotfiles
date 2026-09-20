#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
REPO_DIR="$(cd -- "$SCRIPT_DIR/.." >/dev/null 2>&1 && pwd)"
SHARED_SKILLS_DIR="$REPO_DIR/home/.agents/skills"
LOCAL_SKILLS_DIR="$REPO_DIR/home/.claude/skills"
AGENT_SKILLS_DIR="${AGENT_SKILLS_DIR:-$HOME/.agents/skills}"
LOCAL_SKILLS_REAL_DIR="$(realpath "$LOCAL_SKILLS_DIR")"

# Override with a colon-separated list when another harness is installed.
SKILL_HARNESS_DIRS="${SKILL_HARNESS_DIRS:-$HOME/.claude/skills:$HOME/.codex/skills:$HOME/.config/opencode/skills}"
APPLY_CHANGES=0

if [[ "${1:-}" = "--apply" ]]; then
  APPLY_CHANGES=1
elif [[ -n "${1:-}" && "${1:-}" != "--dry-run" ]]; then
  printf 'Usage: %s [--apply|--dry-run]\n' "$0" >&2
  exit 2
fi

if [[ "$SKILL_HARNESS_DIRS" = :* || "$SKILL_HARNESS_DIRS" = *: || "$SKILL_HARNESS_DIRS" = *::* ]]; then
  printf 'Harness skill paths must be separated by single colons: %s\n' "$SKILL_HARNESS_DIRS" >&2
  exit 2
fi

validate_harness_dir() {
  local target_dir="$1"
  local component

  [[ -n "$target_dir" ]] || {
    printf 'Harness skill path must not be empty\n' >&2
    exit 2
  }
  [[ "$target_dir" = /* && "$target_dir" != "/" ]] || {
    printf 'Harness skill path must be an absolute non-root path: %s\n' "$target_dir" >&2
    exit 2
  }
  IFS=/ read -r -a components <<< "$target_dir"
  for component in "${components[@]}"; do
    [[ "$component" != ".." ]] || {
      printf 'Harness skill path must not contain ..: %s\n' "$target_dir" >&2
      exit 2
    }
  done
}

run_change() {
  if [[ "$APPLY_CHANGES" = 1 ]]; then
    "$@"
  else
    printf 'dry-run:'
    printf ' %q' "$@"
    printf '\n'
  fi
}

IFS=: read -r -a configured_harness_dirs <<< "$SKILL_HARNESS_DIRS"
validate_harness_dir "$AGENT_SKILLS_DIR"
run_change mkdir -p "$AGENT_SKILLS_DIR"
for target_dir in "${configured_harness_dirs[@]}"; do
  validate_harness_dir "$target_dir"
  run_change mkdir -p "$target_dir"
done

link_skill() {
  local source="$1"
  local name="${source##*/}"
  local target_dir target target_real

  for target_dir in "${configured_harness_dirs[@]}"; do
    [[ -n "$target_dir" ]] || continue
    if [[ -e "$target_dir" ]]; then
      if ! target_real="$(realpath "$target_dir")"; then
        printf 'Unable to resolve harness skill path: %s\n' "$target_dir" >&2
        exit 1
      fi
    else
      target_real="$target_dir"
    fi
    [[ "$target_real" = "$LOCAL_SKILLS_REAL_DIR" ]] && continue
    target="$target_dir/$name"

    if [[ -L "$target" ]]; then
      if [[ "$(readlink "$target")" = "$source" ]]; then
        printf 'skip %s (already linked)\n' "$target"
      else
        run_change ln -sfn "$source" "$target"
        printf '%s %s -> %s\n' "$([[ "$APPLY_CHANGES" = 1 ]] && printf relinked || printf would-relink)" "$target" "$source"
      fi
    elif [[ -e "$target" ]]; then
      printf 'skip %s (exists, not a symlink)\n' "$target"
    else
      run_change ln -s "$source" "$target"
      printf '%s %s -> %s\n' "$([[ "$APPLY_CHANGES" = 1 ]] && printf linked || printf would-link)" "$target" "$source"
    fi
  done
}

link_root() {
  local root="$1"
  local skill

  [[ -d "$root" ]] || return 0
  for skill in "$root"/*; do
    [[ -d "$skill" ]] || continue
    [[ -f "$skill/SKILL.md" ]] || continue
    link_skill "$skill"
  done
}

# Prefer the CLI-managed shared pool. Repo-local skills are added when they are
# not already present in that pool.
link_root "$AGENT_SKILLS_DIR"
for source_root in "$SHARED_SKILLS_DIR" "$LOCAL_SKILLS_DIR"; do
  [[ -d "$source_root" ]] || continue
  for skill in "$source_root"/*; do
    [[ -d "$skill" ]] || continue
    [[ -f "$skill/SKILL.md" ]] || continue
    name="${skill##*/}"
    [[ -e "$AGENT_SKILLS_DIR/$name" || -L "$AGENT_SKILLS_DIR/$name" ]] && continue
    run_change ln -s "$skill" "$AGENT_SKILLS_DIR/$name"
    printf '%s %s -> %s\n' "$([[ "$APPLY_CHANGES" = 1 ]] && printf linked || printf would-link)" "$AGENT_SKILLS_DIR/$name" "$skill"
    link_skill "$AGENT_SKILLS_DIR/$name"
  done
done
