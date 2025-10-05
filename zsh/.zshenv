# Variables here are sourced automatically by ZSH
ZDOTDIR="$HOME/dotfiles/zsh"

# Source environment variables set by home-manager
hm_session_vars="$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
if [ -f "$hm_session_vars" ]; then
    source "$hm_session_vars"
fi
