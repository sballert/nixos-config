#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

id=$(xinput list | grep -Eo 'TouchPad\s*id\=[0-9]{1,2}' | grep -Eo '[0-9]{1,2}')
state=$(xinput list-props "${id}"|grep 'Device Enabled'|awk '{print $4}')

if [ "${state}" -eq 1 ]
then
    xinput disable "${id}"
    notify-send "Touchpad disabled."
else
    xinput enable "${id}"
    notify-send "Touchpad enabled."
fi
