# vim:ft=zsh ts=2 sw=2 sts=2
#
# agnoster's Theme - https://gist.github.com/3712874
# A Powerline-inspired theme for ZSH
#
# # README
#
# In order for this theme to render correctly, you will need a
# [Powerline-patched font](https://gist.github.com/1595572).
#
# In addition, I recommend the
# [Solarized theme](https://github.com/altercation/solarized/) and, if you're
# using it on Mac OS X, [iTerm 2](http://www.iterm2.com/) over Terminal.app -
# it has significantly better color fidelity.
#
# # Goals
#
# The aim of this theme is to only show you *relevant* information. Like most
# prompts, it will only show git information when in a git working directory.
# However, it goes a step further: everything from the current user and
# hostname to whether the last call exited with an error to whether background
# jobs are running in this shell will all be displayed automatically when
# appropriate.

### Segment drawing
# A few utility functions to make it easy and re-usable to draw segmented prompts

CURRENT_BG='NONE'
SEGMENT_SEPARATOR=''

# Begin a segment
# Takes two arguments, background and foreground. Both can be omitted,
# rendering default background/foreground.
prompt_segment() {
  local bg fg
  [[ -n $1 ]] && bg="%K{$1}" || bg="%k"
  [[ -n $2 ]] && fg="%F{$2}" || fg="%f"
  if [[ $CURRENT_BG != 'NONE' && $1 != $CURRENT_BG ]]; then
    echo -n " %b%{$bg%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR%{$fg%} "
  else
    echo -n "%{$bg%}%{$fg%} "
  fi
  CURRENT_BG=$1
  [[ -n $3 ]] && echo -n $3
}

# End the prompt, closing any open segments
prompt_end() {
  if [[ -n $CURRENT_BG ]]; then
    echo -n " %{%k%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR"
  else
    echo -n "%{%k%}"
  fi
  echo "%{%f%}"
  CURRENT_BG=''
  echo -n "%{%F{bryellow}%}%#%{%f%k%}"
}

### Prompt components
# Each component will draw itself, and hide itself if no information needs to be shown

VIMODE="INS"
function zle-keymap-select {
    VIMODE="${${KEYMAP/vicmd/NOR}/(main|viins)/INS}"
    zle reset-prompt
}

zle -N zle-keymap-select

prompt_vimode() {
  if [[ ${VIMODE} = 'NOR' ]]; then
    prompt_segment 10 white "%B${VIMODE}"
  else
    prompt_segment yellow white "%B${VIMODE}"
  fi
}

prompt_time() {
  prompt_segment 22 white '%*'
}

# Context: user@hostname (who am I and where am I)
prompt_context() {
  local user=`whoami`
  local user_segment host_segment

  if [[ "$user" != "$DEFAULT_USER" ]]; then
    user_segment="$user@"
  fi
  if [[ -n "$SSH_CLIENT" ]]; then
    host_segment="%m"
  fi
  if [[ -n "$user_segment$host_segment" ]]; then
    prompt_segment cyan white "%(!.%{%F{yellow}%}.)$user_segment$host_segment"
  fi
}

# Git: branch/detached head, dirty status
prompt_git() {
  local ref dirty
  if $(git rev-parse --is-inside-work-tree >/dev/null 2>&1); then
    ZSH_THEME_GIT_PROMPT_DIRTY='±'
    dirty=$(parse_git_dirty)
    ref=$(git symbolic-ref HEAD 2> /dev/null) || ref="➦ $(git show-ref --head -s --abbrev |head -n1 2> /dev/null)"
    if [[ -n $dirty ]]; then
      prompt_segment 9 white
    else
      prompt_segment green white
    fi
    echo -n "${ref/refs\/heads\// }$dirty"
  fi
}

prompt_kube_context() {
  local context
  if test -x "$(which kubectl)"; then
    context=$(kubectl config view -o template --template='{{ index . "current-context" }}')
    if ! echo $context | grep -q 'no value'; then
      prompt_segment blue white "☸ $context"
    fi
  fi
}

# Dir: current working directory
prompt_dir() {
  prompt_segment 23 white '%~'
}

# Status:
# - was there an error
# - are there background jobs?
prompt_status() {
  local symbols
  symbols=()
  [[ $RETVAL -ne 0 ]] && symbols+="%{%F{red}%}$RETVAL"
  [[ $(jobs -l | wc -l) -gt 0 ]] && symbols+="%{%F{cyan}%}⚙"

  [[ -n "$symbols" ]] && prompt_segment violet white "$symbols"
}

## Main prompt
build_prompt() {
  RETVAL=$?
  prompt_vimode
  prompt_time
  prompt_context
  prompt_dir
  prompt_git
  prompt_kube_context
  prompt_status
  prompt_end
}

PROMPT='%{%f%b%k%}$(build_prompt) '
