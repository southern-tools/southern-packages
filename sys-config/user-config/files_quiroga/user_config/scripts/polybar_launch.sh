#!/usr/bin/env sh
# Southern Tools
#
#set -x

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Launch bar1 and bar2
polybar top -c ~/.user_config/applications/polybar/config &
# polybar bottom -c ~/.user_config/applications/polybar/config &

echo "Bars launched..."
