#!/bin/sh

recreate_dev_node_if_exists() {
  target_path="${HOSTDEV_DRI_PATH}$1"
  node_path="${DEV_DRI_PATH}$1"

  if [ -e "$target_path" ]; then
    major=$(stat -c '%t' "$target_path")
    minor=$(stat -c '%T' "$target_path")
    major_dec=$(printf "%d" "0x$major")
    minor_dec=$(printf "%d" "0x$minor")
    rm -f "$node_path"
    mknod "$node_path" c $major_dec $minor_dec
    chmod 777 "$node_path"
  fi
}

perform_node_operations() {
  if [ -d "$HOSTDEV_DRI_PATH" ]; then
    echo "Recreating device nodes from $HOSTDEV_DRI_PATH to $DEV_DRI_PATH..."
    for device in ${HOSTDEV_DRI_PATH}*; do
      device_name=$(basename "$device")
      recreate_dev_node_if_exists $device_name
    done
  else
    echo "Warning: $HOSTDEV_DRI_PATH does not exist. Skipping MKNOD operations."
  fi
}
