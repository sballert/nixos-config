#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

function lock {
    loginctl lock-session
}

function logout {
    xlogout
}

function reboot {
    systemctl reboot
}

function poweroff {
    systemctl poweroff
}

list=(lock logout reboot poweroff)

if choice=$(printf "%s\n" "${list[@]}" | rofi -dmenu); then
    "${choice}"
fi
