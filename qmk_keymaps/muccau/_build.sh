#!/bin/bash

set -e

# Copy keymap files to a writable unmounted location
# This is necessary because the Docker mount interferes with QMK module detection
echo "Copying keymap files to build location..."
cp -r keyboards/zsa/voyager/keymaps/default keyboards/zsa/voyager/keymaps/mybuild
cp keyboards/zsa/voyager/keymaps/muccau/keymap.c keyboards/zsa/voyager/keymaps/mybuild/
cp keyboards/zsa/voyager/keymaps/muccau/config.h keyboards/zsa/voyager/keymaps/mybuild/
cp keyboards/zsa/voyager/keymaps/muccau/rules.mk keyboards/zsa/voyager/keymaps/mybuild/

# Build the firmware
echo "Building firmware..."
make zsa/voyager:mybuild

# Generate datestamp
datestamp=$(date +%Y%m%d-%H%M%S)

# Create keybin directory and copy the built firmware with a datestamped filename
mkdir -p ~/keybin
if [ -f "./zsa_voyager_mybuild.bin" ]; then
    cp ./zsa_voyager_mybuild.bin ~/keybin/muccau.${datestamp}.bin
    echo "✅ Build successful: muccau.${datestamp}.bin"
    ls -lah ~/keybin/
else
    echo "❌ Build failed - no output file found"
    exit 1
fi

