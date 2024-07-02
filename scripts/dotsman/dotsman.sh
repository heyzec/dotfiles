#!/bin/sh
# dotsman.sh

# Exit immediately if any command fails
set -e

# Change directory to root of dotfiles
containing=$(dirname "$(realpath "$0")")
cd "$containing"
cd "$(git rev-parse --show-toplevel)"

# Source file
items_file="$containing/items.ini"

# Get variables
editor="${EDITOR:=nano}"  # default to nano
terminal="${TERMINAL:=foot}"  # default to foot

# Constants
valid_section_regex="[a-z-]+"

###############################################################################
# Non-stateful utilities
###############################################################################

# notify <msg>...
# Wrapper around notify-send
notify() {
    notify-send "dotsman" "$@"
}

# Wrapper around envsubst with a poor man's fallback
subst() {
    # In case envsubst is not available, use sed
    if command -v envsubst > /dev/null 2>&1; then
        envsubst
    else
        # The innermost sed is to escape slashes in path for outer sed command to be valid
        sed "s/\$HOME/$(echo "$HOME" | sed 's:/:\\\/:g')/"
    fi
}

# is_same_file <file1> <file2>
# Check if <file1> and <file2> are actually the same file by symlinks
is_same_file() {
    file1="$1"
    file2="$2"
    if [ "$(stat -L -c %d:%i "$file1")" = "$(stat -L -c %d:%i "$file2")" ]; then
        return 0
    else
        return 1
    fi
}


###############################################################################
# File-parsing helpers
###############################################################################

# parse_sections <filename>
parse_sections() {
    filename="$1"
    # Note: BSD grep does not support GNU grep's -P flag
    # shellcheck disable=SC2002
    cat "$filename" | grep -E "^\[$valid_section_regex]$" | sed -E 's/\[|\]//g'
}

# extract_section <section_name> <filename>
# Extract a section from <filename> and output in the form of key-value pairs
extract_section() {
    section_name="$1"
    filename="$2"
    # shellcheck disable=SC2002
    cat "$filename" | awk '
        BEGIN{state=0}
        /\['"$section_name"'\]/&&state==0{state++;next}
        state==1&&/\['"$valid_section_regex"'\]/{exit;}
        state==1{print $0}
    ' | sed '/^$/d'
}

# extract_value <key> <key_value_pairs>
# Extract a value from key-value pairs
extract_value() {
    key="$1"
    key_value_pairs="$2"
    echo "$key_value_pairs" | grep "^$key=" | sed "s/^$key=//"
}


###############################################################################
# Tasks
###############################################################################

# link_section <header>
# Recursive function to link section and child sections
link_section() (
    # Use () instead of {} to scope variables by running in a subshell
    header="$1"

    # Extract relevant section from config file
    key_value_pairs=$(extract_section "$header" "$items_file")

    # Extract values
    src=$(extract_value src "$key_value_pairs")
    dest=$(extract_value dest "$key_value_pairs")
    call=$(extract_value call "$key_value_pairs")

    IFS=","
    for child in $call; do
        echo "Recursing: $header -> $child"
        link_section "$child"
    done

    if [ -z "$src" ]; then
        echo "Skipping, src is empty: $header"
        return
    fi

    src_expanded=$(realpath "$src")
    dest_expanded=$(echo "$dest" | subst)

    dest_expanded_parent=$(dirname "$dest_expanded")

    if [ ! -d "$dest_expanded_parent" ]; then
        if [ "$dry_run" = true ]; then
            echo mkdir -p "$dest_expanded_parent"
        else
            (set -x ; mkdir -p "$dest_expanded_parent")
        fi
    fi

    if [ -e "$dest_expanded" ]; then
        if is_same_file "$dest_expanded" "$src_expanded"; then
            echo "Dest exists and matches source, skipping: $header"
            return
        fi
        echo "Failed to create link: $dest_expanded exists"
        exit 1
    fi

    if [ "$dry_run" = true ]; then
        echo ln -s -v "$src_expanded" "$dest_expanded"
    else
        (set -x ; ln -s -v "$src_expanded" "$dest_expanded")
    fi
)

run_rofi() {
    # Parse section headers in config file
    all_sections="$(parse_sections "$items_file")"

    # Let user select which config
    selected_config_name=$( (echo "$all_sections") | rofi -dmenu -p "Select config file")

    # Extract relevant section from config file
    key_value_pairs=$(extract_section "$selected_config_name" "$items_file")

    # Extract values
    file=$(extract_value file "$key_value_pairs")
    sudo=$(extract_value sudo "$key_value_pairs")
    posthook=$(extract_value posthook "$key_value_pairs")
    cd=$(extract_value cd "$key_value_pairs")

    selected_config_file_expanded=$(echo "$file" | subst)
    if [ -z "$selected_config_file_expanded" ]; then
        notify "No valid entry selected!"
        exit
    fi

    if ! [ -e "$selected_config_file_expanded" ]; then
        notify "Path to $selected_config_name ($selected_config_file_expanded) does not exist!"
    fi

    if [ "$sudo" = "true" ]; then
        editor="sudoedit"
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
}

# run_install <program>
run_install() {
    program="$1"

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
            echo "$usage"
            exit 1
        fi
    else
        echo "$usage"
        exit 1
    fi

    # Parse section headers in config file
    all_sections="$(parse_sections "$items_file")"

    if ! echo "$all_sections" | grep -q "^$program\$"; then
        if [ "$program" != "all" ]; then
            echo "$program is not a valid entry!"
            echo "$items_file contains these programs:"
            # shellcheck disable=SC2086
            echo $all_sections
            exit 1
        fi
    fi

    if [ "$program" = "all" ]; then
        for section in $all_sections; do
            key_value_pairs=$(extract_section "$section" "$items_file")
            call=$(extract_value call "$key_value_pairs")
            if [ -n "$call" ]; then
                echo "Skipping: $section"
                continue
            fi
            link_section "$section"
        done;
    else
        link_section "$program"
    fi
    if [ "$dry_run" = true ]; then
        echo "Run again with --no-dry-run"
    fi
}

###############################################################################
# Main
###############################################################################

usage_install='install <program> [--no-dry-run]'
usage_rofi='rofi'

show_usage() {
    echo 'usage:'
    echo "  $1"
    if [ $# -gt 1 ]; then
        echo "  $2"
    fi
}


main() {
    # Behave differently if called from a symlink named "install"
    if [ "$(basename "$0")" = 'install' ]; then
        usage=$(show_usage "$usage_install")
        if [ $# -eq 0 ]; then
            echo "$usage"
            exit 1
        fi
        run_install "$@"
        exit 0
    fi

    usage=$(show_usage "$usage_install" "$usage_rofi")

    if [ $# -eq 0 ]; then
        echo "$usage"
        exit 1
    fi

    if [ "$1" = 'rofi' ]; then
        run_rofi
        exit 0
    fi

    if [ "$1" = 'install' ]; then
        shift 1
        run_install "$@"
        exit 0
    fi

    echo "$usage"
    exit 1
}

main "$@"
