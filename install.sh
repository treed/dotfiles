for file in bashrc vimrc; do
	ln -sf "$(pwd)/$file" ~/.$file
done
