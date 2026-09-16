#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
REPO_DIR="$(cd -- "$SCRIPT_DIR/.." >/dev/null 2>&1 && pwd)"
FIREFOX_DIR="$HOME/Library/Application Support/Firefox"
PROFILES_FILE="$FIREFOX_DIR/profiles.ini"
PROFILE_ROOT="$FIREFOX_DIR/Profiles"
SOURCE="$REPO_DIR/firefox/user.js"

if [[ ! -f "$PROFILES_FILE" ]]; then
  printf 'Firefox profiles.ini not found: %s\n' "$PROFILES_FILE" >&2
  exit 1
fi

profile_data="$({
  awk '
    function emit_profile() {
      if (in_profile && path != "") {
        printf "%s\t%s\t%s\n", name, path, is_default
      }
    }
    /^\[/ {
      emit_profile()
      in_profile = ($0 ~ /^\[Profile[0-9][0-9]*\]$/)
      name = ""
      path = ""
      is_default = 0
      next
    }
    in_profile && /^Name=/ {
      name = substr($0, 6)
      next
    }
    in_profile && /^Path=/ {
      path = substr($0, 6)
      next
    }
    in_profile && /^Default=1$/ {
      is_default = 1
    }
    END {
      emit_profile()
    }
  ' "$PROFILES_FILE"
})"

if [[ -z "$profile_data" ]]; then
  printf 'No Firefox profiles found in %s\n' "$PROFILES_FILE" >&2
  exit 1
fi

profile_names=()
profile_paths=()
profile_defaults=()
if [[ -n "$profile_data" ]]; then
  while IFS=$'\t' read -r profile_name profile_path profile_default; do
    profile_names+=("$profile_name")
    profile_paths+=("$profile_path")
    profile_defaults+=("$profile_default")
  done <<< "$profile_data"
fi

for profile_dir in "$PROFILE_ROOT"/*; do
  [[ -d "$profile_dir" ]] || continue
  directory_name="${profile_dir##*/}"
  relative_path="Profiles/$directory_name"
  found=0
  for known_path in "${profile_paths[@]}"; do
    if [[ "$known_path" = "$relative_path" || "$known_path" = "$profile_dir" ]]; then
      found=1
      break
    fi
  done
  if [[ "$found" = 0 ]]; then
    profile_names+=("$directory_name")
    profile_paths+=("$relative_path")
    profile_defaults+=(0)
  fi
done

if [[ ${#profile_names[@]} -eq 0 ]]; then
  printf 'No Firefox profile directories found in %s\n' "$PROFILE_ROOT" >&2
  exit 1
fi

printf 'Firefox profiles:\n'
for index in "${!profile_names[@]}"; do
  marker=""
  if [[ "${profile_defaults[$index]}" = 1 ]]; then
    marker=" (default)"
  fi
  printf '  %d) %s%s [%s]\n' "$((index + 1))" "${profile_names[$index]}" "$marker" "${profile_paths[$index]}"
done

selection="${1:-}"
if [[ -z "$selection" ]]; then
  printf 'Select a profile number: '
  read -r selection
fi

if [[ ! "$selection" =~ ^[0-9]+$ ]] || (( selection < 1 || selection > ${#profile_names[@]} )); then
  printf 'Invalid profile selection: %s\n' "$selection" >&2
  exit 1
fi

profile_index=$((selection - 1))
profile_path="${profile_paths[$profile_index]}"
if [[ "$profile_path" = /* ]]; then
  profile_dir="$profile_path"
else
  profile_dir="$FIREFOX_DIR/$profile_path"
fi

target="$profile_dir/user.js"
mkdir -p "$profile_dir"
ln -sfn "$SOURCE" "$target"
printf 'Linked Firefox user.js for %s: %s -> %s\n' "${profile_names[$profile_index]}" "$target" "$SOURCE"
