#!/usr/bin/env bash
### Join a running Docker container
### Usage: join.bash [ID] [CMD]
set -e

SCRIPT_DIR="$(cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")" &>/dev/null && pwd)"
REPOSITORY_DIR="$(dirname "${SCRIPT_DIR}")"

## If the current user is not in the docker group, all docker commands will be run as root
if ! grep -qi /etc/group -e "docker.*${USER}"; then
    echo "[INFO] The current user '${USER}' is not detected in the docker group. All docker commands will be run as root."
    WITH_SUDO="sudo"
fi

## Config
# Name of the Docker image to join if an image with locally-defined name does not exist
DOCKERHUB_IMAGE_NAME="${DOCKERHUB_IMAGE_NAME:-"andrejorsula/space_robotics_gz_envs"}"
# Options for executing a command inside the container
DOCKER_EXEC_OPTS="${DOCKER_EXEC_OPTS:-
    --interactive
    --tty
}"
# Default command to execute inside the container
DEFAULT_CMD="${DEFAULT_CMD:-"bash"}"

## Parse ID and CMD
if [ "${#}" -gt "0" ]; then
    if [[ "${1}" =~ ^[0-9]+$ ]]; then
        ID="${1}"
        if [ "${#}" -gt "1" ]; then
            CMD=${*:2}
        else
            CMD="${DEFAULT_CMD}"
        fi
    else
        CMD=${*:1}
    fi
else
    CMD="${DEFAULT_CMD}"
fi

## Determine the name of the container to join
DOCKERHUB_USER="$(${WITH_SUDO} docker info 2>/dev/null | sed '/Username:/!d;s/.* //')"
PROJECT_NAME="$(basename "${REPOSITORY_DIR}")"
IMAGE_NAME="${DOCKERHUB_USER:+${DOCKERHUB_USER}/}${PROJECT_NAME}"
if [[ -z "$(${WITH_SUDO} docker images -q "${IMAGE_NAME}" 2>/dev/null)" ]] && [[ -n "$(curl -fsSL "https://registry.hub.docker.com/v2/repositories/${DOCKERHUB_IMAGE_NAME}" 2>/dev/null)" ]]; then
    IMAGE_NAME="${DOCKERHUB_IMAGE_NAME}"
fi
CONTAINER_NAME="${IMAGE_NAME##*/}"
CONTAINER_NAME="${CONTAINER_NAME//[^a-zA-Z0-9]/_}"

## Verify/select the appropriate container to join
RELEVANT_CONTAINERS=$(${WITH_SUDO} docker container list --all --format "{{.Names}}" | grep -i "${CONTAINER_NAME}" || :)
RELEVANT_CONTAINERS_COUNT=$(echo "${RELEVANT_CONTAINERS}" | wc -w)
if [ "${RELEVANT_CONTAINERS_COUNT}" -eq "0" ]; then
    echo >&2 -e "\033[1;31m[ERROR] No containers with the name '${CONTAINER_NAME}' found. Run the container first.\033[0m"
    exit 1
elif [ "${RELEVANT_CONTAINERS_COUNT}" -eq "1" ]; then
    CONTAINER_NAME="${RELEVANT_CONTAINERS}"
else
    print_usage_with_relevant_containers() {
        echo >&2 "Usage: ${0} [ID] [CMD]"
        echo "${RELEVANT_CONTAINERS}" | sort --version-sort | while read -r container; do
            id=$(echo "${container}" | grep -oE '[0-9]+$' || :)
            if [ -z "${id}" ]; then
                id=0
            fi
            echo >&2 -e " ${container}\t(ID=${id})"
        done
    }
    if [[ -n "${ID}" ]]; then
        if [ "${ID}" -gt "0" ]; then
            CONTAINER_NAME="${CONTAINER_NAME}${ID}"
        fi
        if ! echo "${RELEVANT_CONTAINERS}" | grep -qi "${CONTAINER_NAME}"; then
            echo >&2 -e "\033[1;31m[ERROR] Container with 'ID=${ID}' does not exist. Specify the correct ID as the first argument.\033[0m"
            print_usage_with_relevant_containers
            exit 2
        fi
    else
        echo >&2 -e "\033[1;31m[ERROR] Multiple containers with the name '${CONTAINER_NAME}' found. ID of the container must be specified as the first argument.\033[0m"
        print_usage_with_relevant_containers
        exit 2
    fi
fi

## Execute command inside the container
DOCKER_EXEC_CMD=(
    "${WITH_SUDO}" docker exec
    "${DOCKER_EXEC_OPTS}"
    "${CONTAINER_NAME}"
    "${CMD}"
)
echo -e "\033[1;90m[TRACE] ${DOCKER_EXEC_CMD[*]}\033[0m" | xargs
# shellcheck disable=SC2048
exec ${DOCKER_EXEC_CMD[*]}
