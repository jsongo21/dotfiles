#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"
REPO_DIR="$(cd -- "$SCRIPT_DIR/.." &> /dev/null && pwd)"
BREWFILE="$REPO_DIR/mac/Brewfile"
STEP=0
TOTAL_STEPS=9

if [[ -t 1 && -n "${TERM:-}" ]] && command -v tput >/dev/null 2>&1 && [[ "$(tput colors 2>/dev/null || printf 0)" -ge 8 ]]; then
  BOLD="$(tput bold)"
  GREEN="$(tput setaf 2)"
  BLUE="$(tput setaf 4)"
  YELLOW="$(tput setaf 3)"
  RED="$(tput setaf 1)"
  RESET="$(tput sgr0)"
else
  BOLD=""
  GREEN=""
  BLUE=""
  YELLOW=""
  RED=""
  RESET=""
fi

log() {
  printf '%s==>%s %s\n' "$BLUE" "$RESET" "$*"
}

step() {
  STEP=$((STEP + 1))
  printf '%s[%02d/%02d]%s %s\n' "$BLUE" "$STEP" "$TOTAL_STEPS" "$RESET" "$*"
}

done_log() {
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
    done_log "$label quarantine attribute cleared"
  else
    warn "$label not found; skipping quarantine cleanup"
  fi
}

trap 'on_error "$LINENO" "$BASH_COMMAND"' ERR

log "${BOLD}macOS dotfiles install${RESET}"
log "Repo: $REPO_DIR"

step "Checking operating system"
if [[ "$(uname -s)" != "Darwin" ]]; then
  die "This installer only supports macOS"
fi
done_log "Running on macOS"

step "Checking required commands"
require_command curl
done_log "Bootstrap commands are available"

step "Checking Xcode Command Line Tools"
if ! xcode-select -p >/dev/null 2>&1; then
  warn "Xcode Command Line Tools not found; launching installer. Rerun this script after installation finishes."
  xcode-select --install
  exit 1
else
  done_log "Xcode Command Line Tools are installed"
fi

require_command make

step "Checking Homebrew"
if ! command -v brew >/dev/null 2>&1 && [[ ! -x /opt/homebrew/bin/brew && ! -x /usr/local/bin/brew ]]; then
  log "Installing Homebrew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  done_log "Homebrew is installed"
fi

step "Loading Homebrew environment"
if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
else
  die "Homebrew install completed, but brew was not found"
fi
BREW_PREFIX="$(brew --prefix)"
done_log "Using $BREW_PREFIX"

step "Installing missing Brewfile entries"
brew bundle --no-upgrade --file="$BREWFILE"
done_log "Brewfile dependencies are installed"

step "Checking oh-my-zsh"
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
  log "Installing oh-my-zsh"
  RUNZSH=no CHSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
  done_log "oh-my-zsh is installed"
fi

step "Linking dotfiles"
make -C "$REPO_DIR" install
done_log "Dotfiles are linked"

step "Clearing quarantine attributes where needed"
clear_quarantine /Applications/Alacritty.app Alacritty.app
clear_quarantine "$BREW_PREFIX/bin/chromedriver" chromedriver

step "Checking default shell"
ZSH_PATH="$(command -v zsh || true)"
if [[ -z "$ZSH_PATH" ]]; then
  warn "zsh was not found on PATH"
elif [[ "$(basename "$SHELL")" != "zsh" ]]; then
  warn "Default shell is $SHELL; run: chsh -s $ZSH_PATH"
else
  done_log "Default shell is $SHELL"
fi

done_log "macOS install completed"
