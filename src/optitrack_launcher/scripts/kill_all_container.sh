#!/usr/bin/env bash
#
# Created on Thu Jun 22 2023 15:01:53
# Author: Mukai (Tom Notch) Yu
# Email: mukaiy@andrew.cmu.edu
# Affiliation: Carnegie Mellon University, Robotics Institute, the AirLab
#
# Copyright Ⓒ 2023 Mukai (Tom Notch) Yu
#

. "$(dirname "$0")"/variables.sh

echo "Removing all containers"
docker rm -f "$(docker ps -aq)"
echo "Done"
