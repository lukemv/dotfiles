#!/bin/bash

sleep 1

# Get list of connected monitors
CONNECTED=$(hyprctl monitors | grep -E '^Monitor' | awk '{print $2}' | sort)

# Safe fallback monitor
FALLBACK_MONITOR="eDP-1"
FALLBACK_RES="3456x2160@60"

# Check lid state (ignore if unknown)
LID_STATE_FILE=$(find /proc/acpi/button/lid/ -name state 2>/dev/null | head -n 1)
LID_STATE="open"
if [ -f "$LID_STATE_FILE" ]; then
  LID_STATE=$(grep -i open "$LID_STATE_FILE" >/dev/null && echo "open" || echo "closed")
fi

# Debug log
echo "[$(date)] Connected: $CONNECTED | Lid: $LID_STATE" >> ~/.local/logs/monitor.log

# Condition: both external monitors detected
if echo "$CONNECTED" | grep -q "DP-7" && echo "$CONNECTED" | grep -q "DP-8"; then
  # External docked setup
  hyprctl keyword monitor "$FALLBACK_MONITOR,disable"
  hyprctl keyword monitor "DP-7,3840x2160@60,0x0,1"
else
  # Fallback only if lid is open
  if [ "$LID_STATE" = "open" ]; then
    hyprctl keyword monitor "$FALLBACK_MONITOR,$FALLBACK_RES,0x0,1"
  else
    echo "🛑 Not switching to laptop screen while lid is closed." >> ~/.config/hypr/monitor.log
  fi
fi

