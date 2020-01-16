#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

if [ "${#}" -ne 1 ]; then
    echo "usage: ${0} <backupdir>"
    exit
fi

backupdir="${1}"

if [[ ! -d "${backupdir}" ]]; then
    echo "${backupdir} doesn't exist."
    exit
fi

dirs=(
    ~/.ssh
    ~/.password-store
    ~/.gnupg
    ~/Audio
    ~/Downloads
    ~/archive
    ~/books
    ~/config
    ~/documents
    ~/exercism
    ~/gtd
    ~/keys
    ~/pictures
    ~/projects
    ~/s7
    ~/school
    ~/second-brain
)

date=$(date '+%Y-%m-%d-%H-%M-%S')

if [[ -d "${backupdir}/${date}" ]]; then
    echo "${backupdir}/${date} does exist."
    exit
fi

mkdir "${backupdir}/${date}"

for dir in "${dirs[@]}"; do
    rsync -hazu --info=progress2 --filter=':- .gitignore' "${dir}" "${backupdir}/${date}"
done
