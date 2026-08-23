source ~/.git-prompt.sh

export PF_COL1=3
export PF_COL3=5

export PS1='\[\e[33;1m\]\u@\h \[\e[34m\]\w$(__git_ps1 " \[\e[35m\](\[\e[32m\]%s\[\e[35m\])") \[\e[34m\]\$ \[\e[00m\]'

eval "$(fzf --bash)"

pfetch
