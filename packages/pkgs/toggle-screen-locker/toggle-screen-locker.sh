#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

if systemctl --user is-active --quiet xautolock-session
then
    systemctl --user stop xautolock-session
    notify-send "Screen-Locker disabled."
else
    systemctl --user start xautolock-session
    notify-send "Screen-Locker enabled."
fi
