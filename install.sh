#!/bin/bash

for file in tmux.conf cvsignore Xmodmap xsession xmobarrc bashrc shellrc vimrc vimrc-plugins gitconfig gtkrc-2.0 zshrc; do
	ln -sf "$(pwd)/$file" ~/.$file
done

for dir in vim oh-my-zsh oh-my-zsh-custom; do
    test -d ~/.$dir/ || ln -sf "$(pwd)/$dir/" ~/.$dir
done

if uname -a | grep -q Darwin; then
    brew install fzf
else
    wget -O /tmp/fzf.tgz https://github.com/junegunn/fzf-bin/releases/download/0.9.4/fzf-0.9.4-linux_amd64.tgz
    pushd ~/bin > /dev/null
    tar xf /tmp/fzf.tgz
    mv fzf* fzf
    popd > /dev/null
    rm /tmp/fzf.tgz
fi
