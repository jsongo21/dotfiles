#!/bin/bash

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Launch Polybar, using default config location ~/.config/polybar/config
MONITOR=$(polybar -m | tail -1 | sed -e 's/:.*$//g') DEFAULT_NETWORK_DEVICE=$(ip route | grep '^default' | awk '{print $5}' | head -n1) polybar bar

echo "Polybar launched..."
