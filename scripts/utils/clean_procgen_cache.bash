#!/usr/bin/env bash
### Remove the cache of procedural assets
### Usage: clean_procgen_cache.bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")" &>/dev/null && pwd)"
REPOSITORY_DIR="$(dirname "$(dirname "${SCRIPT_DIR}")")"
ASSETS_DIR="${REPOSITORY_DIR}/assets"
PROCGEN_CACHE_DIR="${ASSETS_DIR}/cache"

## Ask for confirmation
read -rp "Do you want to clean the procgen cache located at '${PROCGEN_CACHE_DIR}'? [y/N] " RESPONSE
if [[ "${RESPONSE,,}" != "y" ]]; then
    echo "Exiting..."
    exit 0
fi

## Remove the procgen cache
RM_CMD=(
    rm -r "${PROCGEN_CACHE_DIR}"
)
echo -e "\033[1;90m[TRACE] ${RM_CMD[*]}\033[0m" | xargs
# shellcheck disable=SC2048
exec ${RM_CMD[*]}
