#!/usr/bin/env bash
#
# Created on Thu Jun 22 2023 15:01:39
# Author: Mukai (Tom Notch) Yu
# Email: mukaiy@andrew.cmu.edu
# Affiliation: Carnegie Mellon University, Robotics Institute, the AirLab
#
# Copyright Ⓒ 2023 Mukai (Tom Notch) Yu
#

XAUTH=/tmp/.docker.xauth
AVAILABLE_CORES=$(($(nproc) - 1))

DOCKER_USER=tomnotch
IMAGE_NAME=optitrack-ros
IMAGE_TAG=melodic

CONTAINER_NAME=$IMAGE_NAME
CONTAINER_HOME_FOLDER=/root
PLATFORM=linux/amd64 # because NatNet SDK's .so is not built for ARM64: https://s3.amazonaws.com/naturalpoint/software/NatNetSDKLinux/ubuntu/NatNet_SDK_4.0_ubuntu.tar

HOST_UID=$(id -u)
HOST_GID=$(id -g)

DATASET_PATH="/home/tomnotch/bags" #! modify the dataset path with yours
