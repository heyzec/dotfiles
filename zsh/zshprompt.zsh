# Enable substitution
setopt PROMPT_SUBST

# Load version control information
autoload -Uz vcs_info
precmd() {
    vcs_info 2>/dev/null
}

# Format the vcs_info_msg_0_ variable
zstyle ':vcs_info:*'     check-for-changes true
zstyle ':vcs_info:*'     unstagedstr       '*'
zstyle ':vcs_info:*'     stagedstr         '+'
zstyle ':vcs_info:git:*' formats           '(%b%u%c)'
zstyle ':vcs_info:git:*' actionformats     '(%b|%a%u%c)'

# Form long prompt template
_X='%B%F{green}'                         # User
if [ -z "$SSH_CLIENT" -a -z "$SSH_TTY" ]; then
    _X+='%n'
else
    _X+='%M@%n'                          # %M - full machine hostname
fi
_X+='%f%b'
_X+=':'
_X+='%B%F{blue}%(3~|%-1~/…/%1~|%2~)%f%b' # Directory
_X+='%F{yellow}${vcs_info_msg_0_}%f'     # Git info
_X+=' '
_X+='%(!.#.›) '                          # Final terminator
ZSH_MYPROMPT_TEMPLATE_LONG=$_X

# Form short prompt template
_X='%B%(!.#.λ)%b'
_X="%(1j.%U$_X%u.$_X)"
_X="%(0?.%F{green}$_X%f.%F{red}$_X%f)"
_X+=' › '
ZSH_MYPROMPT_TEMPLATE_SHORT=$_X



foo() {
    if [[ $PREV == "short" && $MAGIC != "" ]]; then
        DEBUG+="redraw long"
        echo -n -e "\033[2K"   # Clear current line
        PREV="long"
        PREV_PARSED=$PARSED
        PROMPT=$ZSH_MYPROMPT_TEMPLATE_LONG
        return
    fi

    PARSED=$(print -P $ZSH_MYPROMPT_TEMPLATE_LONG)

    if [[ $PARSED != $PREV_PARSED ]]; then
        PREV="long"
        PREV_PARSED=$PARSED
        PROMPT=$ZSH_MYPROMPT_TEMPLATE_LONG
        return
    fi

    # No change
    #
    if [[ $MAGIC == "" ]]; then
        PROMPT=$ZSH_MYPROMPT_TEMPLATE_SHORT
        PREV="short"
        return
    fi

    DEBUG+="move cursor down"
    echo ""
    # echo -n -e "\033[E"    # Move cursor down one line



}
clrd() {
    # RPROMPT=$DEBUG
    DEBUG=""
}


typeset -a precmd_functions
precmd_functions+=(foo)
precmd_functions+=(clrd)






magic-enter() {
  # Only run MAGIC_ENTER commands when in PS1 and command line is empty
  # http://zsh.sourceforge.net/Doc/Release/Zsh-Line-Editor.html#User_002dDefined-Widgets
  if [[ -n "$BUFFER" || "$CONTEXT" != start ]]; then
      MAGIC=""
    return
  fi
  DEBUG+="move cursor up"
  echo -n -e "\033[F"    # Move cursor up one line
  MAGIC="magic"
}

# Wrapper for the accept-line zle widget (run when pressing Enter)

# If the wrapper already exists don't redefine it
(( ! ${+functions[_magic-enter_accept-line]} )) || return 0

case "$widgets[accept-line]" in
  # Override the current accept-line widget, calling the old one
  user:*) zle -N _magic-enter_orig_accept-line "${widgets[accept-line]#user:}"
    function _magic-enter_accept-line() {
      magic-enter
      zle _magic-enter_orig_accept-line -- "$@"
    } ;;
  # If no user widget defined, call the original accept-line widget
  builtin) function _magic-enter_accept-line() {
      magic-enter
      zle .accept-line
    } ;;
esac

zle -N accept-line _magic-enter_accept-line
# RPROMPT='%(?.✔.✘ %?)'
