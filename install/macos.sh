#!/usr/bin/env bash

# Get the directory of the script
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
BREWFILE_DIR="$SCRIPT_DIR/../mac/Brewfile"

xode-select --install

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

eval $(/opt/homebrew/bin/brew shellenv)
sudo chmod -R 755 /opt/homebrew/share
brew bundle --file=$BREWFILE_DIR

# Setup Terminal
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
sudo xattr -r -d com.apple.quarantine /Applications/Alacritty.app/
sudo xattr -r -d com.apple.quarantine /opt/homebrew/bin/chromedriver

