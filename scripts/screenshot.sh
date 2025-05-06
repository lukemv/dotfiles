#!/usr/bin/env bash
set -euo pipefail

DIR="${HOME}/Pictures/Screenshots"
mkdir -p "$DIR"

FILENAME="screenshot_$(date +%Y%m%d_%H%M%S).png"
FULLPATH="${DIR}/${FILENAME}"

grim -g "$(slurp)" "$FULLPATH"
swappy -f "$FULLPATH"

