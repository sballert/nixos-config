#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

mapfile -t connected < <(xrandr | awk '/ connected/ {print $1}')

order=('DP-1-8' 'DP-3')
primary="eDP-1"

for (( idx=${#order[@]}-1 ; idx>=0 ; idx-- )) ; do
    for display in "${connected[@]}"; do
        if [ "${display}" = "${order[idx]}" ]; then
            primary="${display}"
        fi
    done
done

execute=('xrandr')

for display in "${connected[@]}"; do
    if [ "${display}" = "${primary}" ]; then
        execute+=('--output' "${display}" '--auto')
    else
        execute+=('--output' "${display}" '--off')
    fi
done

echo "Command: " "${execute[@]}"
"${execute[@]}"
