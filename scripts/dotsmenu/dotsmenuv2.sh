#!/usr/bin/env bash

terminal="${TERMINAL:=foot}"  # default to foot

subst() {
    # In case envsubst is not available, use sed
    if $(command -v envsubst); then
        envsubst
    else
        sed "s/\$HOME/${HOME//\//\\/}/"
    fi
}

ITEMS_FILE=$HOME/dotfiles/scripts/dotsmenu/items.ini

declare -A table
declare -a sections=()

section_i=0
while IFS= read -r line; do
    if [[ $line =~ ^\[([a-z-]+)\]$ ]]; then
        section=${BASH_REMATCH[1]}

        sections[${#sections[@]}]=$section

        section_i=$((section_i + 1))
    else
        [[ $line =~ ^\[([a-z]+)\]$ ]]
        IFS="=" read -a temp <<<"$line"
        key=${temp[0]}
        value=${temp[1]}
        table[$section,$key]=$value
    fi
done < $ITEMS_FILE

bar="$(printf "\n%s" ${sections[@]})"
config_names="${bar:1}"
selected_config_name=$( (echo "$config_names") | rofi -dmenu -p "Select config file")
selected_config_file=${table[$selected_config_name,file]}
selected_config_file_expanded=$(subst <<< "$selected_config_file")

if [ -z "$selected_config_file_expanded" ]; then
    notify-send "dotsmenu" "No valid entry selected!"
    exit
fi

if ! [ -e "$selected_config_file_expanded" ]; then
    notify-send "dotsmenu" "Path to $selected_config_name ($selected_config_file_expanded) does not exist!"
fi

if [ "${table[$selected_config_name,sudo]}" = "true" ]; then
    editor="sudoedit"
else
    editor="$EDITOR"
fi


# if ! [ -z "${table[$selected_config_name,posthook]}" ]; then
#     cmd=${table[$selected_config_name,posthook]}
#     export cmd
#     func() {
#         # echo yay running posthook
#         $cmd
#     }
# else
#     func() { :; }
# fi
# export -f func
# kitty --hold bash -c "$editor $selected_config_file_expanded; func"


if [ -n "${table[$selected_config_name,posthook]}" ]; then
    cmd=${table[$selected_config_name,posthook]}
else
    cmd=':'
fi

#magic="$editor $selected_config_file_expanded || exit; $cmd || bash"
#while nvim test || exit; do false && break || (echo "Press enter to edit"; read); done
magic="while $editor $selected_config_file_expanded || exit; do ($cmd) && break || (echo 'Command failed, press enter to edit'; read); done"
# bash -o pipefail -c "$magic"
$terminal -e bash -o pipefail -c "$magic"

