for file in Xmodmap xsession xmobarrc bashrc bash_aliases vimrc gitconfig gtkrc-2.0; do
	ln -sf "$(pwd)/$file" ~/.$file
done

test -d ~/.vim/ || ln -sfT "$(pwd)/vi/" ~/.vim

cd autojump
./install.sh --local
