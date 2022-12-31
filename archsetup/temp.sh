export XDG_RUNTIME_DIR=/run/user/1000
runuser -u heyzec -- tmux new-session -s sess "
$(cat <<-END
tmux set mouse on
tmux split-window -t sess:0 "/bin/cat"
tmux rotate-window -t sess:0
tmux resize-pane -t sess:0.0 -y 5


# Stop X server from dying since X will exit once this process finishes
bash
END
)
"
