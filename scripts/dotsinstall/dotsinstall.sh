#!/bin/sh
#

# Exit immediately if any command fails
set -e

# Exit immediately if any command fails
set -e

directory=$(dirname "$(realpath "$0")")
ITEMS_FILE="$directory/items.ini"

cd "$directory"
cd "$(git rev-parse --show-toplevel)"

help_string="usage: ./install <program> [--no-dry-run]"

if [ $# -eq 1 ]; then
    program="$1"
    dry_run=true
elif [ $# -eq 2 ]; then
    if [ "$1" = '--no-dry-run' ]; then
        program="$2"
        dry_run=false
    elif [ "$2" = '--no-dry-run' ]; then
        program="$1"
        dry_run=false
    else
        echo "$help_string"
        exit 1
    fi
else
    echo "$help_string"
    exit 1
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

parse_sections() {
    filename="$1"
    # Note: BSD grep does not GNU grep's -P flag
    cat "$filename" | grep '^\[[a-z]\+\]$' | sed -E 's/\[|\]//g'
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


# Parse section headers in config file
all_sections="$(parse_sections "$ITEMS_FILE")"

if ! echo "$all_sections" | grep -q "^$program\$"; then
    echo "$program is not a valid entry!"
    echo "ITEMS_FILE contains these programs:"
    echo $all_sections
    exit 1
fi


# Extract relevant section from config file
key_value_pairs=$(extract_section "$program" "$ITEMS_FILE")

# Extract values
src=$(extract_value src "$key_value_pairs")
dest=$(extract_value dest "$key_value_pairs")


if [ -z "$src" ]; then
    exit
fi

src_expanded=$(realpath "$src")
dest_expanded=$(echo "$dest" | subst)

if [ -e "$dest_expanded" ]; then
    echo "Failed to create link: $dest_expanded exists"
    exit 1
fi

if [ "$dry_run" = true ]; then
    echo ln -s -v "$src_expanded" "$dest_expanded"
    echo "Run again with --no-dry-run"
else
    set -x
    ln -s -v "$src_expanded" "$dest_expanded"
fi

