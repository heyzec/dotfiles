#!/usr/bin/env bash

export WOBSOCK=$XDG_RUNTIME_DIR/wob.sock
DEVICE="keyd virtual device"

mkfifo $WOBSOCK

swhks &
pkexec swhkd --device "$DEVICE"
