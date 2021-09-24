#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

nix-shell -p nodePackages.node2nix --run \
  'node2nix -i node-packages.json -o node-packages.nix -c composition.nix'
