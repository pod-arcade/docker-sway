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
  fi
}
