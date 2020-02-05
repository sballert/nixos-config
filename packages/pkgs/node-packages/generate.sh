#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

nix-shell -p nodePackages.node2nix --run \
  'node2nix --nodejs-12 -i node-packages.json -o node-packages.nix -c composition.nix'
