# Nix on Windows

**Nix doesn't run natively on Windows.** The flake can't pin tools for native
Windows, so `install.ps1` stays the way native Windows is set up. You have two
options.

## Option A: native Windows (current setup)

`install.ps1` composes the herdr config from `herdr\config.shared.toml` plus
`herdr\config.windows.toml`, as before. herdr and atuin are installed by hand,
so **you** keep their versions in step with the Mac and Linux machines.

That's how the herdr breakage happened: the shared config used a feature newer
than the installed binary. To avoid repeating it:

1. Find the pinned version on any Nix machine:
   ```bash
   nix eval --raw ~/dotfiles#homeConfigurations.darwin.pkgs.herdr.version
   ```
2. Install that version (or newer) on Windows.
3. After re-running `install.ps1`, check the composed config is accepted:
   ```powershell
   herdr config check
   ```
   If it reports a parse error, the binary is older than the shared config
   expects. Upgrade herdr; don't edit the shared config to suit an old version.

## Option B: WSL2

Inside WSL2 (Ubuntu or Fedora), Nix works the same as on Linux, so follow
[nix-linux.md](nix-linux.md). Do this if you run your shell and herdr inside
WSL rather than natively.

- WSL needs systemd for the Nix daemon. Make sure `/etc/wsl.conf` has:
  ```ini
  [boot]
  systemd=true
  ```
  Then run `wsl --shutdown` from PowerShell and reopen WSL.
- Clone the dotfiles inside the WSL filesystem (`~/dotfiles`), not under
  `/mnt/c`. Nix and git are much slower across that boundary.
- Tools installed in WSL are only available inside WSL. Native Windows apps
  won't see them.
