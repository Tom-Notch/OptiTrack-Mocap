#!/usr/bin/env bash
#
# Created on Tue Jun 27 2023 13:40:14
# Author: Mukai (Tom Notch) Yu
# Email: mukaiy@andrew.cmu.edu
# Affiliation: Carnegie Mellon University, Robotics Institute, the AirLab
#
# Copyright Ⓒ 2023 Mukai (Tom Notch) Yu
#

export XAUTH=/tmp/.docker.xauth
export AVAILABLE_CORES=$(($(nproc) - 1))

export DOCKER_USER=theairlab
export IMAGE_NAME=tartan-slam
export IMAGE_TAG=focal-noetic

export CONTAINER_NAME=$IMAGE_NAME
export CONTAINER_HOME_FOLDER=/root

HOST_UID=$(id -u)
HOST_GID=$(id -g)
export HOST_UID
export HOST_GID

export DATASET_PATH="/home/$USER/bags" #! modify the dataset path with yours
