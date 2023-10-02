#!/bin/sh
set -x

. /scripts/setup_default_envs.sh
. /scripts/setup_directories.sh
. /scripts/hardware_accel.sh
. /scripts/setup_dbus.sh
. /scripts/setup_sway_config.sh

setup_directories

handle_hardware_accel

setup_dbus

get_sway_config "$@" > /etc/sway/config

su -c "dbus-run-session /usr/bin/sway" ubuntu
