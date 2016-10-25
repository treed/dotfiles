set -U fish_greeting
eval (thefuck --alias | tr '\n' ';')
set --universal fish_user_paths $fish_user_paths ~/bin
alias edit="emacsclient -t"
