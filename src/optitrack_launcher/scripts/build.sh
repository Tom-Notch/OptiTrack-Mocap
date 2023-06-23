#!/usr/bin/env bash
#
# Created on Thu Jun 22 2023 15:01:12
# Author: Mukai (Tom Notch) Yu
# Email: mukaiy@andrew.cmu.edu
# Affiliation: Carnegie Mellon University, Robotics Institute, the AirLab
#
# Copyright Ⓒ 2023 Mukai (Tom Notch) Yu
#

source $(dirname "$0")/variables.sh

docker buildx build --platform $PLATFORM \
                    --build-context home-folder-config=$(dirname "$0")/../docker/build-context/home-folder \
                    -t $DOCKER_USER/$IMAGE_NAME:$IMAGE_TAG \
                    - < $(dirname "$0")/../docker/$IMAGE_TAG.dockerfile

echo "Docker image $DOCKER_USER/$IMAGE_NAME:$IMAGE_TAG successfully built"
