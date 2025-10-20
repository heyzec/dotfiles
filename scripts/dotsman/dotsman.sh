#!/bin/sh
# dotsman.sh
# Script to quickly install and edit dotfiles

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
# Wrapper to send desktop notifications
notify() {
    if command -v notify-send > /dev/null 2>&1; then
        notify-send "dotsman" "$@"
        return
    fi
    if command -v terminal-notifier > /dev/null 2>&1; then
        terminal-notifier -title "dotsman" -subtitle "$@"
        return
    fi
    echo "No program for sending notification: $@"
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

    # If using BSD stat instead of GNU, need to use -f instead of -c
    # But, when this script is run from within Nix, it will have GNU stat
    portable_stat() {
        file="$1"
        if stat --version >/dev/null 2>&1; then
            stat -L -c %d:%i "$file" # GNU (Linux)
        else
            stat -Lf %d:%i "$file" # BSD/macOS
        fi
    }

    if [ "$(portable_stat "$file1")" = "$(portable_stat "$file2")" ]; then
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

gen_dmenu_cmd() {
    # Parse section headers in config file
    all_sections="$(parse_sections "$items_file")"

    # Let user select which config using a dmenu-compatible program
    selected_config_name=$( (echo "$all_sections") | "$@" )
    if [ -z "$selected_config_name" ]; then
        exit
    fi

    # Extract relevant section from config file
    key_value_pairs=$(extract_section "$selected_config_name" "$items_file")
    if [ -z "$key_value_pairs" ]; then
        notify "No valid entry selected!"
        exit
    fi

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

    if ! [ -e "${cd:+${cd}/}$selected_config_file_expanded" ]; then
        notify "Path to $selected_config_name (${cd:+${cd}/}$selected_config_file_expanded) does not exist!"
        exit
    fi

    if [ "$sudo" = "true" ]; then
        editor="sudo -e" # the sudoedit wrapper doesn't exist on macos
    fi

    if [ -n "$posthook" ]; then
        cmd="echo Posthook: $posthook; $posthook"
    else
        cmd=':'
    fi

    magic="while $editor $selected_config_file_expanded || exit; do ($cmd) && break || (echo 'Command failed, press enter to edit'; read); done"
    if [ -n "$cd" ]; then
        magic="cd $cd; $magic"
    fi
    magic="cd $HOME/dotfiles; $magic"
    echo "$magic"
}

run_dmenu_spawn() {
    dmenu_cmd=$(gen_dmenu_cmd "$@")
    $terminal -e bash -o pipefail -c "$dmenu_cmd"
}

run_dmenu_here() {
    dmenu_cmd=$(gen_dmenu_cmd "$@")
    bash -o pipefail -c "$dmenu_cmd"
}

# run_install <program>
run_install() {
    program="$1"

    if [ $# -eq 1 ]; then
        program="$1"
        dry_run=true
    elif [ $# -eq 2 ]; then
        if [ "$1" = '--yes' ]; then
            program="$2"
            dry_run=false
        elif [ "$2" = '--yes' ]; then
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

    while true; do # this loop runs at most twice
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

        if [ "$dry_run" = false ]; then
            break
        fi
        read -p "Confirm? [Y/n]" answer
        case "$answer" in
            [Yy]* | "" ) dry_run=false ;;
            * ) echo "Aborting."; break ;;
        esac
    done
}

###############################################################################
# Main
###############################################################################

usage_install='install <program> [--yes]'
usage_dmenu='edit [-spawn | -here] <dmenu-compatible program> [args...]'

show_usage() {
    echo 'usage:'
    echo "  $1"
    if [ $# -gt 1 ]; then
        echo "  $2"
    fi
}


main() {
    usage=$(show_usage "$usage_install" "$usage_dmenu")

    # Behave differently if called from symlinks
    if [ "$(basename "$0")" = 'install' ]; then
        subcommand='install'
    elif [ "$(basename "$0")" = 'edit' ]; then
        subcommand='edit'
    else
        if [ $# -eq 0 ]; then
            echo "$usage"
            exit 1
        fi
        if [ "$1" = 'edit' ]; then
            subcommand='edit'
            shift 1
        elif [ "$1" = 'install' ]; then
            subcommand='install'
            shift 1
        else
            echo "$usage"
            exit 1
        fi
    fi

    if [ "$subcommand" = 'edit' ]; then
        spawn=true
        if [ "$1" = '-spawn' ]; then
            shift 1
        elif [ "$1" = '-here' ]; then
            shift 1
            spawn=false
        fi

        if [ "$1" = '' ]; then
            echo "$usage"
            exit 1
        fi

        if [ "$spawn" = "true" ]; then
            run_dmenu_spawn "$@"
        else
            run_dmenu_here "$@"
        fi
        exit 0
    elif [ "$subcommand" = 'install' ]; then
        run_install "$@"
        exit 0
    fi

    echo "$usage"
    exit 1
}

main "$@"
