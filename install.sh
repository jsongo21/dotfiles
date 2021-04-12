#!/bin/bash

# Create symlinks for dotfiles to $HOME
rc_files=$(ls .*rc .bash_profile .Xresources)
for i in $rc_files; do
    ln -svf "$(pwd)/$i" ~/$i
done

folders=$(ls -d */)
for i in $folders; do
    ln -svf "$(pwd)/$i" ~/.config
done

