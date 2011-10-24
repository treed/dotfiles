for file in bashrc bash_aliases vimrc gitconfig; do
	ln -sf "$(pwd)/$file" ~/.$file
done

ln -sfT "$(pwd)/vim/" ~/.vim/
