#!/usr/bin/env bash
# macOS: install Nix if it is missing, then apply this machine's home-manager
# configuration from flake.nix. Safe to re-run: with Nix present it only
# switches, which is also how a `nix flake update` gets applied.
#
# Walkthrough: docs/nix-macos.md. Other platforms get their own
# scripts/<os>/install-nix.sh; `make install-nix` picks by uname.
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
NIX_PROFILE_SCRIPT=/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh

die() { echo "error: $*" >&2; exit 1; }

[ "$(uname -s)" = Darwin ] || die "this is the macOS installer; see scripts/<os>/"
TARGET=darwin

# Nix only sees files git tracks when the flake lives in a git repo, so an
# unstaged flake.nix fails later with a confusing "path does not exist".
for f in flake.nix nix/home.nix; do
  git -C "$REPO_DIR" ls-files --error-unmatch "$f" >/dev/null 2>&1 \
    || die "$f is not tracked by git; run: git -C $REPO_DIR add $f"
done

# 1. Nix itself. The Determinate Systems installer is used because it sets up
# the multi-user daemon, enables flakes, survives macOS upgrades (which reset
# /etc/zshrc), and ships an uninstaller at /nix/nix-installer. It asks for
# sudo and shows its plan before changing anything.
if ! command -v nix >/dev/null 2>&1; then
  if [ ! -e "$NIX_PROFILE_SCRIPT" ]; then
    echo "==> Installing Nix (you will be asked to confirm and for sudo)"
    curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix \
      | sh -s -- install
  fi
  # The installer edits the shell rc files for future shells; this one has to
  # pick Nix up by hand.
  # shellcheck disable=SC1090
  . "$NIX_PROFILE_SCRIPT"
fi
command -v nix >/dev/null 2>&1 || die "nix still not on PATH after install"
echo "==> $(nix --version)"

# 2. This machine's entry in flake.nix.
if ! nix eval --raw "$REPO_DIR#homeConfigurations" \
    --apply "c: if c ? $TARGET then \"ok\" else \"\"" 2>/dev/null | grep -q ok; then
  die "flake.nix has no homeConfigurations.$TARGET (see docs/nix-macos.md)"
fi

# 3. Apply it. --inputs-from runs the home-manager pinned in flake.lock rather
# than whatever is newest, so the tool that applies the config is as pinned as
# the config. -b moves aside any file it would otherwise refuse to replace.
# --impure lets flake.nix read $USER and $HOME instead of hardcoding them.
echo "==> Switching to $TARGET"
nix run --inputs-from "$REPO_DIR" home-manager -- \
  switch -b hm-backup --impure --flake "$REPO_DIR#$TARGET"

# 4. Older installs that would shadow the Nix ones. zshrc.d/export.zsh puts
# ~/.local/bin ahead of the Nix profile and ~/.atuin/bin/env prepends itself,
# so leftovers there win silently. Report them rather than delete: removing a
# binary under a running herdr session is the user's call.
stale=()
for f in "$HOME/.local/bin/herdr" "$HOME/.atuin/bin/atuin" \
         /usr/local/bin/herdr /usr/local/bin/atuin; do
  [ -e "$f" ] && stale+=("$f")
done
if [ ${#stale[@]} -gt 0 ]; then
  echo
  echo "These older installs come before Nix on PATH and will keep running"
  echo "instead of the pinned versions. Remove them:"
  for f in "${stale[@]}"; do
    case "$f" in
      "$HOME/.atuin/"*) echo "  rm -rf $HOME/.atuin   # binary only; history is in ~/.local/share/atuin" ;;
      *)                echo "  rm $f" ;;
    esac
  done
fi

echo
echo "Done. Open a new shell, then check: which herdr atuin"
if ! git -C "$REPO_DIR" diff --quiet -- flake.lock 2>/dev/null \
   || ! git -C "$REPO_DIR" ls-files --error-unmatch flake.lock >/dev/null 2>&1; then
  echo "flake.lock changed: commit it so every machine gets these versions."
fi
