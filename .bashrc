[[ -n $PS1 ]] || return

# Editor

export EDITOR="vim"
export VISUAL="vim"
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
fi

# Command Prompt
# [(exit codes)] <user> - <hostname> <uname> <cwd> [git branch] <$|#>


COLOR_RESET=
COLOR_BOLD=
COLOR_WHITE=
COLOR_RED=
COLOR_GREEN=
COLOR_BLUE=
COLOR_CYAN=
COLOR_YELLOW=

if [[ -t 1 && ${TERM:-dumb} != dumb ]]; then
	COLOR_RESET=$(tput sgr0 2>/dev/null)
	COLOR_BOLD=$(tput bold 2>/dev/null)
	COLOR_WHITE=$(tput setaf 7 2>/dev/null)
	COLOR_RED=$(tput setaf 1 2>/dev/null)
	COLOR_GREEN=$(tput setaf 2 2>/dev/null)
	COLOR_BLUE=$(tput setaf 4 2>/dev/null)
	COLOR_CYAN=$(tput setaf 6 2>/dev/null)
	COLOR_YELLOW=$(tput setaf 3 2>/dev/null)
fi

PROMPT_UNAME=$(uname)

PS1='$( exit_code=$? ; (($exit_code!=0)) && echo "\[${COLOR_RED}\]($exit_code)\[${COLOR_RESET}\]" ) '
PS1+='$( (( UID==0 )) && echo "\[${COLOR_RED}\]" )\u\[${COLOR_RESET}\] - '
PS1+='\[${COLOR_GREEN}\]\h\[${COLOR_RESET}\] '
PS1+='(\[${COLOR_BLUE}\]'"${PROMPT_UNAME}"'\[${COLOR_RESET}\]) '
PS1+='\w '
PS1+='$( branch=$( git rev-parse --abbrev-ref HEAD 2>/dev/null ); [[ -n $branch && $branch != HEAD ]] && echo "\[${COLOR_CYAN}\][git:$branch]\[${COLOR_RESET}\]" ) '
PS1+='\[${COLOR_YELLOW}\]\$\[${COLOR_RESET}\] '
