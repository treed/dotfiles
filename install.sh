for file in cvsignore Xmodmap xsession xmobarrc bashrc bash_aliases vimrc gitconfig gtkrc-2.0; do
	ln -sf "$(pwd)/$file" ~/.$file
done

test -d ~/.vim/ || ln -sfT "$(pwd)/vim/" ~/.vim

cd autojump
./install.sh --local
