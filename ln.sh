ln -svf "${HOME}"/dotfiles/.zshrc "${HOME}"/.zshrc
ln -svf "${HOME}"/dotfiles/.zprofile "${HOME}"/.zprofile
ln -svf "${HOME}"/dotfiles/.tmux.conf "${HOME}"/.tmux.conf
mkdir -p "${HOME}"/.config && ln -svf "${HOME}"/dotfiles/.config/nvim "${HOME}"/.config/nvim
