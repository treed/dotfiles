set -U fish_greeting
set --universal fish_user_paths $fish_user_paths ~/bin
alias vim=nvim
source ~/.config/fish/solarized.fish
set docker_machine (which docker-machine ^/dev/null)
if test -n "$docker_machine"
    eval (docker-machine env default | sed 's/-x/-xU/')
end
