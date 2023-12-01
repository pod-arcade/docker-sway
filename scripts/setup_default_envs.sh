#!/bin/sh

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
# Necessary for docker to run in headless mode
export WLR_BACKENDS="${WLR_BACKENDS:-"headless"}"
# Default the resolution
export RESOLUTION="${RESOLUTION:-"1280x720"}"

# Configure how hardware acceleration is set up.
# MKNOD — automatically regenerates device nodes using mknod
# GROUP — Adds user 1000 to the existing group mounted in.

# Configure hardware device paths
export DEV_DRI_PATH="${DEV_DRI_PATH:-"/dev/dri/"}"
export HOSTDEV_DRI_PATH="${HOSTDEV_DRI_PATH:-"/dev/host-dri/"}"

if [ -d /dev/host-dri ]; then
  # We have hardware acceleration, we just need to make the nodes
  export DRI_DEVICE_MODE="${DRI_DEVICE_MODE:-"MKNOD"}"
  export DISABLE_HW_ACCEL="${DISABLE_HW_ACCEL:-"false"}"
  export FFMPEG_HARDWARE="${FFMPEG_HARDWARE:-"1"}"
elif [ -d /dev/dri ]; then
  # We have hardware acceleration, we just need to add permissions
  export DRI_DEVICE_MODE="${DRI_DEVICE_MODE:-"GROUP"}"
  export DISABLE_HW_ACCEL="${DISABLE_HW_ACCEL:-"false"}"
  export FFMPEG_HARDWARE="${FFMPEG_HARDWARE:-"1"}"
else
  # We do not have hardware acceleration. We should default disable it.
  export DRI_DEVICE_MODE="${DRI_DEVICE_MODE:-"NONE"}"
  export DISABLE_HW_ACCEL="${DISABLE_HW_ACCEL:-"true"}"
  export FFMPEG_HARDWARE="${FFMPEG_HARDWARE:-"0"}"
fi

if [ $DISABLE_HW_ACCEL = "true" ]; then
  export WLR_RENDERER="${WLR_RENDERER:-"pixman"}"
else
  # Vulkan didn't work for us, so we default to GLES2
  export WLR_RENDERER="${WLR_RENDERER:-"gles2"}"
fi

# Configure how gamepads are set up.
# MKNOD — automatically regenerates device nodes using mknod
# GROUP — Adds user 1000 to the existing group mounted in.

# Configure uinput paths
export DEV_UINPUT_PATH="${DEV_UINPUT_PATH:-"/dev/uinput"}"
export HOSTDEV_UINPUT_PATH="${HOSTDEV_UINPUT_PATH:-"/dev/host-uinput"}"

if [ -e /dev/host-uinput ]; then
  # We can create gamepads, we just need to make the nodes
  export UINPUT_DEVICE_MODE="${UINPUT_DEVICE_MODE:-"MKNOD"}"
elif [ -e /dev/uinput ]; then
  # We can create gamepads, we just need to add permissions
  export UINPUT_DEVICE_MODE="${UINPUT_DEVICE_MODE:-"GROUP"}"
else
  # We do not have gamepad support. We should default disable it.
  export UINPUT_DEVICE_MODE="${UINPUT_DEVICE_MODE:-"NONE"}"
fi
