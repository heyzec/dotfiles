###############################################################################
# 1. Setting sane default options for certain commands
###############################################################################
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'


###############################################################################
# 2. Command replacements
###############################################################################
# Use exa over ls
unalias ls
function ls() {
    if [ $# -eq 0 ]; then
        exa --color=auto --icons --sort=type
    else
        exa --color=auto --icons $@
    fi
}
# Use bat over cat
alias cat="bat"



###############################################################################
# 3. Shorthands
###############################################################################
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias open='xdg-open'
alias reload="exec $SHELL -l"


alias reload-swhkd='sudo pkill -HUP swhkd'


alias backup='cd /home/heyzec/Desktop/restic-backup-scripts && ./hacky-backup.sh'

# alias vim='nvim'
alias pwdc='echo -n $(pwd) | wl-copy'

function loc() {
    # TODO: set default to *
    pattern=$1
    find . -name pattern | xargs wc -l
}


alias lfcd='cd "$(command lf -print-last-dir "$@")"'
unalias z 2> /dev/null
z() {
  if [ $# -eq 0 ]; then
      lfcd
      return
  fi

  [ $# -gt 0 ] && zshz "$*" && return
  cd "$(zshz -l 2>&1 | fzf --height 40% --nth 2.. --reverse --inline-info +s --tac --query "${*##-* }" | sed 's/^[0-9,.]* *//')"
}
# function z() { zshz 2>&1 "$@" }


###############################################################################
# 4. Useful functions
###############################################################################

function forever() {
    while true; do
        echo Retrying "$@"
        $@
        sleep 1
    done;
}

function retry() {
    exit_code=1
    while [[ $exit_code -ne 0 ]]; do
        echo Retrying "$@"
        $@
        exit_code=$?
        sleep 1
    done
}

function mergerequests() {
    commit1=$1
    commit2=$2
    git log --format=%B $commit1..$commit2 | awk '/See merge request/ {print "- " $4}'
}



