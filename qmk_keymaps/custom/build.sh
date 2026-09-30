#!/bin/bash
#
# QMK Voyager Build Script
# Builds the keymap using Docker and outputs to keybin/
#

set -e

cd "$(dirname "$0")/../.."

# Export current user's UID/GID for Docker
USER_UID=$(id -u)
USER_GID=$(id -g)
export USER_UID USER_GID

echo "🔨 Building Voyager keymap: custom"

# Build the Docker image if it doesn't exist
if ! docker images | grep -q "dotfiles-qmk-build"; then
    echo "📦 Building Docker image..."
    docker compose -f docker-compose.qmk.yml build
fi

# Run the build
echo "⚡ Running build..."
docker compose -f docker-compose.qmk.yml run --rm qmk-build

echo "✅ Build complete! Check keybin/ for your firmware file"
echo "💾 Copy the .bin file to Windows and flash with QMK Toolbox or wally-cli"