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
