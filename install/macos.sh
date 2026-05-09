#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"
REPO_DIR="$(cd -- "$SCRIPT_DIR/.." &> /dev/null && pwd)"
BREWFILE="$REPO_DIR/mac/Brewfile"
STEP=0

BOLD=""
GREEN=""
BLUE=""
YELLOW=""
RED=""
RESET=""
BREW_PREFIX=""

setup_colours() {
  if [[ -t 1 && -n "${TERM:-}" ]] && command -v tput >/dev/null 2>&1 && [[ "$(tput colors 2>/dev/null || printf 0)" -ge 8 ]]; then
    BOLD="$(tput bold)"
    GREEN="$(tput setaf 2)"
    BLUE="$(tput setaf 4)"
    YELLOW="$(tput setaf 3)"
    RED="$(tput setaf 1)"
    RESET="$(tput sgr0)"
  fi
}

log() {
  printf '%s==>%s %s\n' "$BLUE" "$RESET" "$*"
}

step() {
  STEP=$((STEP + 1))
  printf '%s[%02d/%02d]%s %s\n' "$BLUE" "$STEP" "${#INSTALL_STEPS[@]}" "$RESET" "$*"
}

ok() {
  printf '%sok%s %s\n' "$GREEN" "$RESET" "$*"
}

warn() {
  printf '%swarn%s %s\n' "$YELLOW" "$RESET" "$*" >&2
}

die() {
  printf '%serror%s %s\n' "$RED" "$RESET" "$*" >&2
  exit 1
}

on_error() {
  local exit_code=$?
  trap - ERR
  die "Install failed at line $1: $2 (exit $exit_code)"
}

require_command() {
  local command_name="$1"

  if ! command -v "$command_name" >/dev/null 2>&1; then
    die "Required command not found: $command_name"
  fi
}

clear_quarantine() {
  local path="$1"
  local label="$2"

  if [[ -e "$path" ]]; then
    sudo xattr -r -d com.apple.quarantine "$path"
    ok "$label quarantine attribute cleared"
  else
    warn "$label not found; skipping quarantine cleanup"
  fi
}

check_macos() {
  step "Checking operating system"

  if [[ "$(uname -s)" != "Darwin" ]]; then
    die "This installer only supports macOS"
  fi

  ok "Running on macOS"
}

check_bootstrap_commands() {
  step "Checking required commands"
  require_command curl
  ok "Bootstrap commands are available"
}

ensure_xcode_tools() {
  step "Checking Xcode Command Line Tools"

  if ! xcode-select -p >/dev/null 2>&1; then
    warn "Xcode Command Line Tools not found; launching installer. Rerun this script after installation finishes."
    xcode-select --install
    exit 1
  fi

  require_command make
  ok "Xcode Command Line Tools are installed"
}

ensure_homebrew() {
  step "Checking Homebrew"

  if ! command -v brew >/dev/null 2>&1 && [[ ! -x /opt/homebrew/bin/brew && ! -x /usr/local/bin/brew ]]; then
    log "Installing Homebrew"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  else
    ok "Homebrew is installed"
  fi
}

load_homebrew() {
  step "Loading Homebrew environment"

  if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [[ -x /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
  else
    die "Homebrew install completed, but brew was not found"
  fi

  BREW_PREFIX="$(brew --prefix)"
  ok "Using $BREW_PREFIX"
}

install_brewfile() {
  step "Installing missing Brewfile entries"
  brew bundle --no-upgrade --file="$BREWFILE"
  ok "Brewfile dependencies are installed"
}

ensure_oh_my_zsh() {
  step "Checking oh-my-zsh"

  if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
    log "Installing oh-my-zsh"
    RUNZSH=no CHSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  else
    ok "oh-my-zsh is installed"
  fi
}

link_dotfiles() {
  step "Linking dotfiles"
  make -C "$REPO_DIR" install
  ok "Dotfiles are linked"
}

clear_quarantine_attributes() {
  step "Clearing quarantine attributes where needed"
  clear_quarantine /Applications/Alacritty.app Alacritty.app
  clear_quarantine "$BREW_PREFIX/bin/chromedriver" chromedriver
}

check_default_shell() {
  local zsh_path

  step "Checking default shell"
  zsh_path="$(command -v zsh || true)"

  if [[ -z "$zsh_path" ]]; then
    warn "zsh was not found on PATH"
  elif [[ "$(basename "$SHELL")" != "zsh" ]]; then
    warn "Default shell is $SHELL; run: chsh -s $zsh_path"
  else
    ok "Default shell is $SHELL"
  fi
}

main() {
  setup_colours
  trap 'on_error "$LINENO" "$BASH_COMMAND"' ERR

  log "${BOLD}macOS dotfiles install${RESET}"
  log "Repo: $REPO_DIR"

  for install_step in "${INSTALL_STEPS[@]}"; do
    "$install_step"
  done

  ok "macOS install completed"
}

INSTALL_STEPS=(
  check_macos
  check_bootstrap_commands
  ensure_xcode_tools
  ensure_homebrew
  load_homebrew
  install_brewfile
  ensure_oh_my_zsh
  link_dotfiles
  clear_quarantine_attributes
  check_default_shell
)

main "$@"
