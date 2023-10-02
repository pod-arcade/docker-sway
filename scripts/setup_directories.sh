#!/bin/sh

setup_directories() {
  mkdir -p /run/udev
  touch /run/udev/control
  chmod 755 /run/udev/control

  mkdir -p $XDG_RUNTIME_DIR
  chown -R ubuntu:ubuntu $XDG_RUNTIME_DIR

  mkdir -p /tmp/pulse
  chmod -R 700 /tmp/pulse
  chown -R ubuntu:ubuntu /tmp/pulse

  mkdir -p /tmp/.X11-unix
  chmod -R 777 /tmp/.X11-unix/
  chmod +t /tmp/.X11-unix
}
