#!/bin/bash

# Setup script for arch box




# HANDLE LOCALE HERE


# 2. Install graphical applications
#



# Loop through user input until the user gives a valid hostname, but allow the user to force save 
while true
do 
    read -p "Please name your machine:" HOSTNAME
    # hostname regex (!!couldn't find spec for computer name!!)
    if [[ "${HOSTNAME,,}" =~ ^[a-z][a-z0-9_.-]{0,62}[a-z0-9]$ ]]
    then 
        break 
    fi 
done

# Loop through user input until the user gives a valid username
while true
do 
    read -p "Please enter username:" USERNAME
    # username regex per response here https://unix.stackexchange.com/questions/157426/what-is-the-regex-to-validate-linux-users
    # lowercase the username to test regex
    if [[ "${USERNAME,,}" =~ ^[a-z_]([a-z0-9_-]{0,31}|[a-z0-9_-]{0,30}\$)$ ]]
    then 
        break
    fi 
    echo "Invalid username."
done

useradd -m -G wheel -s /bin/bash $USERNAME

echo "Please enter password twice:"
passwd heyzec





# Multi-head setup

# ?reflector --country Singapore --age 12 --protocol https --sort rate --save /etc/pacman.d/mirrorlist
#
script_dir="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
# SCRIPTS_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"/scripts

bash "$script_dir/scripts/1-setup.sh"

SCRIPT_DIR=/home/$USERNAME/$(basename $script_dir)
SCRIPTS_DIR=$SCRIPT_DIR/scripts
mv $script_dir $SCRIPT_DIR
echo chowning $SCRIPT_DIR
chown -R $USERNAME $SCRIPT_DIR

export HOSTNAME
export USERNAME

runuser -u $USERNAME -- "$SCRIPTS_DIR/2-server.sh"
runuser -u $USERNAME -- "$SCRIPTS_DIR/3-minimalhalf.sh"
runuser -u $USERNAME -- "$SCRIPTS_DIR/4-windowed.sh"
runuser -u $USERNAME -- "$SCRIPTS_DIR/5-eyecandy.sh"
runuser -u $USERNAME -- "$SCRIPTS_DIR/6-max.sh"




