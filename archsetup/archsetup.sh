#!/bin/bash

script_dir="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"


source "$script_dir/functions.sh"

section archsetup
# Loop through user input until the user gives a valid hostname
HOSTNAME=archie
USERNAME=heyzec
while true
do
    break
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
    break
    read -p "Please enter username:" USERNAME
    # username regex per response here https://unix.stackexchange.com/questions/157426/what-is-the-regex-to-validate-linux-users
    # lowercase the username to test regex
    if [[ "${USERNAME,,}" =~ ^[a-z_]([a-z0-9_-]{0,31}|[a-z0-9_-]{0,30}\$)$ ]]
    then
        break
    fi
    echo "Invalid username."
done

useradd -m -s /bin/bash $USERNAME

query "To set password of user, please enter password twice:"
# This cannot fail
while true; do
    if passwd $USERNAME; then
        break
    fi
done

cat > /home/$USERNAME/.bash_profile << END
export XDG_RUNTIME_DIR=/run/user/1000
export DISPLAY=:0
exec 3>&1 4>&2 >bashrc.log 2>&1
(
until [ -f /bin/i3 ]; do
    sleep 0.1
    echo waiting i3
done
i3
) & (
until [ -f /bin/startx ] && [ -f /bin/xterm ]; do
    sleep 0.1
    echo waiting x
done
startx
)
END

mkdir /etc/systemd/system/getty@tty2.service.d/
cat > /etc/systemd/system/getty@tty2.service.d/autologin.conf << END
[Service]
ExecStart=
ExecStart=-/sbin/agetty -o '-p -f -- \\\\u' --noclear --autologin $USERNAME %I \$TERM
END

chvt 2

until who | grep -P -q "$USERNAME\s+tty2"; do
    sleep 1
done
chvt 1
rm -rf /etc/systemd/system/getty@tty2.service.d/
rm /home/$USERNAME/.bash_profile




SCRIPT_DIR=/tmp/$(basename $script_dir)
SCRIPTS_DIR=$SCRIPT_DIR/scripts
cd "$SCRIPT_DIR"


cp -r "$script_dir" "$SCRIPT_DIR"
chown -R "$USERNAME" "$SCRIPT_DIR"

export HOSTNAME
export USERNAME
export SCRIPT_DIR
export SCRIPTS_DIR

bash "$script_dir/scripts/0-internet.sh"
pacman -S tmux --noconfirm --needed

bash "$script_dir/scripts/1-mirrorlist.sh"
bash "$script_dir/scripts/2-sudo.sh"


info Allowing user to sudo without password
sed -i 's/^# %wheel ALL=(ALL\(:ALL\)\?) NOPASSWD: ALL/%wheel ALL=(ALL) NOPASSWD: ALL/' /etc/sudoers


export XDG_RUNTIME_DIR=/run/user/1000
export DISPLAY=:0
rm /tmp/archsetup-fifo
runuser -u $USERNAME -- mkfifo /tmp/archsetup-fifo
runuser -u $USERNAME -- tmux new-session -s sess "
$(cat <<-END
tmux set mouse on
tmux split-window -t sess:0 "tail -f /tmp/archsetup-fifo"
tmux rotate-window -t sess:0
tmux resize-pane -t sess:0.0 -y 5


info Sudo user must enter password
bash "$SCRIPT_DIR/scripts/3-continue.sh"
bash "$SCRIPT_DIR/scripts/4-server.sh"
bash "$SCRIPT_DIR/scripts/5-minimalhalf.sh"
bash "$SCRIPT_DIR/scripts/6-windowed.sh"
bash "$SCRIPT_DIR/scripts/7-eyecandy.sh"
bash "$SCRIPT_DIR/scripts/8-desktop.sh"

bash "$SCRIPT_DIR/scripts/packages.sh"

bash "$SCRIPT_DIR/scripts/tweaks-dotfiles.sh"
bash "$SCRIPT_DIR/scripts/tweaks-intel.sh"
bash "$SCRIPT_DIR/scripts/tweaks-network.sh"
bash "$SCRIPT_DIR/scripts/tweaks-power-events.sh"

info Sudo user must enter password
sudo sed -i 's/%wheel ALL=(ALL\(:ALL\)\?) NOPASSWD: ALL/%wheel ALL=(ALL): ALL/' /etc/sudoers

# Stop X server from dying since X will exit once this process finishes
bash
END
)
"

