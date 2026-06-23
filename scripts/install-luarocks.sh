#!/usr/bin/env bash
# Bootstrap a private Lua 5.1 + luarocks toolchain for lazy.nvim via hererocks.
#
# lazy.nvim needs luarocks built against Lua 5.1 (to match Neovim's LuaJIT ABI).
# Distro luarocks is built for 5.4 and won't work, so we compile a self-contained
# toolchain. It is installed into a persistent directory OUTSIDE the Neovim data
# dir so it survives `:Lazy restore` and fresh nvim installs. lua/core/lazy.lua
# points lazy's rocks.root at this same directory.
set -euo pipefail

ROCKS_ROOT="${XDG_DATA_HOME:-$HOME/.local/share}/lazy-rocks"
HEREROCKS_DIR="$ROCKS_ROOT/hererocks"

# Idempotent: skip if a working 5.1 toolchain is already present.
if [ -x "$HEREROCKS_DIR/bin/luarocks" ] && "$HEREROCKS_DIR/bin/lua" -v 2>&1 | grep -q "Lua 5.1"; then
  echo "luarocks (hererocks) already installed at $HEREROCKS_DIR"
  "$HEREROCKS_DIR/bin/luarocks" --version | head -1
  exit 0
fi

# Build prerequisites (Lua + luarocks are compiled from source).
missing=()
for bin in python3 cc make; do
  command -v "$bin" >/dev/null 2>&1 || missing+=("$bin")
done
if [ "${#missing[@]}" -gt 0 ]; then
  echo "ERROR: missing build prerequisites: ${missing[*]}" >&2
  echo "Install them (e.g. python3, gcc/make, readline-devel) and re-run." >&2
  exit 1
fi

mkdir -p "$ROCKS_ROOT"
cd "$ROCKS_ROOT"

echo "Fetching hererocks.py..."
curl -fsSL https://raw.githubusercontent.com/luarocks/hererocks/latest/hererocks.py -o hererocks.py \
  || curl -fsSL https://raw.githubusercontent.com/luarocks/hererocks/master/hererocks.py -o hererocks.py

echo "Building Lua 5.1 + luarocks into $HEREROCKS_DIR (compiles from source, takes a minute)..."
python3 hererocks.py -l 5.1 -r latest "$HEREROCKS_DIR"

echo "Done: $("$HEREROCKS_DIR/bin/luarocks" --version | head -1)"
