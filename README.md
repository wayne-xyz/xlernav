# xlernav

Navigation stack for lekiwi-based robots with a split architecture:
the Raspberry Pi is a thin sensor/actuator endpoint, and WSL is the
compute server for SLAM, depth, Nav2, and visualization.

## Quick Start

### Step 1: Install ROS 2

WSL (Ubuntu 24.04, ROS 2 Jazzy):
```
bash scripts/install_ros2_wsl.sh
```

Raspberry Pi (Raspberry Pi OS 64-bit, Docker-based ROS 2 Jazzy):
```
ROS_DISTRO=jazzy bash scripts/install_ros2_pi.sh
```

### Step 2: Configure Networking

- Use the same `ROS_DOMAIN_ID` on both Pi and WSL (default is `0`).
- Ensure both devices are on the same Wi-Fi network.
- Keep time in sync (NTP/chrony recommended).

#### WSL2 <-> Pi DDS Connectivity (Mirrored Networking + CycloneDDS)

WSL2 discovery over DDS can fail with NAT + multicast. Use mirrored networking and
static peer discovery with CycloneDDS.

1) Enable WSL2 mirrored networking (Windows 11):
- Create `%UserProfile%\.wslconfig`:
```
[wsl2]
networkingMode=mirrored
```
- Apply: `wsl --shutdown`, then reopen WSL.

2) Install CycloneDDS RMW on both sides:
```
sudo apt update
sudo apt install -y ros-jazzy-rmw-cyclonedds-cpp
```

3) Set CycloneDDS config on WSL (interface `eth3`, peer = Pi IP):
```
cat > ~/.config/cyclonedds/cyclonedds.xml <<'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<CycloneDDS>
  <Domain>
    <General>
      <NetworkInterfaceAddress>eth3</NetworkInterfaceAddress>
      <AllowMulticast>false</AllowMulticast>
    </General>
    <Discovery>
      <Peers>
        <Peer address="192.168.50.124"/>
      </Peers>
    </Discovery>
  </Domain>
</CycloneDDS>
EOF
```

4) Set CycloneDDS config on Pi (interface `wlan0`, peer = WSL IP):
```
cat > ~/.config/cyclonedds/cyclonedds.xml <<'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<CycloneDDS>
  <Domain>
    <General>
      <NetworkInterfaceAddress>wlan0</NetworkInterfaceAddress>
      <AllowMulticast>false</AllowMulticast>
    </General>
    <Discovery>
      <Peers>
        <Peer address="192.168.50.219"/>
      </Peers>
    </Discovery>
  </Domain>
</CycloneDDS>
EOF
```

5) Export env vars in both shells:
```
source /opt/ros/jazzy/setup.bash
export ROS_DOMAIN_ID=0
export ROS_LOCALHOST_ONLY=0
export RMW_IMPLEMENTATION=rmw_cyclonedds_cpp
export CYCLONEDDS_URI=file://$HOME/.config/cyclonedds/cyclonedds.xml
```

6) Windows firewall:
- If DDS traffic is blocked, allow UDP 7400-7600 on Windows firewall.

### Step 3: Verify ROS 2 Connectivity

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

If the listener receives messages, the install + network setup is working.

## Roadmap

See `ROADMAP.md`.
