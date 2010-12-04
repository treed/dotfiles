for file in bashrc vimrc gitconfig; do
	ln -sf "$(pwd)/$file" ~/.$file
done
