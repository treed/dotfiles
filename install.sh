for file in xsession xmobarrc bashrc bash_aliases vimrc gitconfig gtkrc-2.0; do
	ln -sf "$(pwd)/$file" ~/.$file
done

ln -sfT "$(pwd)/vim/" ~/.vim/
