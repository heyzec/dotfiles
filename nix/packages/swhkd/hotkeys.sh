#! @runtimeShell@
# set -x
PATH="$PATH:@path@"
DEVICE="keyd virtual keyboard"

# We let the window manager start swhks instead, because for some reason its not working?
# @psmisc@/bin/killall swhks
# @out@/bin/swhks --debug &

/run/wrappers/bin/pkexec @out@/bin/swhkd -c "$HOME"/.config/swhkd/swhkdrc --device "$DEVICE"  # --debug
