#!/bin/bash

# Where to put the .so core files
CORE_DIR="$HOME/.config/retroarch/cores"
mkdir -p "$CORE_DIR"

# Libretro nightly build URL
BASE_URL="https://buildbot.libretro.com/nightly/linux/x86_64/latest/"

# Best cores list
CORES=(
  vice_x64_libretro.so.zip
  snes9x_libretro.so.zip
  mesen_libretro.so.zip
  sameboy_libretro.so.zip
  mgba_libretro.so.zip
  melonDS_libretro.so.zip
  mupen64plus_next_libretro.so.zip
  beetle_psx_hw_libretro.so.zip
  ppsspp_libretro.so.zip
  flycast_libretro.so.zip
  genesis_plus_gx_libretro.so.zip
  fbneo_libretro.so.zip
  mame2003_plus_libretro.so.zip
  stella_libretro.so.zip
)

echo "🔍 Downloading selected high-quality cores..."

for core in "${CORES[@]}"; do
  echo "⬇️ $core"
  curl -s -O "${BASE_URL}${core}"
  unzip -o "$core" -d "$CORE_DIR"
  rm "$core"
done

echo "✅ All done. Cores installed to: $CORE_DIR"

