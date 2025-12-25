# Installation Overview

This document reflects what the install scripts currently set up on each
endpoint (Pi vs WSL).

## Raspberry Pi (Onboard)

- **Docker Engine**: Runs ROS 2 in a container on Raspberry Pi OS (Debian).
- **ROS 2 Jazzy (ros-base) image**: Pulled as `ros:${ROS_DISTRO}-ros-base`.
- **Host networking**: Required for ROS 2 DDS discovery over Wi-Fi.

Script: `scripts/install_ros2_pi.sh`

## WSL (Server/GPU)

- **ROS 2 Humble (desktop)**: Full desktop install with RViz for visualization.
- **colcon + rosdep**: Workspace build and dependency management.
- **argcomplete**: Shell completions for ROS tools.

## Notes

- Nav2, SLAM, Depth-Anything-3, and nvblox are planned but not installed by
  the current scripts yet.

Script: `scripts/install_ros2_wsl.sh`
