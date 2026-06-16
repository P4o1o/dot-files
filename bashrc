[[ -n $PS1 ]] || return

# Editor

export EDITOR="nvim"
export VISUAL="nvim"
export PAGER="less"
export TZ='Europe/Rome'

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

# Homebrew in the path for MacOS + completition

if [[ -d /opt/homebrew/bin ]]; then
    export PATH="/opt/homebrew/bin:$PATH"
    source "$(brew --prefix 2>/dev/null)/etc/profile.d/bash_completion.sh" &>/dev/null ||  {
        # fallback to standard completions
        complete -A binding bind
        complete -A setopt set
        complete -A shopt shopt
        complete -A helptopic help
        complete -a alias unalias
        complete -b builtin
        complete -c type which
        complete -cf man sudo
        complete -d cd pushd rmdir
    }

else
    # Linux
    source /usr/share/bash-completion/bash_completion &>/dev/null || {
        source /etc/bash_completion &>/dev/null || {
            # fallback to standard completions
            complete -A binding bind
            complete -A setopt set
            complete -A shopt shopt
            complete -A helptopic help
            complete -a alias unalias
            complete -b builtin
            complete -c type which
            complete -cf man sudo
            complete -d cd pushd rmdir
        }
    }
fi

# adding bem in the path + completion
if [[ -d ~/.bem/bin ]]; then
    export PATH="~/.bem/bin:$PATH"
    for file in "/home/p4o1o/.bem/source"/*; do
        [[ -r $file ]] && source "$file"
    done
    source ~/.bem/bem_completion
fi

# Aliases

if [[ -r ~/.bash_aliases ]]; then
    source ~/.bash_aliases
fi

if [[ -d ~/.bash.aliases.d ]]; then
    for file in ~/.bash.aliases.d/*; do
        [[ -r $file ]] && source "$file"
    done
fi



UNAME=$(uname)

# less colors
export LESS_TERMCAP_mb=$(tput bold; tput setaf 1)
export LESS_TERMCAP_md=$(tput bold; tput setaf 1)
export LESS_TERMCAP_me=$(tput sgr0)
export LESS_TERMCAP_se=$(tput sgr0)
export LESS_TERMCAP_so=$(tput bold; tput setaf 3; tput setab 4)
export LESS_TERMCAP_ue=$(tput sgr0)
export LESS_TERMCAP_us=$(tput smul; tput bold; tput setaf 2)
export LESS_TERMCAP_mr=$(tput rev)
export LESS_TERMCAP_mh=$(tput dim)
export LESS_TERMCAP_ZN=$(tput ssubm)
export LESS_TERMCAP_ZV=$(tput rsubm)
export LESS_TERMCAP_ZO=$(tput ssupm)
export LESS_TERMCAP_ZW=$(tput rsupm)


if ls --color=auto /dev/null &>/dev/null; then
    export LS_COLORS='rs=0:di=01;34:ln=01;36:mh=00:pi=01;34;47:so=01;34;47:do=01;34;47:bd=01;34;47:cd=01;34;47:or=31;47:mi=31;47:su=37;41:sg=30;43:ca=00:tw=30;42:ow=34;42:st=37;44:ex=01;32:'\
'*.iso=01;34;100:*.img=01;34;100:*.dmg=01;34;100:'\
'*.zip=01;34;43:*.tar=01;34;43:*.tgz=01;34;43:*.txz=01;34;43:*.tbz=01;34;43:*.tbz2=01;34;43:*.gz=01;34;43:*.bz2=01;34;43:*.xz=01;34;43:*.zst=01;34;43:*.rar=01;34;43:*.7z=01;34;43:'\
'*.pdf=01;90:*.ps=01;90:*.eps=01;90:*.doc=01;90:*.docx=01;90:*.odt=01;90:*.rtf=01;90:*.xls=01;90:*.xlsx=01;90:*.ods=01;90:*.ppt=01;90:*.pptx=01;90:*.odp=01;90:*.epub=01;90:'\
'*.txt=01;90:*.md=01;90:*.markdown=01;90:*.rst=01;90:*.adoc=01;90:*.org=01;90:*.log=01;90:*.csv=01;90:*.tsv=01;90:*.json=01;90:*.yaml=01;90:*.yml=01;90:*.toml=01;90:*.ini=01;90:*.conf=01;90:*.cfg=01;90:*.env=01;90'
    alias ls='ls -p --color=auto'
else
     export LSCOLORS='ExGxEhEhCxEhEhhbadacec'
     alias ls='ls -p -G'
fi

if grep --color=auto < /dev/null &>/dev/null; then
    alias grep='grep --color=auto'
fi

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# Command Prompt
# [exit codes!]<user>@<hostname>#<uname>:<cwd>[[git branch]]<$|#>

COLOR_RESET="$(tput sgr0 2>/dev/null)"
COLOR_BOLD="$(tput bold 2>/dev/null)"
COLOR_WHITE="$(tput setaf 7 2>/dev/null)"
COLOR_RED="$(tput setaf 1 2>/dev/null)"
COLOR_GREEN="$(tput setaf 2 2>/dev/null)"
COLOR_BLUE="$(tput setaf 4 2>/dev/null)"
COLOR_CYAN="$(tput setaf 6 2>/dev/null)"
COLOR_YELLOW="$(tput setaf 3 2>/dev/null)"
UNAME="$(uname)"

PS1='$( exit_code=$? ; (($exit_code!=0)) && echo "\[${COLOR_RED}\]${exit_code}!\[$COLOR_RESET\] - " )'
PS1+='\[${COLOR_CYAN}\]$( (( UID==0 )) && echo "\[${COLOR_RED}\]" )\u\[${COLOR_RESET}${COLOR_BOLD}\]@'
PS1+='\[${COLOR_GREEN}\]\h\[${COLOR_RESET}${COLOR_BOLD}\]#'
PS1+='\[${COLOR_RESET}${COLOR_BLUE}\]${UNAME}\[${COLOR_RESET}\]: '
PS1+='\w'
PS1+='$( branch=$( git rev-parse --abbrev-ref HEAD 2>/dev/null ); [[ -n $branch && $branch != HEAD ]] && echo "\[${COLOR_CYAN}\][git:$branch]\[${COLOR_RESET}]" )'
[[ -n $SSH_CLIENT ]] && PS1+='(ssh) '
PS1+='\[${COLOR_BOLD}\]\$\[${COLOR_RESET}\] '

