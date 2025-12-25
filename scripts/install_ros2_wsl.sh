#!/usr/bin/env bash
set -euo pipefail

if ! command -v lsb_release >/dev/null 2>&1; then
  echo "lsb_release not found; please install it first." >&2
  exit 1
fi

UBUNTU_CODENAME="$(lsb_release -cs)"
if [[ "${UBUNTU_CODENAME}" != "jammy" ]]; then
  echo "This script expects Ubuntu 22.04 (jammy). Detected: ${UBUNTU_CODENAME}" >&2
  exit 1
fi

sudo apt update
sudo apt install -y curl gnupg2 lsb-release software-properties-common

sudo add-apt-repository universe -y

sudo curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key \
  -o /usr/share/keyrings/ros-archive-keyring.gpg

echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] \
http://packages.ros.org/ros2/ubuntu ${UBUNTU_CODENAME} main" | \
  sudo tee /etc/apt/sources.list.d/ros2.list >/dev/null

sudo apt update
sudo apt install -y \
  ros-humble-desktop \
  python3-colcon-common-extensions \
  python3-rosdep \
  python3-argcomplete

sudo rosdep init || true
rosdep update

if ! grep -q "source /opt/ros/humble/setup.bash" ~/.bashrc; then
  echo "source /opt/ros/humble/setup.bash" >> ~/.bashrc
fi

echo "ROS 2 Humble (desktop) installed. Open a new shell or run: source /opt/ros/humble/setup.bash"
