sudo apt update && sudo apt upgrade

sudo apt install tmux zsh ripgrep build-essential nodejs npm
# install zsh completions
echo 'deb http://download.opensuse.org/repositories/shells:/zsh-users:/zsh-completions/xUbuntu_20.04/ /' | sudo tee /etc/apt/sources.list.d/shells:zsh-users:zsh-completions.list
curl -fsSL https://download.opensuse.org/repositories/shells:zsh-users:zsh-completions/xUbuntu_20.04/Release.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/shells_zsh-users_zsh-completions.gpg > /dev/null
sudo apt update
sudo apt install zsh-completions

# install oh-my-zsh and plugins
sudo sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# install neovim
sudo apt-get install software-properties-common
sudo add-apt-repository -r ppa:neovim-ppa/unstable ppa:longsleep/golang-backports
sudo add-apt-repository -r ppa:longsleep/golang-backports
sudo apt-get update
sudo apt-get install golang-go neovim python-dev python-pip python3-dev python3-pip

git clone --depth 1 https://github.com/wbthomason/packer.nvim\
	 ~/.local/share/nvim/site/pack/packer/start/packer.nvim
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash

# install tpm
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

echo "Done"
