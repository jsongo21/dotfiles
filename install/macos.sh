xode-select --install

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

eval $(/opt/homebrew/bin/brew shellenv)
sudo chmod -R 755 /opt/homebrew/share
brew bundle

# Setup Terminal
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
git clone https://github.com/geometry-zsh/geometry ${HOME}/.oh-my-zsh/themes/geometry
sudo xattr -r -d com.apple.quarantine /Applications/Alacritty.app/
sudo xattr -r -d com.apple.quarantine /opt/homebrew/bin/chromedriver
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

