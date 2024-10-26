#!/usr/bin/env bash
### Open the Dev Container in VS Code
### Usage: open.bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")" &>/dev/null && pwd)"
REPOSITORY_DIR="$(dirname "${SCRIPT_DIR}")"

## Determine the workspace folder
if [[ -n "$1" ]]; then
    # Use the first argument as the workspace folder if provided
    WORKSPACE_FOLDER="$1"
else
    # Otherwise, try to extract the workspace folder from `./devcontainer.json`
    WORKSPACE_FOLDER="$(grep -Po '"workspaceFolder":.*?[^\\]",' "${SCRIPT_DIR}/devcontainer.json" | cut -d'"' -f4 || true)"
    if [[ -z "${WORKSPACE_FOLDER}" ]]; then
        # If `./devcontainer.json` does not contain the workspace folder, default to the root
        WORKSPACE_FOLDER="/"
    fi
fi

## Open the Dev Container in VS Code
CODE_REMOTE_CMD=(
    code --remote
    "dev-container+$(printf "%s" "${REPOSITORY_DIR}" | xxd -p | tr -d "[:space:]")"
    "${WORKSPACE_FOLDER}"
)
echo -e "\033[1;90m${CODE_REMOTE_CMD[*]}\033[0m" | xargs
# shellcheck disable=SC2048
exec ${CODE_REMOTE_CMD[*]}
