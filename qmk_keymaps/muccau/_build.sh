#!/bin/bash

# Create ~/keybin if it doesn't exist
if [ ! -d ~/keybin ]; then
  mkdir ~/keybin
fi

# Navigate to ~/zsa-qmk
pushd ~/zsa-qmk > /dev/null || exit 1

# Build the firmware
make zsa/voyager:muccau

# Generate datestamp
datestamp=$(date +%Y%m%d-%H%M%S)

# Copy the built firmware with a datestamped filename
cp ./zsa_voyager_muccau.bin ~/keybin/muccau.${datestamp}.bin

# Return to previous directory
popd > /dev/null

