#!/bin/sh

. /scripts/hardware_group_operations.sh
. /scripts/hardware_node_operations.sh

handle_hardware_accel() {
  if [ "$DISABLE_HW_ACCEL" != "true" ]; then
    case "$DRI_DEVICE_MODE" in
    "ADD_GROUP")
      perform_group_operations
      ;;
    "MKNOD")
      perform_node_operations
      ;;
    "NONE")
      echo "Warning: DRI_DEVICE_MODE=NONE and DISABLE_HW_ACCEL!=true . Hardware acceleration may not function correctly."
      ;;
    *)
      echo "Invalid DRI_DEVICE_MODE. Use either 'ADD_GROUP', 'MKNOD', or 'NONE'."
      ;;
    esac
  else
    echo "Hardware acceleration is disabled."
    if [ -d /dev/dri ]; then
      echo "Warning: /dev/dri exists, but you're running with hardware acceleration disabled. This may be because you are running in privileged mode, and the device was automatically mounted."
      echo "Warning: removing existing /dev/dri directory."
      rm -rf /dev/dri
    fi
  fi
}

handle_uinput_setup() {
  case "$UINPUT_DEVICE_MODE" in
  "ADD_GROUP")
    add_uinput_to_group_if_exists
    ;;
  "MKNOD")
    recreate_uinput_dev_node_if_exists
    ;;
  "NONE")
    echo "Warning: UINPUT_DEVICE_MODE=NONE. Gamepads may not function correctly."
    if [ -f /dev/uinput ]; then
      echo "Warning: /dev/uinput exists, but you're running with uinput disabled. This may be because you are running in privileged mode, and the device was automatically mounted."
      echo "Warning: removing existing /dev/uinput directory."
      rm -rf /dev/uinput
    fi
    ;;
  *)
    echo "Invalid UINPUT_DEVICE_MODE. Use either 'ADD_GROUP', 'MKNOD', or 'NONE'."
    ;;
  esac
}
