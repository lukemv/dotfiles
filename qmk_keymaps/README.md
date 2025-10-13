# QMK Voyager Keymaps

This directory contains QMK keymaps for the ZSA Voyager keyboard, built using Docker for consistent cross-platform compilation.

## Quick Start

Build your keymap:
```bash
cd muccau/
./build.sh
```

The firmware will be saved to `../../keybin/` with a timestamp.

## Files

- `Dockerfile.qmk` - Ubuntu-based build environment with QMK CLI and ARM toolchain
- `docker-compose.qmk.yml` - Docker composition for building keymaps
- `qmk_keymaps/muccau/` - Keymap files (keymap.c, config.h, rules.mk)
- `qmk_keymaps/muccau/build.sh` - Simple build script
- `keybin/` - Output directory for compiled firmware

## Manual Build

```bash
# From repository root
docker compose -f docker-compose.qmk.yml build
docker compose -f docker-compose.qmk.yml run --rm qmk-build
```

## Flashing on Windows

1. Copy the `.bin` file from `keybin/` to your Windows machine
2. Use QMK Toolbox or wally-cli to flash to your Voyager
3. Put keyboard in bootloader mode (hold bottom-left key while connecting)

## Development

The Docker container includes:
- Ubuntu 22.04 base
- QMK CLI
- ARM GCC toolchain for ZSA keyboards
- ZSA QMK firmware repository

Keymap files are mounted read-only from your local filesystem, output goes to `keybin/` directory.