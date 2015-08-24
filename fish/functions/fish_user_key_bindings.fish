function fish_user_key_bindings
    fish_vi_key_bindings
    bind -M insert \e. history-token-search-backward

    function __fzf_select
        find * -path '*/\.*' -prune \
            -o -type f -print \
            -o -type d -print \
            -o -type l -print 2> /dev/null | fzf -m | while read item
            echo -n (echo -n "$item" | sed 's/ /\\\\ /g')' '
        end
        echo
    end

    function __fzf_ctrl_t
        if [ -n "$TMUX_PANE" -a "$FZF_TMUX" != "0" ]
            tmux split-window (__fzf_tmux_height) "fish -c 'fzf_key_bindings; __fzf_ctrl_t_tmux \\$TMUX_PANE'"
        else
            __fzf_select > $TMPDIR/fzf.result
            and commandline -i (cat $TMPDIR/fzf.result)
        end
    end

    function __fzf_ctrl_t_tmux
        __fzf_select > $TMPDIR/fzf.result
        and tmux send-keys -t $argv[1] (cat $TMPDIR/fzf.result)
    end

    function __fzf_ctrl_r
        if history | fzf +s +m > $TMPDIR/fzf.result
            commandline (cat $TMPDIR/fzf.result)
        else
            commandline -f repaint
        end
    end

    function __fzf_alt_c
        find * -path '*/\.*' -prune -o -type d -print 2> /dev/null | fzf +m > $TMPDIR/fzf.result
        if [ (cat $TMPDIR/fzf.result | wc -l) -gt 0 ]
            cd (cat $TMPDIR/fzf.result)
        end
        commandline -f repaint
    end

    function __fzf_tmux_height
        if set -q FZF_TMUX_HEIGHT
            set height $FZF_TMUX_HEIGHT
        else
            set height 40%
        end
        if echo $height | grep -q -E '%$'
            echo "-p "(echo $height | sed 's/%$//')
        else
            echo "-l $height"
        end
        set -e height
    end

    bind -M insert \ct '__fzf_ctrl_t'
    bind -M insert \cr '__fzf_ctrl_r'
    bind -M insert \ec '__fzf_alt_c'
end
