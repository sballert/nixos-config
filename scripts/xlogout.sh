#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

loginctl | grep -Ev "root|SESSION|listed" | awk '{print $1}' | xargs loginctl terminate-session
