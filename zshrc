ZSH=$HOME/.oh-my-zsh
ZSH_THEME="treed"
ZSH_CUSTOM=$HOME/.oh-my-zsh-custom
DEFAULT_USER="treed"

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

DISABLE_AUTO_UPDATE="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git command-not-found sprunge vi-mode)

source $ZSH/oh-my-zsh.sh

# Customize to your needs...
[ -s $HOME/.autojump/etc/profile.d/autojump.zsh ] && source ~/.autojump/etc/profile.d/autojump.zsh
source ~/.shellrc

bindkey "^R" history-incremental-search-backward
bindkey "^F" history-incremental-search-forward
bindkey "^[." insert-last-word
bindkey "^?" backward-delete-char

unsetopt correctall
