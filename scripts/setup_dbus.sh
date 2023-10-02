#!/bin/sh

setup_dbus() {
  dbus-daemon --config-file=/usr/share/dbus-1/system.conf
  export DBUS_SESSION_BUS_ADDRESS="unix:path=/var/run/dbus/system_bus_socket"
}
