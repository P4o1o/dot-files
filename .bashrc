[[ -n $PS1 ]] || return

# Editor

export EDITOR="nvim"
export VISUAL="nvim"
export PAGER="less"

# History

export HISTSIZE=100000
export HISTFILESIZE=1200000
export HISTCONTROL=ignoredups:erasedups

shopt -s histappend
shopt -s checkwinsize

# Globbing

shopt -s cdspell
shopt -s extglob
shopt -s nullglob

# Bash ≥ 4

shopt -s autocd 2>/dev/null || true
shopt -s dirspell 2>/dev/null || true

# Autocompletion

if [[ -r /opt/homebrew/profile.d/bash_completion.sh ]]; then
	source /opt/homebrew/profie.d/bash_completition.sh
elif [ -r /usr/share/bash-completion/bash_completion ]; then
    source /usr/share/bash-completion/bash_completion
elif [ -r /etc/bash_completion ]; then
    source /etc/bash_completion
fi

if [[ -r ~/.bash_aliases ]]; then
    source ~/.bash_aliases
fi

if [[ -d ~/.bash.aliases.d ]]; then
    for file in ~/.bash.aliases.d/*; do
        [[ -r $file ]] && source "$file"
    done
fi


if [[ -d ~/.bem/bin ]]; then
    export PATH="~/.bem/bin:$PATH"
    source ~/.bem/bem_completion
fi

# Command Prompt
# [(exit codes)] <user>@<hostname>#<uname>:<cwd> [git branch] <$|#>


UNAME=$(uname)

if [[ -t 1 ]] && tput colors &>/dev/null && [[ "$(tput colors)" -ge 8 ]]; then
    
    if [ -x /usr/bin/dircolors ]; then
        test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
        alias ls='ls --color=auto'
        alias grep='grep --color=auto'
    fi
    
    # colored GCC warnings and errors
    export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
    
	COLOR_RESET="$(tput sgr0 2>/dev/null)"
	COLOR_BOLD="$(tput bold 2>/dev/null)"
	COLOR_WHITE="$(tput setaf 7 2>/dev/null)"
	COLOR_RED="$(tput setaf 1 2>/dev/null)"
	COLOR_GREEN="$(tput setaf 2 2>/dev/null)"
	COLOR_BLUE="$(tput setaf 4 2>/dev/null)"
	COLOR_CYAN="$(tput setaf 6 2>/dev/null)"
	COLOR_YELLOW="$(tput setaf 3 2>/dev/null)"

    PS1='$( exit_code=$? ; (($exit_code!=0)) && echo "\[${COLOR_RED}\]${exit_code}!" )'
    PS1+='\[${COLOR_CYAN}\]$( (( UID==0 )) && echo "\[${COLOR_RED}\]" )\u\[${COLOR_RESET}\]@'
    PS1+='\[${COLOR_GREEN}\]\h\[${COLOR_RESET}\]#'
    PS1+='\[${COLOR_BLUE}\]${UNAME}\[${COLOR_RESET}\]:'
    PS1+='\w'
    PS1+='$( branch=$( git rev-parse --abbrev-ref HEAD 2>/dev/null ); [[ -n $branch && $branch != HEAD ]] && echo "\[${COLOR_CYAN}\][git:$branch]\[${COLOR_RESET}\]" )'
    PS1+='$>'
else

    PS1='$( exit_code=$? ; (($exit_code!=0)) && echo "${exit_code}!" )'
    PS1+='\u@\h#${UNAME}:\w'
    PS1+='$( branch=$( git rev-parse --abbrev-ref HEAD 2>/dev/null ); [[ -n $branch && $branch != HEAD ]] && echo "[git:$branch]" )'
    PS1+='$>'

fi
