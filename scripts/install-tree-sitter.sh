#!/usr/bin/env bash
# Install the tree-sitter CLI, which nvim-treesitter needs to build parsers.
#
# nvim-treesitter's `main` branch shells out to `tree-sitter build` for every
# parser, so without this binary no parser installs and Neovim falls back to
# regex highlighting. A prebuilt release binary is used rather than
# `cargo install`, which needs a recent rustc plus libclang, and rather than
# the distro package, which lags behind the required minimum.
set -euo pipefail

MIN_VERSION="0.26.1"
BIN_DIR="$HOME/.local/bin"
TARGET="$BIN_DIR/tree-sitter"

# Sort -V puts the lower version first; equal versions count as satisfied.
version_ok() {
  [ "$(printf '%s\n%s\n' "$MIN_VERSION" "$1" | sort -V | head -1)" = "$MIN_VERSION" ]
}

# Idempotent: skip if a new enough CLI is already on PATH.
if command -v tree-sitter >/dev/null 2>&1; then
  current="$(tree-sitter --version 2>/dev/null | awk '{print $2}')"
  if [ -n "$current" ] && version_ok "$current"; then
    echo "tree-sitter $current already installed ($(command -v tree-sitter))"
    exit 0
  fi
  echo "tree-sitter $current is older than $MIN_VERSION; upgrading..."
fi

case "$(uname -m)" in
  x86_64)          arch="x64" ;;
  aarch64 | arm64) arch="arm64" ;;
  *) echo "ERROR: unsupported architecture $(uname -m)" >&2; exit 1 ;;
esac

for bin in curl gunzip; do
  command -v "$bin" >/dev/null 2>&1 || { echo "ERROR: $bin is required" >&2; exit 1; }
done

tag="$(curl -fsSL https://api.github.com/repos/tree-sitter/tree-sitter/releases/latest \
  | grep -m1 '"tag_name"' | cut -d'"' -f4)"
if [ -z "$tag" ]; then
  echo "ERROR: could not determine the latest tree-sitter release" >&2
  exit 1
fi

tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

echo "Fetching tree-sitter $tag ($arch)..."
curl -fsSL -o "$tmp/tree-sitter.gz" \
  "https://github.com/tree-sitter/tree-sitter/releases/download/${tag}/tree-sitter-linux-${arch}.gz"

gunzip -f "$tmp/tree-sitter.gz"
chmod +x "$tmp/tree-sitter"

mkdir -p "$BIN_DIR"
mv "$tmp/tree-sitter" "$TARGET"

echo "Done: $("$TARGET" --version) -> $TARGET"
