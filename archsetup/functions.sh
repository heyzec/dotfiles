#!/bin/bash

function section {
    echo "$(
        tput bold
        echo "-------------------------------------------------------------------------"
        echo "                    " "$@"
        echo "-------------------------------------------------------------------------"
        tput sgr0
    )" | tee /tmp/archsetup-fifo
}

function info {
    echo "$(
        tput setaf 6
        tput bold
        echo -ne "[INFO] "
        tput sgr0
        tput bold
        echo "$@"
        tput sgr0
    )" | tee /tmp/archsetup-fifo
}

function query {
    echo $(
        tput setaf 3
        tput bold
        echo -ne "[QUERY] "
        tput sgr0
        tput bold
        echo "$@"
        tput sgr0
    ) | tee /tmp/archsetup-fifo
}

_() {
    line=$*

    if [[ -f /bin/yay ]]; then
        pm=yay
    else
        pm="sudo pacman"
    fi

    if [[ "$line" =~ ^\[.+\]* ]]; then
        section_name=${line//[\[\]]/}
        section "$section_name"
        return
    fi

    IFS=':' read -ra arr <<< "$line"
    package=`echo ${arr[0]}`
    description=`echo ${arr[1]}`
    info "installing $package - $description"
    eval $pm -S $package --noconfirm
    # yay -S $package --noconfirm --clean
}

export -f section
export -f info
export -f query
export -f _
