function fish_prompt_segment_end
    if test -n $current_bg
        set_color -b normal
        set_color $current_bg
        echo -n 
        set_color normal
    else
        set_color -b normal
        set_color normal
    end
end
