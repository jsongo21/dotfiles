xcode-select --install

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

eval $(/opt/homebrew/bin/brew shellenv)
sudo chmod -R 755 /opt/homebrew/share
brew update

# Setup Terminal
brew install zsh zsh-completions
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
git clone https://github.com/geometry-zsh/geometry ${HOME}/.oh-my-zsh/themes/geometry
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# Node.js
brew install npm
brew install yarn


# Setup Terminal Install apps
brew install neovim
brew install tmux
brew install --cask google-chrome
brew install --cask iterm2
brew install --cask visual-studio-code
brew install --cask rectangle
brew install --cask slack
brew install --cask notion
brew install --cask scroll-reverser
brew install --cask docker
brew install --cask zoom
brew install --cask spotify
brew install --cask postman
brew install --cask discord
brew install --cask chromedriver
brew install awscli
brew install awslogs
brew install jq
brew install alacritty
sudo xattr -r -d com.apple.quarantine /Applications/Alacritty.app/
sudo xattr -r -d com.apple.quarantine /opt/homebrew/bin/chromedriver
brew tap homebrew/cask-fonts
brew install --cask font-jetbrains-mono-nerd-font

sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
vim +PluginInstall +qall

