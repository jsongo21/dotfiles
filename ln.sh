ln -sf "${HOME}"/dotfiles/.zshrc "${HOME}"/.zshrc
ln -sf "${HOME}"/dotfiles/.zprofile "${HOME}"/.zprofile
ln -sf "${HOME}"/dotfiles/.tmux.conf "${HOME}"/.tmux.conf
ln -sf "${HOME}"/dotfiles/.vimrc "${HOME}"/.vimrc
mkdir -p "${HOME}"/.config/nvim
ln -sf "${HOME}"/dotfiles/.config/nvim/init.vim "${HOME}"/.config/nvim/init.vim
ln -sf "${HOME}"/dotfiles/coc-settings.json "${HOME}"/.vim/coc-settings.json
