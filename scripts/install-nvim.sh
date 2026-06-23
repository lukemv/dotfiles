#!/usr/bin/env bash
# Single entry point for ALL Neovim dependencies. Run this after `./install`
# (which symlinks the nvim config into place). Idempotent and safe to re-run.
#
# Captures, in one place, everything Neovim needs to come up fully working:
#   1. luarocks    - Lua 5.1 + luarocks via hererocks (for lazy.nvim rocks)
#   2. Go tools    - the CLI tools go.nvim shells out to
#   3. plugins     - lazy.nvim plugins at their locked commits + build steps
#                    (e.g. LuaSnip's jsregexp is compiled by its build step)
#   4. LSP servers - installed via mason
#   5. parsers     - treesitter parsers
#
# Versions are intentionally NOT pinned for mason servers / treesitter parsers
# (latest is fine); plugins ARE pinned via lazy-lock.json (restored below).
#
# The server / parser lists below mirror `ensure_installed` in
# nvim/lua/plugins/lsp.lua and nvim/lua/plugins/treesitter.lua — the nvim config
# is the source of truth for interactive use; these mirror it for provisioning.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

command -v nvim >/dev/null 2>&1 || {
  echo "ERROR: nvim not found on PATH. Install Neovim first." >&2
  exit 1
}

# LSP servers as mason PACKAGE names (not lspconfig server names).
MASON_PACKAGES=(lua-language-server python-lsp-server gopls terraform-ls)

# Treesitter parsers (mirrors ensure_installed in plugins/treesitter.lua).
TS_PARSERS=(c cpp go lua python rust vimdoc vim hcl gomod gosum gowork gotmpl sql json comment)

echo "==> [1/5] luarocks toolchain (hererocks) for lazy.nvim"
"$SCRIPT_DIR/install-luarocks.sh" || echo "WARN: luarocks step failed (optional); continuing."

echo "==> [2/5] Go CLI tools"
"$SCRIPT_DIR/install-gotools.sh" || echo "WARN: go-tools step failed (need Go on PATH?); continuing."

echo "==> [3/5] Neovim plugins (lazy.nvim @ locked commits) + build steps"
nvim --headless "+Lazy! restore" +qa

echo "==> [4/5] LSP servers via mason: ${MASON_PACKAGES[*]}"
nvim --headless "+MasonInstall ${MASON_PACKAGES[*]}" +qa

echo "==> [5/5] Treesitter parsers"
nvim --headless "+TSInstallSync ${TS_PARSERS[*]}" +qa

echo "==> Done. All Neovim dependencies installed."
