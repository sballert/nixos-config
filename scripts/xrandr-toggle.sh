#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# get info from xrandr
mapfile -t connected < <(xrandr | awk '/ connected/ {print $1}')
mapfile -t active < <(xrandr | awk '/ connected (primary )?[1-9]+/ {print $1}')

execute=('xrandr')
default=('xrandr')
i=1
switch=0

for display in "${connected[@]}"; do

    # build default configuraiton
    if [ $i -eq 1 ]; then
        default+=('--output' "${display}" '--auto')
    else
        default+=('--output' "${display}" '--off')
    fi

    # build "switching" configuration
    if [ $switch -eq 1 ]; then
        execute+=('--output' "${display}" '--auto')
        switch=0
    else
        execute+=('--output' "${display}" '--off')
    fi

    # check whether the next output should be switched on
    if [ "${display}" = "${active[0]}" ]; then
        switch=1
    fi

    i=$((i+1))
done

# check if the default setup needs to be executed
echo "Resulting Configuration:"
if echo "${execute[@]}" | grep -q "auto"; then
    echo "Command: " "${execute[@]}"
    "${execute[@]}"
else
    echo "Command: " "${default[@]}"
    "${default[@]}"
fi
