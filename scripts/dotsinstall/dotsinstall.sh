#!/bin/sh
#

# Exit immediately if any command fails
set -e

# Exit immediately if any command fails
set -e

directory=$(dirname "$(realpath "$0")")
ITEMS_FILE="$directory/items.ini"

if [ $# -ne 1 ]; then
    echo "usage: ./install <program>"
    exit
fi

subst() {
    # In case envsubst is not available, use sed
    if command -v envsubst &> /dev/null; then
        envsubst
    else
        # The innermost sed is to escape slashes in path for outer sed command to be valid
        sed "s/\$HOME/$(echo "$HOME" | sed 's:/:\\\/:g')/"
    fi
}

extract_section() {
    section_name="$1"
    filename="$2"
    cat "$filename" | awk '
        BEGIN{state=0}
        /'"$section_name"'/&&state==0{state++;next}
        state==1&&/\[[a-z-]+\]/{exit;}
        state==1{print $0}
    ' | sed '/^$/d'
}

extract_value() {
    key="$1"
    key_value_pairs="$2"
    echo "$key_value_pairs" | grep "^$key=" | sed "s/^$key=//"
}

program="$1"

# Extract relevant section from config file
key_value_pairs=$(extract_section "$program" "$ITEMS_FILE")

# Extract values
src=$(extract_value src "$key_value_pairs")
dest=$(extract_value dest "$key_value_pairs")


if [ -z "$src" ]; then
    echo "No valid entry selected!"
    exit
fi

src_expanded=$(realpath "$src")
dest_expanded=$(echo "$dest" | subst)

set -x
ln --symbolic --no-target-directory --verbose "$src_expanded" "$dest_expanded"

