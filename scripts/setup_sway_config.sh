#!/bin/sh

get_sway_config() {
  echo """
  default_border pixel 0
  output HEADLESS-1 pos 0 0 res $RESOLUTION
  output HEADLESS-1 bg /etc/sway/background.png fill
  exec pulseaudio -v --log-level=1
  exec /wait-for-pulse.sh && wayvnc 0.0.0.0 5900
  """
  if [ -n "$EXTRA_SWAY_COMMANDS" ]
  then
  echo "exec /wait-for-pulse.sh && $EXTRA_SWAY_COMMANDS"
  fi
  if [ -n "$*" ]
  then
  echo "exec /wait-for-pulse.sh && $*"
  fi
}
