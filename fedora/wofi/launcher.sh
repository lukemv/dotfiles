#!/bin/bash
echo "This is actually running" > /tmp/wofi-debug.txt

# --- Declare menu and commands ---
declare -A MENU_MAP=(
  ["Kitty"]="exec kitty"
  ["Google Chrome (Scaled)"]="GDK_DPI_SCALE=1.0 /usr/bin/google-chrome-stable \
    --enable-features=UseOzonePlatform \
    --ozone-platform=wayland \
    --force-device-scale-factor=1.5 &"
)

# --- Print menu entries ---
print_menu() {
  for key in "${!MENU_MAP[@]}"; do
    echo "$key"
  done
}

# --- Dispatch selected entry ---
dispatch() {
  local choice="$1"
  local cmd="${MENU_MAP[$choice]}"
  if [[ -n "$cmd" ]]; then
    eval "$cmd"
  else
    echo "Unknown option: $choice" >&2
    exit 1
  fi
}

# --- Main execution path ---
if [[ -t 0 ]]; then
  # Terminal mode — use fzf
  choice=$(print_menu | fzf --prompt="Launch > " --height=10 --border --reverse)
else
  # GUI mode — use wofi
  choice=$(print_menu | wofi --dmenu --prompt "Launch:")
fi

# Handle cancel (empty input)
[[ -z "$choice" ]] && exit 0

dispatch "$choice"

