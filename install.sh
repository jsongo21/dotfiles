#!/bin/bash

# Create symlinks for dotfiles to $HOME
dot_files=$(ls .*rc .bash_profile .Xresources .alacritty.yml)
for i in $dot_files; do
    ln -svf "$(pwd)/$i" ~/$i
    #echo $i
done

# symlinks for ~/.config/
folders=$(ls -d */)
for i in $folders; do
    ln -svf "$(pwd)/$i" ~/.config
    #echo $i
done

