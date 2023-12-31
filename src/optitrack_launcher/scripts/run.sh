#!/usr/bin/env bash
#
# Created on Tue Jun 27 2023 13:40:25
# Author: Mukai (Tom Notch) Yu
# Email: mukaiy@andrew.cmu.edu
# Affiliation: Carnegie Mellon University, Robotics Institute, the AirLab
#
# Copyright Ⓒ 2023 Mukai (Tom Notch) Yu
#

. "$(dirname "$0")"/variables.sh

xhost +local:*

if [ ! -f "$XAUTH" ]; then
	touch "$XAUTH"
	xauth_list=$(xauth nlist :0 | sed -e 's/^..../ffff/')
	if [ -n "$xauth_list" ]; then
		echo "$xauth_list" | xauth -f "$XAUTH" nmerge -
	else
		touch "$XAUTH"
	fi
	chmod a+r "$XAUTH"
fi

if [ "$(docker ps -a -q -f name="$CONTAINER_NAME")" ]; then
	echo "A container with name ""$CONTAINER_NAME"" is running, force removing it"
	docker rm -f "$CONTAINER_NAME"
	echo "Done"
fi

docker run \
	--name "$CONTAINER_NAME" \
	--hostname "$(hostname)" \
	--privileged \
	--platform "$PLATFORM" \
	--cpus "$AVAILABLE_CORES" \
	--gpus all \
	--runtime nvidia \
	--network host \
	--ipc host \
	--pid host \
	--ulimit core=-1 \
	--group-add audio \
	--group-add video \
	-e DISPLAY="$DISPLAY" \
	-e QT_X11_NO_MITSHM=1 \
	-e XAUTHORITY="$XAUTH" \
	-v /var/lib/systemd/coredump/:/cores \
	-v /tmp/.X11-unix/:/tmp/.X11-unix/:rw \
	-v "$XAUTH"":""$XAUTH" \
	-v "$(dirname "$0")/../../..:$CONTAINER_HOME_FOLDER/mocap" \
	-w "$CONTAINER_HOME_FOLDER/mocap" \
	--rm \
	-itd "$DOCKER_USER"/"$IMAGE_NAME":"$IMAGE_TAG"
