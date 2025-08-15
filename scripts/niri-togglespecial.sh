app_id="$1"
shift 1
command=$@

GAPSOUT=150

win_info=$(niri msg -j windows | jq --arg search "$app_id" '.[] | select (.app_id | test($search)) | { id, is_focused, is_floating }')
id=$(echo "$win_info" | jq -r '.id // empty')
# echo $win_info

if [ -n "$id" ]; then
  notify-send a  "Exists"
  # App exists, either focus or unfocus it
  is_focused=$(echo "$win_info" | jq -r '.is_focused // empty')
  if [ "$is_focused" = "true" ]; then
    # Moving window to temporary workspace
    notify-send "Moving away"
    niri msg action move-window-to-workspace --focus=false Scratchpad
    is_floating=$(echo "$win_info" | jq -r '.is_floating // empty')
    if [ -n "$is_floating" ]; then
      niri msg action toggle-window-floating --id $id
    fi
  else
    # Moving window to current workspace
    notify-send "Moving here"
    active=$(niri msg -j workspaces | jq '.[] | select(.is_active and .is_focused) | .idx')
    focused=$(niri msg -j focused-output  | jq '{ name } + .logical')
    niri msg action move-window-to-monitor --id $id $(echo "$focused" | jq -r '.name')
    niri msg action move-window-to-workspace --window-id $id $active

    is_floating=$(echo "$win_info" | jq -r '.is_floating // empty')
    if [ -z "$is_floating" ]; then
      niri msg action toggle-window-floating --id $id
    fi

    niri msg action focus-floating
    niri msg action focus-window --id $id

    # Resizing and centering the window
    output_width=$(echo "$focused" | jq '.width')
    output_height=$(echo "$focused" | jq '.height')
    win_width=$((output_width - ($GAPSOUT * 2)))   # Calculate window size
    win_height=$((output_height - ($GAPSOUT * 2)))
    pos_x=$(((output_width - win_width) / 2))      # Calculate position
    pos_y=$(((output_height - win_height) / 2))
    niri msg action set-window-width $win_width
    niri msg action set-window-height $win_height
    niri msg action move-floating-window -x $pos_x -y $pos_y
  fi
else
    # App does not exist, spawn it
    notify-send "Spawning $command"
    niri msg action spawn -- $command
    sleep 1
    win_info=$(niri msg -j windows | jq --arg search "$app_id" '.[] | select (.app_id | test($search)) | { id, is_focused, is_floating }')
    id=$(echo "$win_info" | jq -r '.id // empty')
    notify-send $id
fi
