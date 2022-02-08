xcode-select --install

/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
echo 'eval "$(/usr/local/bin/brew shellenv)"' >> ${HOME}/.zprofile
eval "$(/usr/local/bin/brew shellenv)"

brew update

# Setup Terminal
brew install zsh zsh-completions
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
git clone https://github.com/geometry-zsh/geometry ${HOME}/.oh-my-zsh/themes/geometry

brew install npm
brew install yarn

# Setup Terminal Install apps
brew install vim
brew install --cask google-chrome
brew install --cask iterm2
brew install --cask visual-studio-code
brew install --cask rectangle
brew install --cask visual-studio-code
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
