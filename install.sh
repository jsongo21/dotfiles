#!/bin/bash

# link rc files
for i in .*rc .Xresources; do 
    ln -sv "$(pwd)/$i" ~/$i
done

# link directories
if [ ! -d ~/.config ]; then
  for i in .config; do 
      echo $i
      [[ ! -d "~/$i" ]] && ln -sv "$(pwd)/$i" ~/$i
  done
fi

# create vim colors directory
mkdir -pv ~/.vim/colors

# git clone base-16 repos
#[[ -d ~/base16-xresources ]] || git clone https://github.com/base16-templates/base16-xresources.git ~/base16-xresources
[[ -d ~/base16-vim ]] || git clone https://github.com/chriskempson/base16-vim.git ~/base16-vim
[[ -d ~/base16-shell ]] || git clone https://github.com/chriskempson/base16-shell.git ~/base16-shell

# copy files 
cp -r ~/base16-shell/* ~/.config/base16-shell
cp -r ~/base16-vim/colors/*.vim ~/.vim/colors 
