#!/bin/sh
set -x

# Create /run/udev/control
# And grant read access to everyone.
mkdir -p /run/udev
touch /run/udev/control
chmod 755 /run/udev/control

# Default paths for device nodes and hostdev
DEV_DRI_PATH="${DEV_DRI_PATH:-/dev/dri/}"
HOSTDEV_DRI_PATH="${HOSTDEV_DRI_PATH:-/dev/host-dri/}"
DRI_DEVICE_MODE="${DRI_DEVICE_MODE:-GROUP}"
DISABLE_HW_ACCEL="${DISABLE_HW_ACCEL:-false}"

# Function to create a group with the same GID as the device
# and add 'ubuntu' to that group if the device exists.
add_to_group_if_exists() {
  if [ -e "$1" ]; then
    gid=$(stat -c '%g' "$1")
    # Create a new group with the found GID
    groupadd --gid $gid temp_group_$gid
    # Add 'ubuntu' to the new group
    usermod -a -G temp_group_$gid ubuntu
  fi
}

# Function to recreate the device node if the target exists in HOSTDEV_DRI_PATH
recreate_dev_node_if_exists() {
  target_path="${HOSTDEV_DRI_PATH}$1"
  node_path="${DEV_DRI_PATH}$1"

  if [ -e "$target_path" ]; then
    major=$(stat -c '%t' "$target_path")
    minor=$(stat -c '%T' "$target_path")

    # Convert hexadecimal to decimal
    major_dec=$(printf "%d" "0x$major")
    minor_dec=$(printf "%d" "0x$minor")

    # Skip if both major and minor are zero
    if [ "$major_dec" -eq "0" ] && [ "$minor_dec" -eq "0" ]; then
      return
    fi

    rm -f "$node_path"
    mknod "$node_path" c $major_dec $minor_dec
    chmod 777 "$node_path"
  fi
}

if [ "$DISABLE_HW_ACCEL" != "true" ]; then
  if [ "$DRI_DEVICE_MODE" = "GROUP" ]; then
    if [ -d "$DEV_DRI_PATH" ]; then
      echo "Creating groups based on $DEV_DRI_PATH..."
      for device in ${DEV_DRI_PATH}card* ${DEV_DRI_PATH}renderD*; do
        add_to_group_if_exists $device
      done
    else
      echo "Warning: $DEV_DRI_PATH does not exist. Skipping GROUP operations."
    fi
  elif [ "$DRI_DEVICE_MODE" = "NODE" ]; then
    if [ -d "$HOSTDEV_DRI_PATH" ]; then
      echo "Recreating device nodes from $HOSTDEV_DRI_PATH to $DEV_DRI_PATH..."
      for device in ${HOSTDEV_DRI_PATH}*; do
        device_name=$(basename "$device")
        recreate_dev_node_if_exists $device_name
      done
    else
      echo "Warning: $HOSTDEV_DRI_PATH does not exist. Skipping NODE operations."
    fi
  else
    echo "Invalid DRI_DEVICE_MODE. Use either 'GROUP' or 'NODE'."
    echo "GROUP works great when you're running in a single container."
    echo "NODE works when you're sharing the device's folder with other containers and want them to be able to access it too."
  fi
else
  echo "Hardware acceleration is disabled."
fi

mkdir -p $XDG_RUNTIME_DIR
chown -R ubuntu:ubuntu $XDG_RUNTIME_DIR

mkdir -p /tmp/pulse
chmod -R 700 /tmp/pulse
chown -R ubuntu:ubuntu /tmp/pulse

mkdir -p /tmp/.X11-unix
chmod -R 777 /tmp/.X11-unix/
chmod +t /tmp/.X11-unix

dbus-daemon --config-file=/usr/share/dbus-1/system.conf
export DBUS_SESSION_BUS_ADDRESS="unix:path=/var/run/dbus/system_bus_socket"
su -c "dbus-run-session /usr/bin/sway" ubuntu
