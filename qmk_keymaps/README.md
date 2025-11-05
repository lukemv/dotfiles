# QMK Voyager Keymaps

This directory contains QMK keymaps for the ZSA Voyager keyboard, built using Docker for consistent cross-platform compilation and served via HTTP for easy flashing.

## Daily Workflow

### 1. Build Firmware
```bash
cd qmk_keymaps/muccau/
./build.sh
```

The firmware will be saved to `keybin/` with a timestamp (e.g., `muccau.20251030-153714.bin`).

### 2. Start Firmware Server (First Time)
```bash
cd ../..  # Back to repo root
./qmk_keymaps/serve.sh start
```

The server will:
- Run on port 8888
- Serve all firmware files from `keybin/`
- Provide a browsable directory listing
- Auto-download `.bin` files when clicked

### 3. Access Firmware
From any machine on your network:
- **Web Browser**: `http://<your-ip>:8888/`
- **Local**: `http://localhost:8888/`

Click any `.bin` file to download it, then flash with Keymapp.

### 4. Flash to Keyboard
1. Download the `.bin` file from the server
2. Open ZSA Keymapp software
3. Flash the binary to your Voyager
4. Put keyboard in bootloader mode if needed

## Commands Reference

### Build Commands
```bash
# Build firmware (from muccau/ directory)
./build.sh

# Rebuild Docker image (if dependencies change)
docker compose -f ../../docker-compose.qmk.yml build qmk-build
```

### Server Commands
```bash
# Start the firmware server (from repo root)
./qmk_keymaps/serve.sh start

# Check server status and list files
./qmk_keymaps/serve.sh status

# Stop the server
./qmk_keymaps/serve.sh stop

# View server logs
./qmk_keymaps/serve.sh logs
```

## Architecture

### Build System
The build system uses Docker to ensure consistent compilation across platforms:

1. **Docker Image**: Ubuntu 22.04 with QMK CLI, ARM GCC toolchain, and ZSA firmware
2. **Build Script**: Copies keymap files to an unmounted location (required for QMK module detection)
3. **Compilation**: Uses ZSA's QMK firmware fork with proper module support
4. **Output**: Timestamped `.bin` files in `keybin/` directory

**Important**: The Docker volume mount interferes with QMK's module detection system. The build script works around this by copying keymap files to a temporary location during compilation.

### Firmware Server
The server is a lightweight nginx container that:
- Listens on `0.0.0.0:8888` (accessible from network)
- Serves files from `keybin/` directory
- Provides directory listing with file sizes and timestamps
- Forces download for `.bin` files
- Includes health check endpoint at `/health`
- Restarts automatically unless stopped

## Files

### Build System
- `Dockerfile.qmk` - Ubuntu-based build environment
- `docker-compose.qmk.yml` - Docker composition for build and server
- `muccau/keymap.c` - Your keymap layout
- `muccau/config.h` - Keyboard configuration
- `muccau/rules.mk` - Build rules (currently just `RGB_MATRIX_ENABLE = yes`)
- `muccau/_build.sh` - Internal build script (runs inside container)
- `muccau/build.sh` - User-facing build script

### Server
- `nginx.conf` - Nginx configuration for firmware server
- `serve.sh` - Server management script

### Output
- `keybin/` - Compiled firmware binaries (gitignored)

## Keymap Features

Your current keymap includes:
- **4 Layers**: BASE, FN, MEDIA, GAMING
- **Home Row Mods**: GUI and CTRL on home row (BASE layer)
- **RGB Matrix**: Layer-specific lighting (blue for GAMING, rainbow pinwheels otherwise)
- **Tapping Term**: 200ms with permissive hold
- **USB Polling**: 1ms for low latency
- **ZSA Modules**: Defaults and Oryx modules enabled

## Troubleshooting

### Build Fails
```bash
# Rebuild the Docker image
docker compose -f ../../docker-compose.qmk.yml build --no-cache qmk-build

# Check build output
cd muccau && ./build.sh 2>&1 | less
```

### Server Not Accessible
```bash
# Check server status
./qmk_keymaps/serve.sh status

# Restart server
./qmk_keymaps/serve.sh restart

# Check logs
./qmk_keymaps/serve.sh logs

# Verify port is not blocked
sudo ss -tulpn | grep 8888
```

### No Firmware Files
```bash
# Check keybin directory
ls -lah keybin/

# Build firmware first
cd qmk_keymaps/muccau && ./build.sh
```

## Advanced Usage

### Custom Port
Edit `docker-compose.qmk.yml` and change the port mapping:
```yaml
ports:
  - "9999:8888"  # Change 9999 to your preferred port
```

### Multiple Keymaps
Copy the `muccau/` directory and modify the keymap files. Update the build script to use the new directory name.

### Clean Build
```bash
# Remove all compiled binaries
rm -rf keybin/*.bin

# Rebuild from scratch
docker compose -f docker-compose.qmk.yml build --no-cache qmk-build
```

## Notes

- The firmware server runs persistently with `restart: unless-stopped`
- Build artifacts are stored in `keybin/` which is gitignored
- The ZSA Voyager uses a custom bootloader, not standard QMK flashing
- Always use Keymapp or wally-cli to flash ZSA keyboards
