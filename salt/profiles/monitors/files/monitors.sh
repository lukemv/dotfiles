#!/bin/bash

LOG_FILE="$HOME/.local/logs/monitor.log"

# Get all connected monitors that aren't the laptop (eDP-1)
EXTERNAL_NAME=$(hyprctl monitors | awk '
  /^Monitor/ { name=$2 }
  /model:/ {
    if (name != "eDP-1") {
      print name
      exit
    }
  }'
)

EXTERNAL_CONNECTED="no"
if [ -n "$EXTERNAL_NAME" ]; then
  EXTERNAL_CONNECTED="yes"
fi

# Log the result
echo "[$(date)] External connected: $EXTERNAL_CONNECTED ($EXTERNAL_NAME)" >> "$LOG_FILE"

# Always scale eDP-1 and set brightness
echo "[$(date)] Setting eDP-1 scale to 200%" >> "$LOG_FILE"
hyprctl keyword monitor "eDP-1, preferred, auto, 2.0"
echo "[$(date)] Setting brightness to 100%" >> "$LOG_FILE"
brightnessctl -d intel_backlight set 100% > /dev/null 2>&1

# Assign workspaces
hyprctl dispatch moveworkspacetomonitor 1 eDP-1

if [[ "$EXTERNAL_CONNECTED" == "yes" ]]; then
  echo "[$(date)] Setting $EXTERNAL_NAME scale to 150%" >> "$LOG_FILE"
  hyprctl keyword monitor "$EXTERNAL_NAME, preferred, auto, 1.5"
  for ws in {2..4}; do
    echo "[$(date)] Dispatch $ws -> $EXTERNAL_NAME" >> "$LOG_FILE"
    hyprctl dispatch moveworkspacetomonitor "$ws" "$EXTERNAL_NAME"
  done
else
  for ws in {2..4}; do
    echo "[$(date)] Dispatch $ws -> eDP-1" >> "$LOG_FILE"
    hyprctl dispatch moveworkspacetomonitor "$ws" eDP-1
  done
fi

