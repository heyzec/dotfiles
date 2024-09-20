# Uncomment this to profile zsh
# zmodload zsh/zprof

###############################################################################
##                                                                           ##
##           1. ZSH simple defaults (adapted from default .zshrc)            ##
##                                                                           ##
###############################################################################
setopt histignorealldups sharehistory

# Use emacs keybindings even if our EDITOR is set to vi
bindkey -e

# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh_history

# ZSH shell options and settings
unsetopt BEEP  # Disable beeping in zsh instead of globally in terminal

###############################################################################
##                                                                           ##
##           2. ZSH native completion (adapted from default .zshrc)          ##
##                                                                           ##
###############################################################################

# Use modern completion system (modified)
autoload -Uz compinit
for dump in ~/.zcompdump(N.mh+24); do
	compinit
done
compinit -C

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'



###############################################################################
##                                                                           ##
##                               3. Keybindings                              ##
##                                                                           ##
###############################################################################

autoload -z edit-command-line
zle -N edit-command-line
bindkey "^X^E" edit-command-line
bindkey "^[[A" up-line-or-search
bindkey "^[[B" down-line-or-search
bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line
bindkey "^H" backward-kill-word

# Fix keybindings for basic keys
# https://wiki.archlinux.org/title/Zsh#Key_bindings
typeset -g -A key
key[Home]="${terminfo[khome]}"
key[End]="${terminfo[kend]}"
key[PageUp]="${terminfo[kpp]}"
key[PageDown]="${terminfo[knp]}"
key[Delete]="${terminfo[kdch1]}"
# These are ncurses extensions and not terminfo standard
key[Control-Left]="${terminfo[kLFT5]}"
key[Control-Right]="${terminfo[kRIT5]}"

# setup key accordingly
[[ -n "${key[Home]}"          ]] && bindkey -- "${key[Home]}"          beginning-of-line
[[ -n "${key[End]}"           ]] && bindkey -- "${key[End]}"           end-of-line
[[ -n "${key[PageUp]}"        ]] && bindkey -- "${key[PageUp]}"        beginning-of-buffer-or-history
[[ -n "${key[PageDown]}"      ]] && bindkey -- "${key[PageDown]}"      end-of-buffer-or-history
[[ -n "${key[Delete]}"        ]] && bindkey -- "${key[Delete]}"        delete-char
[[ -n "${key[Control-Left]}"  ]] && bindkey -- "${key[Control-Left]}"  backward-word
[[ -n "${key[Control-Right]}" ]] && bindkey -- "${key[Control-Right]}" forward-word

# Finally, make sure the terminal is in application mode, when zle is
# active. Only then are the values from $terminfo valid.
if (( ${+terminfo[smkx]} && ${+terminfo[rmkx]} )); then
	autoload -Uz add-zle-hook-widget
	function zle_application_mode_start { echoti smkx }
	function zle_application_mode_stop { echoti rmkx }
	add-zle-hook-widget -Uz zle-line-init zle_application_mode_start
	add-zle-hook-widget -Uz zle-line-finish zle_application_mode_stop
fi


###############################################################################
##                                                                           ##
##                         4. Personal customisations                        ##
##                                                                           ##
###############################################################################

checkhealth_missing=()
function has() {
	check="$1"
	if (( $+commands[$check] )); then
		return 0
	else
		checkhealth_missing+=($check)
		return 1
	fi
}
function checkhealth() {
	if [ ${#checkhealth_missing[@]} -eq 0 ]; then
		echo "No issues found."
	else
		echo "Some commands are missing:"
		echo $checkhealth_missing
		return 1
	fi
}

# # Virtual environments
# export PATH="$HOME/.local/bin:$PATH"
#
# # rbenv
# export PATH="$HOME/.rbenv/bin:$PATH"
# eval "$(rbenv init - zsh)"
#
# # go
# export PATH="$HOME/go/bin:$PATH"
#
# # nodenv
# export PATH="$HOME/.nodenv/bin:$PATH"
# eval "$(nodenv init -)"
# export GOPATH="$HOME/go"


# Quickly jump around
setopt AUTO_PUSHD           # Push the current directory visited on the stack.
setopt PUSHD_IGNORE_DUPS    # Do not store duplicates in the stack.
setopt PUSHD_SILENT         # Do not print the directory stack after pushd or popd.
alias d='dirs -v'
for index ({0..9}) alias "d$index"="cd +${index}"; unset index



# source $ZDOTDIR/plugins/zsh-expand/zsh-expand.plugin.zsh
source $ZDOTDIR/aliases.zsh


# Dynamically change title of terminal window based on running command
function xterm_title_precmd () {
	print -Pn -- '\e]2;%n@%m %~\a'
	[[ "$TERM" == 'screen'* ]] && print -Pn -- '\e_\005{g}%n\005{-}@\005{m}%m\005{-} \005{B}%~\005{-}\e\\'
}
function xterm_title_preexec () {
	print -Pn -- '\e]2;%n@%m %~ %# ' && print -n -- "${(q)1}\a"
	[[ "$TERM" == 'screen'* ]] && { print -Pn -- '\e_\005{g}%n\005{-}@\005{m}%m\005{-} \005{B}%~\005{-} %# ' && print -n -- "${(q)1}\e\\"; }
}
if [[ "$TERM" == (Eterm*|alacritty*|aterm*|foot*|gnome*|konsole*|kterm*|putty*|rxvt*|screen*|wezterm*|tmux*|xterm*) ]]; then
	autoload -U add-zsh-hook
	add-zsh-hook -Uz precmd xterm_title_precmd
	add-zsh-hook -Uz preexec xterm_title_preexec
fi


###############################################################################
##                                                                           ##
##                     5. External shell program integration                 ##
##                                                                           ##
###############################################################################

# Color support for ls and some other commands (use .dircolors)
# Tell certain commands to use nvim (e.g. git, fc, sudoedit)
if has nvim; then
	export EDITOR=nvim
fi

# Color support for ls and some other commands (use .dircolors)
if has dircolors; then
	if [ -r $ZDOTDIR/dircolors ]; then
		eval "$(dircolors -b $ZDOTDIR/dircolors)"
	else
		eval "$(dircolors -b)"
	fi
fi

# Use starship to decorate shell prompt
# https://github.com/starship/starship
if has starship; then
	eval "$(starship init zsh)"
fi

# Use direnv to add hooks per directory
# https://github.com/direnv/direnv
if has direnv; then
	eval "$(direnv hook zsh)"
fi

# Use zoxide to jump around directories faster with `z`
# https://github.com/ajeetdsouza/zoxide
if has zoxide; then
	eval "$(zoxide init zsh)"
fi

# Use fzf keybindings
if [ -d /usr/share/doc/fzf/examples/ ]; then
    # Expected location for typical linux distributions
    fzf_folder="/usr/share/doc/fzf/examples"
elif [ -d /usr/local/opt/fzf/shell/ ]; then
    # Expected location for MacOS
    fzf_folder="/usr/local/opt/fzf/shell/"
elif [ -n "${commands[fzf-share]}" ]; then
    # For NixOS, we need to call this script to get the location
    fzf_folder="$(fzf-share)"
fi
if [ ! -z $fzf_folder ]; then
	source "$fzf_folder/key-bindings.zsh"
	source "$fzf_folder/completion.zsh"
else
	checkhealth_missing+=(fzf)
fi


###############################################################################
##                                                                           ##
##                               6. ZSH plugins                              ##
##                                                                           ##
###############################################################################

# 20 line plugin manager
# From https://github.com/mattmc3/zsh_unplugged
# Clone a plugin, identify its init file, source it, and add it to your fpath.
function plugin-load {
	local repo plugdir initfile initfiles=()
	: ${ZPLUGINDIR:=${ZDOTDIR:-~/.config/zsh}/plugins}
	for repo in $@; do
		plugdir=$ZPLUGINDIR/${repo:t}
		initfile=$plugdir/${repo:t}.plugin.zsh
		if [[ ! -d $plugdir ]]; then
			echo "Cloning $repo..."
			git clone -q --depth 1 --recursive --shallow-submodules \
				https://github.com/$repo $plugdir
		fi
		if [[ ! -e $initfile ]]; then
			initfiles=($plugdir/*.{plugin.zsh,zsh-theme,zsh,sh}(N))
			(( $#initfiles )) || { echo >&2 "No init file '$repo'." && continue }
			ln -sf $initfiles[1] $initfile
		fi
		fpath+=$plugdir
		(( $+functions[zsh-defer] )) && zsh-defer . $initfile || . $initfile
	done
}

repos=(
	# Syntax highlighting
	zsh-users/zsh-syntax-highlighting

	zsh-users/zsh-autosuggestions

	# Improved completion selection menu (requires fzf)
	Aloxaf/fzf-tab
)

plugin-load $repos

###############################################################################
##                                                                           ##
##                               6. Miscellaneous                            ##
##                                                                           ##
###############################################################################

# Source ~/.zshrc if it exists, where device-specific zsh configs are placed (not tracked)
if [ -e ~/.zshrc ]; then
	source ~/.zshrc
fi


unset -f has
# Uncomment this to profile zsh
# zprof


# vim: set noexpandtab:
