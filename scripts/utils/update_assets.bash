#!/usr/bin/env bash
### Update assets by updating git submodules
### Usage: update_assets.bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")" &>/dev/null && pwd)"
REPOSITORY_DIR="$(dirname "$(dirname "${SCRIPT_DIR}")")"
ASSETS_DIR="${REPOSITORY_DIR}/assets"


## Update git submodules
GIT_SUBMODULE_UPDATE_CMD=(
    git
    -C "${REPOSITORY_DIR}"
    submodule
    update
    --remote
    --recursive
    "${ASSETS_DIR}"
)
echo -e "\033[1;90m[TRACE] ${GIT_SUBMODULE_UPDATE_CMD[*]}\033[0m" | xargs
# shellcheck disable=SC2048
exec ${GIT_SUBMODULE_UPDATE_CMD[*]}
