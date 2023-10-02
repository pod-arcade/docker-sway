# sway

## Usage

### With Hardware Acceleration
```shell
docker run --rm \
 -it \
 --name "pod-arcade-sway" \
 -e DRI_DEVICE_MODE="NODE" \
 -e DISABLE_HW_ACCEL="false" \
 -e WAYLAND_DISPLAY="wayland-1" \
 -e DISPLAY=":0" \
 -e XDG_RUNTIME_DIR="/tmp/sway" \
 -e PULSE_SERVER="unix:/tmp/pulse/pulse-socket" \
 -e WLR_NO_HARDWARE_CURSORS="1" \
 -e WLR_XWAYLAND="/etc/sway/Xwayland" \
 -e WLR_RENDERER="gles2" \
 -e WLR_BACKENDS="headless" \
 -e FFMPEG_HARDWARE="1" \
 -p 6900:5900 \
 -v /dev/dri:/dev/host-dri \
 --privileged \
 ghcr.io/pod-arcade/sway
```

### Without Acceleration
```shell
docker run --rm \
 -it \
 --name "pod-arcade-sway" \
 -e DISABLE_HW_ACCEL="true" \
 -e WAYLAND_DISPLAY="wayland-1" \
 -e DISPLAY=":0" \
 -e XDG_RUNTIME_DIR="/tmp/sway" \
 -e PULSE_SERVER="unix:/tmp/pulse/pulse-socket" \
 -e WLR_NO_HARDWARE_CURSORS="1" \
 -e WLR_XWAYLAND="/etc/sway/Xwayland" \
 -e WLR_RENDERER="pixman" \
 -e WLR_BACKENDS="headless" \
 -e FFMPEG_HARDWARE="0" \
 -p 6900:5900 \
 --privileged \
 ghcr.io/pod-arcade/sway
```

## Required Mount Points

```sh
# Alternatively, configure the mount points with this environment variable.
DEV_DRI_PATH="/dev/dri/"
HOSTDEV_DRI_PATH="/dev/host-dri/"
# Note that this does not change where applications look for hardware devices.
```

### DRI_DEVICE_MODE = NODE

- `/dev/dri` -> `/dev/host-dri/`

When working with `DRI_DEVICE_MODE = NODE`, you need to have the capability `CAP_MKNOD`. This method has the highest compatibility, without changing the permissions for the GPU on the host.

### DRI_DEVICE_MODE = GROUP

- `/dev/dri` -> `/dev/dri/`

When working with `DRI_DEVICE_MODE = GROUP`, no special permissions are required. This method will not work well unless all applications are running inside this container. If you're mounting these devices in a variety of containers, those containers won't receive permissions to access the GPUs.

## Required Environment Variables

```sh
# Configure how hardware acceleration is set up.
# NODE — automatically regenerates device nodes using mknod
# GROUP — Adds user 1000 to the existing group mounted in.
export DRI_DEVICE_MODE=NODE

# Enable or disable hardware acceleration
export DISABLE_HW_ACCEL="false"


# Configure Displays and Audio for guest applications
export WAYLAND_DISPLAY=wayland-1
export DISPLAY=:0
export XDG_RUNTIME_DIR=/tmp/sway
export PULSE_SERVER=unix:/tmp/pulse/pulse-socket

# Configure Wayland Roots Flags
export WLR_NO_HARDWARE_CURSORS=1
export WLR_XWAYLAND=/etc/sway/Xwayland # Configure Xwayland for X11 apps
export WLR_RENDERER=gles2       # Vulkan didn't work for us
export WLR_BACKENDS=headless    # Necessary for docker

# Tell FFMPEG to use Hardware Acceleration
export FFMPEG_HARDWARE=1
```
