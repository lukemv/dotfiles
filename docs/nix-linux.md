# Nix on Linux

The same setup as [macOS](nix-macos.md): Nix pins **herdr** and **atuin** via
`flake.lock`, and Dotbot still links the configs. This page covers only what
differs on Linux. Read the macOS page for the full explanation.

Nix sits alongside the rest of the setup. Salt still owns system packages and
services on Fedora/RHEL, and nothing here replaces it.

## 1. Check the flake entry

`flake.nix` has one `linux` entry for every Linux machine. It reads your
username and home directory from `$USER` and `$HOME` at install time, so
there's nothing per-machine to add. It assumes `x86_64-linux`. On an ARM box,
add an `aarch64-linux` entry beside it.

## 2. Install

There's no `scripts/linux/install-nix.sh` yet, so `make install-nix` stops
and says so. Until that script exists, do by hand what the macOS one
(`scripts/darwin/install-nix.sh`) does:

```bash
# Nix, via the Determinate Systems installer (asks to confirm, needs sudo)
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh

# Apply this machine's entry, using the home-manager pinned in flake.lock
cd ~/dotfiles
nix run --inputs-from . home-manager -- switch -b hm-backup --impure --flake .#linux
```

The installer sets up the multi-user daemon with systemd, so it needs a
systemd-based distro. Fedora, RHEL and Rocky all qualify.

**Docker / containers:** a container has no systemd for the daemon. Don't run
this in the goss test image. That image still builds its tools from source
(see `Dockerfile-RHEL`).

## 3. Commit the lock file and remove old installs

Same as macOS: commit `flake.lock`, then remove older installs that come
before the Nix profile on `PATH`. That's usually:

```bash
rm ~/.local/bin/herdr
rm -rf ~/.atuin            # history lives in ~/.local/share/atuin
```

On Linux, also check `which -a atuin herdr` for copies installed into
`/usr/local/bin` or by a package manager. A `dnf`-installed copy in `/usr/bin`
comes after the Nix profile on `PATH`, so it's harmless, but you can remove it.

## 4. Check

```bash
which herdr atuin          # ~/.nix-profile/bin/...
herdr config check
```

## Day to day

| Task | Command |
|---|---|
| Newer versions | `nix flake update`, then the switch command above; commit `flake.lock` |
| Apply a pulled `flake.lock` | the switch command above |

Don't use `herdr update`. Versions only change through `flake.lock`.

## Undoing it

```bash
nix run home-manager -- uninstall
/nix/nix-installer uninstall
```
