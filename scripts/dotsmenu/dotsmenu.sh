#!/bin/sh
# dotsmenu.sh
# Dotsmenu is a script that makes use of rofi to simplify editing your dotfiles!

# Exit immediately if any command fails
set -e

directory=$(dirname "$(realpath "$0")")
ITEMS_FILE="$directory/items.ini"
terminal="${TERMINAL:=foot}"  # default to foot

log() {
    notify-send "dotsmenu" "$@"
}

subst() {
    # In case envsubst is not available, use sed
    if command -v envsubst > /dev/null 2>&1; then
        envsubst
    else
        # The innermost sed is to escape slashes in path for outer sed command to be valid
        sed "s/\$HOME/$(echo "$HOME" | sed 's:/:\\\/:g')/"
    fi
}

parse_table_from_ini() {
    # Unused function: bash example to parse a associative array from ini
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
    done < "$ITEMS_FILE"
}

valid_section_regex="[a-z-]+"

parse_sections() {
    filename="$1"
    # Note: BSD grep does not support GNU grep's -P flag
    cat "$filename" | grep -E "^\[$valid_section_regex]$" | sed -E 's/\[|\]//g'
}

extract_section() {
    section_name="$1"
    filename="$2"
    cat "$filename" | awk '
        BEGIN{state=0}
        /'"$section_name"'/&&state==0{state++;next}
        state==1&&/\['"$valid_section_regex"'\]/{exit;}
        state==1{print $0}
    ' | sed '/^$/d'
}

extract_value() {
    key="$1"
    key_value_pairs="$2"
    echo "$key_value_pairs" | grep "^$key=" | sed "s/^$key=//"
}


# Parse section headers in config file
all_sections="$(parse_sections "$ITEMS_FILE")"

# Let user select which config
selected_config_name=$( (echo "$all_sections") | rofi -dmenu -p "Select config file")

# Extract relevant section from config file
key_value_pairs=$(extract_section "$selected_config_name" "$ITEMS_FILE")

# Extract values
file=$(extract_value file "$key_value_pairs")
sudo=$(extract_value sudo "$key_value_pairs")
posthook=$(extract_value posthook "$key_value_pairs")
cd=$(extract_value cd "$key_value_pairs")

selected_config_file_expanded=$(echo "$file" | subst)
if [ -z "$selected_config_file_expanded" ]; then
    log "No valid entry selected!"
    exit
fi

if ! [ -e "$selected_config_file_expanded" ]; then
    log "Path to $selected_config_name ($selected_config_file_expanded) does not exist!"
fi

if [ "$sudo" = "true" ]; then
    editor="sudoedit"
else
    editor="$EDITOR"
fi

if [ -n "$posthook" ]; then
    cmd="$posthook"
else
    cmd=':'
fi

magic="while $editor $selected_config_file_expanded || exit; do ($cmd) && break || (echo 'Command failed, press enter to edit'; read); done"
if [ -n "$cd" ]; then
    magic="cd $cd; $magic"
fi
$terminal -e bash -o pipefail -c "$magic"

