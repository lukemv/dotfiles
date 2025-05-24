#!/bin/bash

MONITOR_RESOLUTION=1.5
MONITOR_PERCENT=$((MONITOR_RESOLUTION * 100))
LOG_FILE="$HOME/.local/logs/monitor.log"
mkdir -p "$(dirname "$LOG_FILE")"

# Function to log message
log() {
    echo "[$(date)] $1" >> "$LOG_FILE"
}

# Get all connected monitors
MONITORS=$(hyprctl monitors -j | jq -r '.[].name')
LAPTOP_MONITOR="eDP-1"

log "Starting monitor configuration"
log "Connected monitors: $MONITORS"

# Always configure laptop monitor first with 150% scaling
log "Setting $LAPTOP_MONITOR scale to $MONITOR_PERCENT%"
hyprctl keyword monitor "$LAPTOP_MONITOR, preferred, auto, $MONITOR_RESOLUTION"
# hyprctl keyword monitor "DP-4, preferred, auto, 2.0"

# Set brightness
log "Setting brightness to 50%"
brightnessctl -d intel_backlight set 100% > /dev/null 2>&1

for MONITOR in $MONITORS; do
    if [[ "$MONITOR" != "$LAPTOP_MONITOR" ]]; then
        log "Setting $MONITOR scale to $MONITOR_PERCENT%"
        hyprctl keyword monitor "$MONITOR, preferred, auto, $MONITOR_RESOLUTION"
    fi
done

# Assign workspaces
hyprctl dispatch moveworkspacetomonitor 1 "$LAPTOP_MONITOR"

# Find first external monitor if any
EXTERNAL_MONITOR=$(echo "$MONITORS" | grep -v "$LAPTOP_MONITOR" | head -1)

if [[ -n "$EXTERNAL_MONITOR" ]]; then
    log "External monitor detected: $EXTERNAL_MONITOR"
    # Move workspaces 2-4 to external monitor
    for ws in {2..4}; do
        log "Moving workspace $ws to $EXTERNAL_MONITOR"
        hyprctl dispatch moveworkspacetomonitor "$ws" "$EXTERNAL_MONITOR"
    done
else
    log "No external monitor detected"
    # Move all workspaces to laptop monitor
    for ws in {2..4}; do
        log "Moving workspace $ws to $LAPTOP_MONITOR"
        hyprctl dispatch moveworkspacetomonitor "$ws" "$LAPTOP_MONITOR"
    done
fi

log "Monitor configuration complete"
