#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

function connect {
    local choice device
    if choice=$(bluetoothctl devices | awk '{ print $3 }' | rofi -dmenu); then
        device="$(bluetoothctl devices | grep "${choice}" | awk ' { print $2 }')"
        if bluetoothctl connect "${device}"; then
            notify-send "bluetoothctl: connection successful"
        else
            notify-send "bluetoothctl: Failed to connect"
        fi
    fi
}

function disconnect {
    if bluetoothctl disconnect; then
      notify-send "bluetoothctl: Successful disconnected"
    else
      notify-send "bluetoothctl: Failed to disconnect"
    fi
}

actions=(connect disconnect)

action=$(printf "%s\n" "${actions[@]}" | rofi -dmenu)

"${action}"
