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
  if [ -n "$GPU_CARD_MAJOR_MINOR" ] || [ -n "$GPU_RENDER_MAJOR_MINOR" ]; then
    echo "Creating GPU devices manually due to \$GPU_CARD_MAJOR_MINOR  or \$GPU_RENDER_MAJOR_MINOR"
    if [ -n "$GPU_CARD_MAJOR_MINOR" ]; then
      echo "Recreating device node using mknod $DEV_DRI_PATH c $CARD_MAJOR_MINOR..."
      mknod $DEV_DRI_PATH/card0 c $CARD_MAJOR_MINOR
    fi
    if [ -n "$GPU_RENDER_MAJOR_MINOR" ]; then
      echo "Recreating device node using mknod $DEV_DRI_PATH c $GPU_RENDER_MAJOR_MINOR..."
      mknod $DEV_DRI_PATH/render128 c $GPU_RENDER_MAJOR_MINOR
    fi
  elif [ -d "$HOSTDEV_DRI_PATH" ]; then
    echo "Recreating device nodes from $HOSTDEV_DRI_PATH to $DEV_DRI_PATH..."
    for device in ${HOSTDEV_DRI_PATH}*; do
      device_name=$(basename "$device")
      echo "Recreating device $device_name..."
      recreate_dev_node_if_exists $device_name
    done
  else
    echo "Warning: $HOSTDEV_DRI_PATH does not exist. Skipping MKNOD operations."
  fi
}
