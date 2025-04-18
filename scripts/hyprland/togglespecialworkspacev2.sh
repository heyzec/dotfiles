#!/bin/sh
# Toggle floating scratchpad with a edge case:
# if app exists on another workspace toggle that workspace instead.
# Useful because mental overhead less that the shortcut alawys summons app, regardless of its loaction
# Improvement over the bind of:
# bind = $mainMod, <bind>, togglespecialworkspace, "$workspace_name"

workspace_name="$1"
class_name="$2"

running=$(hyprctl -j clients | jq -r ".[] | select(.class == \"$class_name\") | .workspace.id")

if [ "$running" != "" ] && [ "$running" -ge 0 ]; then
	# Edge case
	active=$(hyprctl activeworkspace -j | jq '.id')
	if [ "$active" -ne "$running" ]; then
		hyprctl dispatch workspace "$running"
	else
		hyprctl dispatch focuscurrentorlast
	fi
else
	# Normal case
	hyprctl dispatch togglespecialworkspace "$workspace_name"
fi
