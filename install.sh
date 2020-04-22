#!/bin/bash

# rc files
for i in .*rc .Xresources; do
  ln -sf "$(pwd)/$i" ~/$i
done

# create vim colors directory
mkdir -p ~/.vim/colors

# download vim colours
curl -G https://raw.githubusercontent.com/lsdr/monokai/master/colors/monokai.vim -o ~/.vim/colors/monokai.vim
