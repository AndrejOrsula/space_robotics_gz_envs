#!/usr/bin/env bash
### Generate procedural assets using Blender
### Usage: procgen_assets.bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")" &>/dev/null && pwd)"
REPOSITORY_DIR="$(dirname "${SCRIPT_DIR}")"
ASSETS_DIR="${REPOSITORY_DIR}/assets"
SRB_ASSETS_DIR="${ASSETS_DIR}/srb_assets"
PROCGEN_CACHE_DIR="${ASSETS_DIR}/cache"

## Config
SEED="${SEED:-"0"}"


# Generate lunar rocks
PROCGEN_CMD=(
    blender
    --factory-startup
    --background
    --offline-mode
    --enable-autoexec
    --python-exit-code 1
    --python "${SRB_ASSETS_DIR}/scripts/blender/procgen_assets.py"
    --
    --autorun_scripts "${SRB_ASSETS_DIR}/model/object/lunar_rock_procgen/geometry.py" "${SRB_ASSETS_DIR}/model/object/lunar_rock_procgen/material.py"
    --name lunar_rock
    --ext sdf
    --overwrite_min_age -1
    --seed "${SEED}"
    --num_assets 16
    --geometry_nodes '{"LunarRock": {"detail": 4, "scale": [0.15, 0.15, 0.1], "scale_std": [0.025, 0.025, 0.01]}}'
    --material LunarRock
    --texture_resolution 512
    --render_samples 2
    --render_thumbnail
    --thumbnail_resolution 128
    --outdir "${PROCGEN_CACHE_DIR}"
)
echo -e "\033[1;90m[TRACE] ${PROCGEN_CMD[*]}\033[0m" | xargs
"${PROCGEN_CMD[@]}"

# Generate lunar terrain (large)
PROCGEN_CMD=(
    blender
    --factory-startup
    --background
    --offline-mode
    --enable-autoexec
    --python-exit-code 1
    --python "${SRB_ASSETS_DIR}/scripts/blender/procgen_assets.py"
    --
    --autorun_scripts "${SRB_ASSETS_DIR}/model/terrain/lunar_surface_procgen/geometry.py" "${SRB_ASSETS_DIR}/model/terrain/lunar_surface_procgen/material.py"
    --name lunar_surface
    --ext sdf
    --overwrite_min_age -1
    --seed "${SEED}"
    --num_assets 1
    --geometry_nodes '{"LunarTerrain": {"density": 0.08, "scale": [40.0, 40.0, 4.0], "flat_area_size": 2.0, "rock_mesh_boolean": false}}'
    --material LunarSurface
    --texture_resolution 4096
    --render_samples 2
    --render_thumbnail
    --outdir "${PROCGEN_CACHE_DIR}"
)
echo -e "\033[1;90m[TRACE] ${PROCGEN_CMD[*]}\033[0m" | xargs
"${PROCGEN_CMD[@]}"

# Generate lunar terrains (small)
PROCGEN_CMD=(
    blender
    --factory-startup
    --background
    --offline-mode
    --enable-autoexec
    --python-exit-code 1
    --python "${SRB_ASSETS_DIR}/scripts/blender/procgen_assets.py"
    --
    --autorun_scripts "${SRB_ASSETS_DIR}/model/terrain/lunar_surface_procgen/geometry.py" "${SRB_ASSETS_DIR}/model/terrain/lunar_surface_procgen/material.py"
    --name lunar_surface
    --ext sdf
    --overwrite_min_age -1
    --seed $(("${SEED}" + 1))
    --num_assets 4
    --geometry_nodes '{"LunarTerrain": {"density": 0.05, "scale": [20.0, 20.0, 1.5], "flat_area_size": 0.0, "rock_mesh_boolean": false}}'
    --material LunarSurface
    --texture_resolution 2048
    --render_samples 2
    --render_thumbnail
    --thumbnail_resolution 384
    --outdir "${PROCGEN_CACHE_DIR}"
)
echo -e "\033[1;90m[TRACE] ${PROCGEN_CMD[*]}\033[0m" | xargs
"${PROCGEN_CMD[@]}"


# Generate martian rocks
PROCGEN_CMD=(
    blender
    --factory-startup
    --background
    --offline-mode
    --enable-autoexec
    --python-exit-code 1
    --python "${SRB_ASSETS_DIR}/scripts/blender/procgen_assets.py"
    --
    --autorun_scripts "${SRB_ASSETS_DIR}/model/object/martian_rock_procgen/geometry.py" "${SRB_ASSETS_DIR}/model/object/martian_rock_procgen/material.py"
    --name martian_rock
    --ext sdf
    --overwrite_min_age -1
    --seed "${SEED}"
    --num_assets 4
    --geometry_nodes '{"MartianRock": {"detail": 5, "scale": [0.5, 0.5, 0.3], "scale_std": [0.05, 0.05, 0.03]}}'
    --material MartianRock
    --texture_resolution 1024
    --render_samples 2
    --render_thumbnail
    --thumbnail_resolution 256
    --outdir "${PROCGEN_CACHE_DIR}"
)
echo -e "\033[1;90m[TRACE] ${PROCGEN_CMD[*]}\033[0m" | xargs
"${PROCGEN_CMD[@]}"

# Generate martian terrain (large)
PROCGEN_CMD=(
    blender
    --factory-startup
    --background
    --offline-mode
    --enable-autoexec
    --python-exit-code 1
    --python "${SRB_ASSETS_DIR}/scripts/blender/procgen_assets.py"
    --
    --autorun_scripts "${SRB_ASSETS_DIR}/model/terrain/martian_surface_procgen/geometry.py" "${SRB_ASSETS_DIR}/model/terrain/martian_surface_procgen/material.py"
    --name martian_surface
    --ext sdf
    --overwrite_min_age -1
    --seed "${SEED}"
    --num_assets 1
    --geometry_nodes '{"MartianTerrain": {"density": 0.1, "scale": [64.0, 64.0, 8.0], "flat_area_size": 6.0, "rock_mesh_boolean": false}}'
    --material MartianSurface
    --texture_resolution 6144
    --render_samples 2
    --render_thumbnail
    --thumbnail_resolution 1024
    --outdir "${PROCGEN_CACHE_DIR}"
)
echo -e "\033[1;90m[TRACE] ${PROCGEN_CMD[*]}\033[0m" | xargs
"${PROCGEN_CMD[@]}"

# Generate martian terrains (small)
PROCGEN_CMD=(
    blender
    --factory-startup
    --background
    --offline-mode
    --enable-autoexec
    --python-exit-code 1
    --python "${SRB_ASSETS_DIR}/scripts/blender/procgen_assets.py"
    --
    --autorun_scripts "${SRB_ASSETS_DIR}/model/terrain/martian_surface_procgen/geometry.py" "${SRB_ASSETS_DIR}/model/terrain/martian_surface_procgen/material.py"
    --name martian_surface
    --ext sdf
    --overwrite_min_age -1
    --seed $(("${SEED}" + 1))
    --num_assets 4
    --geometry_nodes '{"MartianTerrain": {"density": 0.05, "scale": [20.0, 20.0, 2.5], "flat_area_size": 0.0, "rock_mesh_boolean": false}}'
    --material MartianSurface
    --texture_resolution 6144
    --render_samples 2
    --render_thumbnail
    --thumbnail_resolution 384
    --outdir "${PROCGEN_CACHE_DIR}"
)
echo -e "\033[1;90m[TRACE] ${PROCGEN_CMD[*]}\033[0m" | xargs
"${PROCGEN_CMD[@]}"


# Generate solar panel
PROCGEN_CMD=(
    blender
    --factory-startup
    --background
    --offline-mode
    --enable-autoexec
    --python-exit-code 1
    --python "${SRB_ASSETS_DIR}/scripts/blender/procgen_assets.py"
    --
    --autorun_scripts "${SRB_ASSETS_DIR}/model/object/solar_panel_procgen/geometry.py" "${SRB_ASSETS_DIR}/model/object/solar_panel_procgen/material0.py" "${SRB_ASSETS_DIR}/model/object/solar_panel_procgen/material2.py"
    --name solar_panel
    --ext sdf
    --overwrite_min_age -1
    --seed "${SEED}"
    --num_assets 1
    --geometry_nodes '{"SolarPanel": {"scale": [0.4, 0.3, 0.02], "border_size": 0.01, "panel_depth": 0.002, "frame_mat": "MAT:ScratchedMetal", "cells_mat": "MAT:SolarPanelGold"}}'
    --texture_resolution 2048
    --render_samples 2
    --render_thumbnail
    --outdir "${PROCGEN_CACHE_DIR}"
)
echo -e "\033[1;90m[TRACE] ${PROCGEN_CMD[*]}\033[0m" | xargs
"${PROCGEN_CMD[@]}"
