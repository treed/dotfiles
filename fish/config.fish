set -U fish_greeting
eval (thefuck --alias | tr '\n' ';')
set --universal fish_user_paths $fish_user_paths ~/bin
alias edit="emacsclient -t"
set docker_machine (which docker-machine ^/dev/null)
if test -n "$docker_machine"
    eval (docker-machine env default | sed 's/-x/-xU/')
end
