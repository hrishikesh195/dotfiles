#!/bin/bash

# Get full path of the script directory 
dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

# Link the dotfiles
files="vimrc screenrc gitignore_global tmux.conf"
for f in $files; do
	ln -s "$dir/$f" ~/."$f"
done

# Setup Vundle
git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
vim +PluginInstall +qall
