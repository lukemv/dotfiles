#!/bin/bash

CONNECTED=$(hyprctl monitors | grep -E '^Monitor' | awk '{print $2}' | sort)

LID_STATE_FILE=$(find /proc/acpi/button/lid/ -name state 2>/dev/null | head -n 1)
LID_STATE="open"
if [ -f "$LID_STATE_FILE" ]; then
  LID_STATE=$(grep -i open "$LID_STATE_FILE" >/dev/null && echo "open" || echo "closed")
fi

# Debug log
echo "[$(date)] Connected: $CONNECTED | Lid: $LID_STATE" >> ~/.local/logs/monitor.log
hyprctl keyword monitor "eDP-1, preferred, auto, 2.0"

