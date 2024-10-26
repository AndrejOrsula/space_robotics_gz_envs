# Space Robotics Gazebo Environments

<p align="left">
  <a href="https://github.com/AndrejOrsula/space_robotics_gz_envs/actions/workflows/docker.yml"> <img alt="Docker" src="https://github.com/AndrejOrsula/space_robotics_gz_envs/actions/workflows/docker.yml/badge.svg"></a>
</p>

A collection of Gazebo environments for simulating space robotics scenarios. All assets are procedurally generated using [Blender](https://blender.org) and automatically exported to the [SDF](http://sdformat.org) format for simulations inside Gazebo. Below are examples of the included [worlds](worlds):

<p align="center" float="middle">
  <a href="worlds/mars.sdf">
    <img width="49.0%" src="https://github.com/user-attachments/assets/7172e090-7e3e-402d-83a9-96954c1a9af4"/>
  </a><a href="worlds/moon.sdf">
    <img width="49.0%" src="https://github.com/user-attachments/assets/451af69e-70bd-4b3c-9f1c-8bb4120b612b"/>
  </a>
<br>
  <a href="worlds/mars_array.sdf">
    <img width="49.0%" src="https://github.com/user-attachments/assets/ca97f067-c4b0-4dd9-85ca-efbc2026fcd9"/>
  </a><a href="worlds/moon_array.sdf">
    <img width="49.0%" src="https://github.com/user-attachments/assets/e5984191-08da-49bb-9d0d-326ddf4d26cd"/>
  </a>
</p>

The assets are based on the work in [Space Robotics Bench](https://andrejorsula.github.io/space_robotics_bench) that targets Isaac Sim. However, all procedural pipelines for generating the assets are available in a separate [`srb_assets` repository](https://github.com/AndrejOrsula/srb_assets) that is included as a [submodule](assets). Below is a video showcasing the procedural generation directly inside Blender:

https://github.com/user-attachments/assets/5345ebe2-5692-4df4-8bea-1967cc4a2aa1

## Instructions

<details><summary><h3>Installation (Docker)</h3></summary>

This section provides instructions for running the simulation within a Docker container. If you are using a different operating system than Ubuntu, you may need to adjust the following steps accordingly or refer to the official documentation for each step.

#### 1. Install [Docker Engine](https://docs.docker.com/engine)

First, install Docker Engine by following the [official installation instructions](https://docs.docker.com/engine/install). For example:

```bash
curl -fsSL https://get.docker.com | sh
sudo systemctl enable --now docker

sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker
```

#### 2. Install [NVIDIA Container Toolkit](https://github.com/NVIDIA/nvidia-container-toolkit)

Next, install the NVIDIA Container Toolkit, which is required to enable GPU support for Docker containers. Follow the [official installation guide](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html) or use the following commands:

```bash
curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg && curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list
sudo apt-get update
sudo apt-get install -y nvidia-container-toolkit
sudo nvidia-ctk runtime configure --runtime=docker
sudo systemctl restart docker
```

#### 3. Clone the Repository

Next, clone the `space_robotics_gz_envs` repository locally. Make sure to include the `--recurse-submodules` flag to clone also the submodule containing the procedural pipelines for the simulation assets.

```bash
git clone --recurse-submodules https://github.com/AndrejOrsula/space_robotics_gz_envs.git
```

<details><summary><h4>4. (OPTIONAL) Build the Docker Image</h4></summary>

> [!NOTE]
> This step can be skipped if you prefer to use the pre-built Docker image from the [Docker Hub](https://hub.docker.com/r/andrejorsula/space_robotics_gz_envs). This results in a much faster setup process (just continue with the next step).

You can build the Docker image for `space_robotics_gz_envs` by running the provided [`.docker/build.bash`](https://github.com/AndrejOrsula/space_robotics_gz_envs/blob/main/.docker/build.bash) script.

```bash
space_robotics_gz_envs/.docker/build.bash
```

To ensure that the image was built successfully, run the following command. You should see the `space_robotics_gz_envs` image listed among recently created Docker images.

```bash
docker images
```

</details>

</details>

### Running the Simulation

#### Verify the Functionality of Gazebo

Let's start by verifying that Gazebo is functioning correctly on your system:

```bash
.docker/run.bash gz sim
```

#### (Optional) Generate Procedural Assets

> [!NOTE]
> This step can be skipped if you are using the pre-built Docker image from the [Docker Hub](https://hub.docker.com/r/andrejorsula/space_robotics_gz_envs).

To generate procedural assets, you can run the following command:

```bash
.docker/run.bash scripts/procgen_assets.bash
```

#### Example Worlds

You can launch Gazebo with one of the included worlds by passing its SDF basename as the argument. For example:

```bash
# Lunar sufarce with a rover that cam be controlled via the Teleop plugin
.docker/run.bash gz sim moon.sdf
```

```bash
# Grid (2x2) of lunar surfaces with some solar panels
.docker/run.bash gz sim moon_array.sdf
```

```bash
# Martian surface with a rover (robot requires tuning)
.docker/run.bash gz sim mars.sdf
```

```bash
# Grid (2x2) of martian surfaces
.docker/run.bash gz sim mars_array.sdf
```

```bash
# Empty world with enabled Resource Spawner plugin
.docker/run.bash gz sim _empty.sdf
```

## License

This project is dual-licensed under either the [MIT](LICENSE-MIT) or [Apache 2.0](LICENSE-APACHE) licenses.

All assets created by contributors of this repository and those generated from the included procedural pipelines are licensed under the [CC0 1.0 Universal](https://github.com/AndrejOrsula/srb_assets/blob/main/LICENSE-CC0) license. Some assets are based on modified third-party resources, which might require you to give appropriate credit to the original author. Please review [`srb_assets` repository](https://github.com/AndrejOrsula/srb_assets) for more information.

<a href="https://creativecommons.org/publicdomain/zero/1.0"><img src="https://licensebuttons.net/l/zero/1.0/88x31.png" width="88" height="31"></a>
