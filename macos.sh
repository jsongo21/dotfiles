xcode-select --install

ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" </dev/null

brew update

# Setup Terminal
brew install zsh zsh-completions
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
git clone https://github.com/geometry-zsh/geometry ${HOME}/.oh-my-zsh/themes/geometry

# Node.js
brew install npm
brew install yarn


# Setup Terminal Install apps
brew install macvim
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
brew install awscli
brew install awslogs
brew install jq

vim +PluginInstall +qall

