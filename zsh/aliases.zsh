# We make this file as standalone as possible
# At the same time, keep it bash compatible

if ! type has 2>/dev/null | grep -q 'function'; then
	function has() {
		check="$1"
		command -v "$check" &> /dev/null
		return $?
	}
fi


###############################################################################
# 1. Setting sane default options for certain commands
###############################################################################
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias ip='ip --color=auto'


###############################################################################
# 2. Command replacements
###############################################################################
# Use exa over ls
if has exa; then
	alias ls='' && unalias ls
	function ls() {
		if [ $# -eq 0 ]; then
			exa --color=auto --icons --sort=type
		else
			exa --color=auto --icons $@
		fi
	}
fi

# Use bat over cat
if has bat; then
	alias cat="bat"
fi
if has batman; then
	alias man="batman"
fi


###############################################################################
# 3. Shorthands
###############################################################################
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias reload="exec $SHELL -l"

# /bin/open exists on MacOS but not Linux
if ! command -v open &>/dev/null; then
	alias open='xdg-open'
fi


alias reload-swhkd='sudo pkill -HUP swhkd'


alias backup='cd /home/heyzec/Desktop/restic-backup-scripts && ./hacky-backup.sh'

# alias vim='nvim'
alias pwdc='echo -n $(pwd) | wl-copy'


if has lf; then
	alias lfcd='cd "$(command lf -print-last-dir "$@")"'
fi



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

function back() {
	nohup "$@" &> /dev/null &
}


# vim: set noexpandtab:
