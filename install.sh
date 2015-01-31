for file in tmux.conf cvsignore Xmodmap xsession xmobarrc bashrc shellrc vimrc vimrc-plugins gitconfig gtkrc-2.0 zshrc; do
	ln -sf "$(pwd)/$file" ~/.$file
done

for dir in vim oh-my-zsh oh-my-zsh-custom; do
    test -d ~/.$dir/ || ln -sf "$(pwd)/$dir/" ~/.$dir
done
