#!/usr/bin/env bash
#
# Created on Thu Jun 22 2023 15:01:30
# Author: Mukai (Tom Notch) Yu
# Email: mukaiy@andrew.cmu.edu
# Affiliation: Carnegie Mellon University, Robotics Institute, the AirLab
#
# Copyright Ⓒ 2023 Mukai (Tom Notch) Yu
#

source $(dirname "$0")/variables.sh

docker pull $DOCKER_USER/$IMAGE_NAME:$IMAGE_TAG
