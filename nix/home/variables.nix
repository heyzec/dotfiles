# We define environment variables here instead of tying them to a specific shell
# For reference, other places this could have been:
# .zprofile, .profile, .bash_profile
#
# However, since home-manager doesn't manager zsh in our config, we need to
# tell .zshrc (.zshenv in our case) to source the generated file
# See https://nix-community.github.io/home-manager/index.xhtml#_why_are_the_session_variables_not_set
{
  # There must not be runtime dependencies here, as the variables will be set in any otder
  home.sessionVariables = rec {
    # Define user directories based on XDG Base Directory specification
    # See https://wiki.archlinux.org/title/XDG_Base_Directory
    XDG_CONFIG_HOME = "$HOME/.config"; # user-specific configs (~> /etc)
    XDG_CACHE_HOME = "$HOME/.cache"; # non-essential data (~> /var/cache)
    XDG_DATA_HOME = "$HOME/.local/share"; # data files (~> /usr/share)
    XDG_STATE_HOME = "$HOME/.local/state"; # state files (~> /var/lib)

    # Fixes for offenders of not following XDG
    # See https://wiki.archlinux.org/title/XDG_Base_Directory#Partial
    # Python
    PYTHON_HISTORY = "${XDG_STATE_HOME}/python_history";
    # Go
    GOPATH = "${XDG_DATA_HOME}/go";
    GOMODCACHE = "${XDG_CACHE_HOME}/go/mod";
  };
}
