## Base <https://hub.docker.com/_/ubuntu>
ARG BASE_IMAGE_NAME="ubuntu"
ARG BASE_IMAGE_TAG="noble"
FROM ${BASE_IMAGE_NAME}:${BASE_IMAGE_TAG}

## Use bash as the default shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

## Create a barebones entrypoint that is conditionally updated throughout the Dockerfile
RUN echo "#!/usr/bin/env bash" >> /entrypoint.bash && \
    chmod +x /entrypoint.bash

## Install system dependencies
# hadolint ignore=DL3008
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
    ca-certificates \
    curl \
    xz-utils && \
    rm -rf /var/lib/apt/lists/*

## Install Gazebo
ARG GZ_VERSION="ionic"
# hadolint ignore=SC1091,DL3008
RUN echo -e "\n# Gazebo ${GZ_VERSION^}" >> /entrypoint.bash && \
    echo "export GZ_VERSION=\"${GZ_VERSION}\"" >> /entrypoint.bash && \
    curl --proto "=https" --tlsv1.2 -sSfL "https://packages.osrfoundation.org/gazebo.gpg" -o /usr/share/keyrings/pkgs-osrf-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/pkgs-osrf-archive-keyring.gpg] http://packages.osrfoundation.org/gazebo/ubuntu-stable $(source /etc/os-release && echo "${UBUNTU_CODENAME}") main" > /etc/apt/sources.list.d/gazebo-stable.list && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
    "gz-${GZ_VERSION}" && \
    rm -rf /var/lib/apt/lists/*

## Install Blender
ARG BLENDER_PATH="/root/blender"
ARG BLENDER_VERSION="4.3.0"
# hadolint ignore=SC2016
RUN echo -e "\n# Blender ${BLENDER_VERSION}" >> /entrypoint.bash && \
    echo "export PATH=\"${BLENDER_PATH}\${PATH:+:\${PATH}}\"" >> /entrypoint.bash && \
    curl --proto "=https" --tlsv1.2 -sSfL "https://download.blender.org/release/Blender${BLENDER_VERSION%.*}/blender-${BLENDER_VERSION}-linux-x64.tar.xz" -o "/tmp/blender_${BLENDER_VERSION}.tar.xz" && \
    mkdir -p "${BLENDER_PATH}" && \
    tar xf "/tmp/blender_${BLENDER_VERSION}.tar.xz" -C "${BLENDER_PATH}" --strip-components=1 && \
    rm "/tmp/blender_${BLENDER_VERSION}.tar.xz"

## Define the workspace of the project
ARG WS_PATH="/root/ws"
RUN echo -e "\n# Workspace" >> /entrypoint.bash && \
    echo "export WS_PATH=\"${WS_PATH}\"" >> /entrypoint.bash
WORKDIR "${WS_PATH}"

## Finalize the entrypoint
# hadolint ignore=SC2016
RUN echo -e "\n# Execute command" >> /entrypoint.bash && \
    echo -en 'exec "${@}"\n' >> /entrypoint.bash && \
    sed -i '$a source /entrypoint.bash --' ~/.bashrc
ENTRYPOINT ["/entrypoint.bash"]

## Copy the source code into the image
COPY . "${WS_PATH}"

## Set the default command
CMD ["bash"]

############
### Misc ###
############

## Set path to the procedurally generated resources for Gazebo
ENV GZ_SIM_RESOURCE_PATH="${WS_PATH}/assets/cache:${WS_PATH}/worlds"
