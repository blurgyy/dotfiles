# Based on '3den' theme from OMZ

# ANSI color codes
# Must use %{...%} to quote colors.
# From: http://zsh.sourceforge.net/Doc/Release/Prompt-Expansion.html#Visual-effects
__COLOR(){
    local cyan white blue purple boldcyan boldgreen boldred cyanul reset
    cyan="\033[0;36m"
    white="\033[0;37m"
    blue="\033[0;34m"
    purple="\033[0;35m"
    boldcyan="\033[1;36m"
    boldblue="\033[1;34m"
    boldgreen="\033[1;32m"
    boldred="\033[1;31m"
    blueul="\033[4;34m"
    cyanul="\033[4;36m"
    reset="\033[0;0m"
    eval "echo -en %{\$reset%}%{\$$1%}"
}

__ISTHISROOT(){
    echo -en "$(__COLOR boldgreen)"
    [[ 0 -eq $(id -u) ]] && \
        echo -en "$(__COLOR boldred)#" || \
        echo -en "$"
}
__GITDIRTY(){
    local STATUS
    local -a FLAGS
    local GIT_PROMPT_DIRTY="*"
    local GIT_PROMPT_CLEAN=""
    local HIDEDIRTY='0'
    FLAGS=('--porcelain')
    if [[ "$HIDEDIRTY" != "1" ]]; then
        if [[ "$DISABLE_UNTRACKED_FILES_DIRTY" == "true" ]]; then
            FLAGS+='--untracked-files=no'
        fi
        case "$GIT_STATUS_IGNORE_SUBMODULES" in
            git) ;;
            *) FLAGS+="--ignore-submodules=${GIT_STATUS_IGNORE_SUBMODULES:-dirty}" ;;
        esac
        STATUS=$(command git status ${FLAGS} 2> /dev/null | tail -n1)
    fi
    if [[ -n $STATUS ]]; then
        echo "$GIT_PROMPT_DIRTY"
    else
        echo "$GIT_PROMPT_CLEAN"
    fi
}
__GITPROMPT(){
    GIT_PROMPT_PREFIX=" $(__COLOR white)("
    GIT_PROMPT_SUFFIX=")$(__COLOR reset)"
    ref=$(command git symbolic-ref HEAD 2> /dev/null) || \
        ref=$(command git rev-parse --short HEAD 2> /dev/null) || \
        return 0
    echo "${GIT_PROMPT_PREFIX}${ref#refs/heads/}$(__GITDIRTY)${GIT_PROMPT_SUFFIX}"
}

# Must use %{...%} to quote colors.
# From: http://zsh.sourceforge.net/Doc/Release/Prompt-Expansion.html#Visual-effects
PS1=' $(__COLOR cyan)%D{[%I:%M:%S]} $(__COLOR boldcyan)%~$(__GITPROMPT)
$(__COLOR boldgreen)%n$(__COLOR cyan)@$(__COLOR blue)%M$(__ISTHISROOT)$(__COLOR reset) '


# Syntax highlighting
# vim: set filetype=sh:

# Author: Blurgy
# Date:   Jul 24 2020
