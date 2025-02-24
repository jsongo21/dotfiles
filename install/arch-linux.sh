# Ensure yay is installed
if ! pacman -Q yay &>/dev/null; then
	echo "yay is not installed. Installing..."
	sudo pacman -S --needed git base-devel && git clone https://aur.archlinux.org/yay-bin.git && cd yay-bin && sudo makepkg -si
else
	echo "yay is already installed..."
fi

# Install Pacman & AUR packages using yay
yay -S --noconfirm - < pacman-packages

# ZSH

OH_MY_ZSH_PLUGINS_DIR=$HOME/.oh-my-zsh/custom/plugins
PLUGINS=(
	"zsh-autosuggestions"
	"zsh-syntax-highlighting"
	"zsh-history-substring-search"
)

sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

for plugin in "${PLUGINS[@]}"; do
	if [ -d "$OH_MY_ZSH_PLUGINS_DIR/$plugin" ]; then
		echo "$plugin already installed"
	else 
		echo "Installing $plugin for the first time"
		git clone --depth 1 https://github.com/zsh-users/$plugin ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/$plugin
	fi
done

git config --global credential.helper manager-core
git config --global credential.credentialStore gpg
