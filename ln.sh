ln -svf "${HOME}"/dotfiles/.zshrc "${HOME}"/.zshrc
ln -svf "${HOME}"/dotfiles/.zprofile "${HOME}"/.zprofile
ln -svf "${HOME}"/dotfiles/.tmux.conf "${HOME}"/.tmux.conf
ln -svf "${HOME}"/dotfiles/.alacritty.toml "${HOME}"/.alacritty.toml
mkdir -p "${HOME}"/.config && ln -svf "${HOME}"/dotfiles/.config/nvim "${HOME}"/.config/nvim

unamestr=$(uname)
if [ "$unamestr" = "Linux" ]; then
  echo "Linux"
  ln -svf "${HOME}"/dotfiles/linux/.xinitrc "${HOME}"/.xinitrc
  ln -svf "${HOME}"/dotfiles/linux/.Xresources "${HOME}"/.Xresources
  mkdir -p "${HOME}"/.config/bspwm && ln -svf "${HOME}"/dotfiles/linux/bspwm/bspwmrc "${HOME}"/.config/bspwm/bspwmrc
  mkdir -p "${HOME}"/.config/sxhkd && ln -svf "${HOME}"/dotfiles/linux/sxhkd/sxhkdrc "${HOME}"/.config/sxhkd/sxhkdrc
  mkdir -p "${HOME}"/.config && ln -svf "${HOME}"/dotfiles/linux/polybar "${HOME}"/.config/polybar
elif [ "$unamestr" = "Darwin"]; then
  ln -svf "${HOME}"/dotfiles/.config/aerospace "${HOME}"/.config/aerospace
  echo "Mac OS"
fi

