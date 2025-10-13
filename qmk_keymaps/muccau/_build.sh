#!/bin/bash

set -e

# Create keybin directory if it doesn't exist
mkdir -p ~/keybin

# We're already in the qmk_firmware directory in Docker
# Build the firmware
make zsa/voyager:muccau

# Generate datestamp
datestamp=$(date +%Y%m%d-%H%M%S)

# Copy the built firmware with a datestamped filename
if [ -f "./zsa_voyager_muccau.bin" ]; then
    cp ./zsa_voyager_muccau.bin ~/keybin/muccau.${datestamp}.bin
    echo "Built firmware: muccau.${datestamp}.bin"
    ls -la ~/keybin/
else
    echo "Build failed - no output file found"
    exit 1
fi

