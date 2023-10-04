#!/bin/sh

# Configure how hardware acceleration is set up.
# NODE — automatically regenerates device nodes using mknod
# GROUP — Adds user 1000 to the existing group mounted in.
export DRI_DEVICE_MODE="${DRI_DEVICE_MODE:-"NONE"}"

# Enable or disable hardware acceleration
export DISABLE_HW_ACCEL="${DISABLE_HW_ACCEL:-"true"}"
# Tell FFMPEG to use Hardware Acceleration
export FFMPEG_HARDWARE="${FFMPEG_HARDWARE:-"1"}"

export DEV_DRI_PATH="${DEV_DRI_PATH:-"/dev/dri/"}"
export HOSTDEV_DRI_PATH="${HOSTDEV_DRI_PATH:-"/dev/host-dri/"}"

# Configure Displays and Audio for guest applications
export WAYLAND_DISPLAY="${WAYLAND_DISPLAY:-"wayland-1"}"
export DISPLAY="${DISPLAY:-":0"}"
export XDG_RUNTIME_DIR="${XDG_RUNTIME_DIR:-"/tmp/sway"}"
export XAUTHORITY="${XAUTHORITY:-"/tmp/.X11-unix/.Xauthority"}"
export PULSE_SERVER="${PULSE_SERVER:-"unix:/tmp/pulse/pulse-socket"}"

# Configure Wayland Roots Flags
export WLR_NO_HARDWARE_CURSORS="${WLR_NO_HARDWARE_CURSORS:-"1"}"
# Configure Xwayland for X11 apps
export WLR_XWAYLAND="${WLR_XWAYLAND:-"/etc/sway/Xwayland"}"
# Vulkan didn't work for us
export WLR_RENDERER="${WLR_RENDERER:-"gles2"}"
# Necessary for docker
export WLR_BACKENDS="${WLR_BACKENDS:-"headless"}"

# Default the resolution
export RESOLUTION="${RESOLUTION:-"1280x720"}"
