# QMK Voyager - Quick Start

## TL;DR Daily Workflow

```bash
# 1. Make changes to keymap
vim qmk_keymaps/muccau/keymap.c

# 2. Build firmware
cd qmk_keymaps/muccau && ./build.sh

# 3. Server already running? Skip to step 4
#    First time? Start server:
cd ../.. && ./qmk_keymaps/serve.sh start

# 4. Open browser and download firmware
#    http://localhost:8888/
#    or http://<your-ip>:8888/ from another machine

# 5. Flash with Keymapp
#    - Open ZSA Keymapp
#    - Load the .bin file
#    - Flash to keyboard
```

## One-Line Commands

```bash
# Build firmware
cd qmk_keymaps/muccau && ./build.sh

# Check server status
./qmk_keymaps/serve.sh status

# View latest firmware files
curl -s http://localhost:8888/ | grep -o 'muccau[^"]*\.bin'

# Download latest firmware via CLI
curl -O http://localhost:8888/$(curl -s http://localhost:8888/ | grep -o 'muccau[^"]*\.bin' | tail -1)
```

## Server URLs

- **Local**: http://localhost:8888/
- **Network**: http://10.100.18.10:8888/ *(check with `hostname -I`)*
- **Health**: http://localhost:8888/health

## Troubleshooting One-Liners

```bash
# Restart everything
./qmk_keymaps/serve.sh restart && cd qmk_keymaps/muccau && ./build.sh

# Check what's running
docker ps | grep qmk

# View build logs
cd qmk_keymaps/muccau && ./build.sh 2>&1 | less

# Clean rebuild
rm -rf keybin/*.bin && docker compose -f docker-compose.qmk.yml build --no-cache qmk-build
```

## File Locations

- **Keymap**: `qmk_keymaps/muccau/keymap.c`
- **Config**: `qmk_keymaps/muccau/config.h`
- **Output**: `keybin/*.bin`
- **Server**: http://localhost:8888/

## Common Edits

### Change Layer Colors
Edit `qmk_keymaps/muccau/keymap.c`:
```c
layer_state_t layer_state_set_user(layer_state_t state) {
    if (layer_state_cmp(state, _GAMING)) {
        rgb_matrix_mode(RGB_MATRIX_SOLID_COLOR);
        rgb_matrix_sethsv(HSV_RED);  // Change color here
    }
    // ...
}
```

### Adjust Tapping Term
Edit `qmk_keymaps/muccau/config.h`:
```c
#define TAPPING_TERM 200  // Change to 150 or 250
```

### Enable/Disable Features
Edit `qmk_keymaps/muccau/rules.mk`:
```makefile
RGB_MATRIX_ENABLE = yes
# Add more features here
```

## Remember

- Server runs persistently, start it once
- Firmware files are timestamped automatically
- Always test in a separate layer before modifying BASE
- The `keybin/` folder is gitignored
