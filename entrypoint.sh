#!/bin/sh
if [ -n "$PA_DEBUG" ]; then
  set -x
fi

. /scripts/setup_default_envs.sh
. /scripts/setup_directories.sh
. /scripts/hardware_setup.sh
. /scripts/setup_dbus.sh
. /scripts/setup_sway_config.sh
. /scripts/setup_novnc.sh
. /scripts/wipe_dev_input.sh

wipe_dev_input

setup_directories

handle_hardware_accel

handle_uinput_setup

setup_dbus

get_sway_config "$@" >/etc/sway/config

SWAY_LOG_PATH="/var/log/pa-sway.log"
EXTRA_COMMANDS_LOG_PATH="/var/log/pa-extra-commands.log"

touch $SWAY_LOG_PATH
touch $EXTRA_COMMANDS_LOG_PATH

tail -f $EXTRA_COMMANDS_LOG_PATH $SWAY_LOG_PATH &

# This is a little hacky, but it lets us run other commands as root.
# We use this for running the desktop
if [ -n "$EXTRA_COMMANDS" ]; then
  eval "{ su ubuntu /wait-for-pulse.sh; $EXTRA_COMMANDS; } &" >>"$EXTRA_COMMANDS_LOG_PATH" 2>&1
fi

if [ "$SWAY_DEBUG" = "true" ]; then
  su -c "dbus-run-session /usr/bin/sway --debug --verbose" ubuntu >>"$SWAY_LOG_PATH" 2>&1
else
  su -c "dbus-run-session /usr/bin/sway" ubuntu >>"$SWAY_LOG_PATH" 2>&1
fi
