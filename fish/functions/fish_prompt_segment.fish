function fish_prompt_segment
    set -l bg $argv[1]
    set -l fg $argv[2]
    set -l text $argv[3]
    if begin; test "$current_bg" != 'none'; and test "$bg" != "$current_bg"; end
        set_color -b $bg
        set_color $current_bg
        echo -n 
        set_color $fg
    else
        set_color -b $bg
        set_color $fg
    end
    set -g current_bg $bg
    echo -n " $text "
end
