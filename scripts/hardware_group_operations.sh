#!/bin/sh

add_uinput_to_group_if_exists() {
  device="$DEV_UINPUT_PATH"
  if [ -e "$device" ]; then
    gid=$(stat -c '%g' "$device")
    groupadd --gid $gid temp_group_$gid
    usermod -a -G temp_group_$gid ubuntu
  else
    echo "Warning: $device does not exist. Skipping uinput ADD_GROUP operations."
  fi
}

add_to_group_if_exists() {
  if [ -e "$1" ]; then
    gid=$(stat -c '%g' "$1")
    groupadd --gid $gid temp_group_$gid
    usermod -a -G temp_group_$gid ubuntu
  fi
}

perform_group_operations() {
  if [ -d "$DEV_DRI_PATH" ]; then
    echo "Creating groups based on $DEV_DRI_PATH..."
    for device in ${DEV_DRI_PATH}card* ${DEV_DRI_PATH}renderD*; do
      add_to_group_if_exists $device
    done
  else
    echo "Warning: $DEV_DRI_PATH does not exist. Skipping ADD_GROUP operations."
  fi
}
