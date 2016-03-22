function fish_prompt --description 'Write out the prompt'
    set -l last_status $status

    set -g current_bg "none"

    switch $fish_bind_mode
    case default
        fish_prompt_segment deb359 white NOR
    case insert
        fish_prompt_segment green white INS
    case visual
        fish_prompt_segment grey white VIS
    end

    fish_prompt_segment blue white (date +%T)

    if not set -q __fish_prompt_username
        set -l user (whoami)
        if test $user != treed
            set -g __fish_prompt_username "$user@"
        else
            set -g __fish_prompt_username
        end
    end

    if not set -q __fish_prompt_hostname
        if test -n "$SSH_CLIENT"
            set -g __fish_prompt_hostname (hostname|cut -d . -f 1)
        else
            set -g __fish_prompt_hostname
        end
    end

    if test -n "$__fish_prompt_username$__fish_prompt_hostname"
        fish_prompt_segment cyan white "$__fish_prompt_username$__fish_prompt_hostname"
    end

    set -l prompt_status
    if test $last_status -ne 0
        set prompt_status ' ' (set_color $fish_color_status) "[$last_status]" "$normal"
    end

    fish_prompt_segment 05766e  white (pwd)

    if git rev-parse --is-inside-work-tree >/dev/null ^&1
        set dirty (git status -s --ignore-submodules=dirty ^/dev/null)
        set ref (basename (git symbolic-ref HEAD ^/dev/null))
        if test -z "$ref"
            set ref (basename (git show-ref --head -s --abbrev | head -n1 ^/dev/null))
        end

        if test -n "$dirty"
            fish_prompt_segment cb4b16 white " $ref±"
        else
            fish_prompt_segment green white " $ref"
        end
    end

    set kubectl (which kubectl ^/dev/null)
    if test -n "$kubectl"
        set context (kubectl config view -o template --template='{{ index . "current-context" }}')
        echo $context | grep -q 'no value'; or fish_prompt_segment 326DE6 white "☸ $context"
    end

    if test $last_status -ne 0
        fish_prompt_segment white red $last_status
    end

    fish_prompt_segment_end

    echo
    echo -n "> "
end
