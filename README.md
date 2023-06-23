# OptiTrack Mocap

## Overview

This repository contains the code for the OptiTrack motion capture client. Since [NatNet SDK](https://s3.amazonaws.com/naturalpoint/software/NatNetSDKLinux/ubuntu/NatNet_SDK_4.0_ubuntu.tar) only provides x86_64 libraries for now, we have to compile and run the rosnode in a x86_64 docker emulated on an arm64 machine, e.g. [Jetson Xavier NX](https://developer.nvidia.com/embedded/jetson-xavier-nx-devkit).

## Prerequisites

* [Docker](https://docs.docker.com/engine/install/ubuntu/)
* [ROS](http://wiki.ros.org/ROS/Installation)

## Usage

* To pull

  ```Shell
  ./src/optitrack_launcher/scripts/pull.sh
  ```

* To run

  ```Shell
  ./src/optitrack_launcher/scripts/run.sh
  ```

  And then attach the container to build and run the rosnode.

  ```Shell
  docker attach optitrack-ros
  catkin build
  mon launch natnet_ros_cpp natnet_ros.launch
  ```

* To build

  ```Shell
  ./src/optitrack_launcher/scripts/build.sh
  ```

## Contacts

* Author: Mukai (Tom Notch) Yu: [mukaiy@andrew.cmu.edu](mailto:mukaiy@andrew.cmu.edu)
