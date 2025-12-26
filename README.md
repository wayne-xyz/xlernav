# xlernav

Navigation stack for lekiwi-based robots with a split architecture:
the Raspberry Pi is a thin sensor/actuator endpoint, and WSL is the
compute server for SLAM, depth, Nav2, and visualization.

## Quick Start

### Step 1: Install

WSL (Ubuntu 24.04, ROS 2 Jazzy):
```
bash scripts/install_ros2_wsl.sh
```

Raspberry Pi (Raspberry Pi OS 64-bit, Docker-based ROS 2 Jazzy):
```
ROS_DISTRO=jazzy bash scripts/install_ros2_pi.sh
```

### Step 2: Configure

- Use the same `ROS_DOMAIN_ID` on both Pi and WSL (default is `0`).
- Ensure both devices are on the same Wi-Fi network.
- Keep time in sync (NTP/chrony recommended).

### Step 3: Run (Connectivity Test)

On WSL:
```
source /opt/ros/jazzy/setup.bash
ros2 run demo_nodes_cpp talker
```

On Pi (inside Docker container):
```
docker run --rm -it --net=host --ipc=host \
  -e ROS_DOMAIN_ID=0 \
  ros:jazzy-ros-base

source /opt/ros/jazzy/setup.bash
ros2 run demo_nodes_cpp listener
```

If the listener receives messages, the network bridge is working.

## Roadmap

See `ROADMAP.md`.
