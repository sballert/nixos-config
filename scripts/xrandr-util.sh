#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

function usage {
    echo "Usage:"
    grep -E '\)[[:space:]]+# ' "${SELF}"
    exit
}

function primary {
    mapfile -t connected < <(xrandr | awk '/ connected/ {print $1}')

    local order=('DP-1-8' 'DP-3')
    local primary="eDP-1"

    for (( idx=${#order[@]}-1 ; idx>=0 ; idx-- )) ; do
        for display in "${connected[@]}"; do
            if [ "${display}" = "${order[idx]}" ]; then
                primary="${display}"
            fi
        done
    done

    local execute=('xrandr')

    for display in "${connected[@]}"; do
        if [ "${display}" = "${primary}" ]; then
            execute+=('--output' "${display}" '--auto')
        else
            execute+=('--output' "${display}" '--off')
        fi
    done

    echo "Command: " "${execute[@]}"
    "${execute[@]}"
}

function toggle {
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
}

SELF="${0}"

if [ "$#" -ne 1 ]; then
    usage
fi

action="${1}"
shift

case "${action}" in
    t|toggle )           # Toggle between all available displays
        toggle
    ;;

    p|primary )          # Enable the primary display
        primary
    ;;

    *)
        usage
esac
