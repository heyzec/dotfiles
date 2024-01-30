#!/bin/sh
# A git prepare-commit-msg hook that provides template

read -r msg
filename="$1"

if [ -n "$(sed -n '1p')" ]; then
    echo there is already something in the commit msg, ignoring
    sleep 1
    exit
fi

cmd="1s?^\$?$msg?"
sed -i '' -e "$cmd" "$filename"

