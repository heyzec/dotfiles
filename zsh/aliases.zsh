# Colored commands
function ls() { /bin/ls --color=auto "$@" }
function grep() { /bin/grep --color=auto "$@" }

alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

alias ..='cd ..'
alias reload="exec $SHELL -l"

# For CTFs
alias john='/opt/apps/john/john-shell'
alias hydra='/opt/apps/hydra/bin/hydra'
