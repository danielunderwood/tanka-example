#! /bin/bash
# This should be doable with a nix-shell #!, but it errors for whatever reason

set +e

echo "----- Running pre-commit script -----"
set -x
nixpkgs-fmt .
tk fmt .
set +x
echo "----- pre-commit script done! -----"