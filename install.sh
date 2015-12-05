#!/bin/bash

for file in tmux.conf cvsignore Xmodmap xsession xmobarrc bashrc shellrc vimrc vimrc-plugins gitconfig gtkrc-2.0 zshrc nvimrc spacemacs; do
	ln -sf "$(pwd)/$file" ~/.$file
done

for dir in vim oh-my-zsh oh-my-zsh-custom nvim; do
    test -d ~/.$dir/ || ln -sf "$(pwd)/$dir/" ~/.$dir
done

test -d ~/.config/fish || mkdir -p ~/.config/fish
for fish_config in fish/*.fish; do
    ln -sf "$(pwd)/$fish_config" ~/.config/$fish_config
done

ln -sf "$(pwd)/fish/functions/" ~/.config/fish/functions

if uname -a | grep -q Darwin; then
    brew install fzf
else
    wget -O /tmp/fzf.tgz https://github.com/junegunn/fzf-bin/releases/download/0.9.11/fzf-0.9.11-linux_amd64.tgz
    pushd ~/bin > /dev/null
    rm fzf*
    tar xf /tmp/fzf.tgz
    mv -f fzf* fzf
    popd > /dev/null
    rm /tmp/fzf.tgz
fi
