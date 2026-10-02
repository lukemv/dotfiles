# Nix on macOS: getting started

Nix pins the CLI tools whose versions these dotfiles depend on: currently
**herdr** and **atuin**. `flake.lock` records the exact versions, so every
machine runs the same ones, and a config change that needs a newer tool lands
in the same commit as the version bump.

Nix only installs the tools. Configs are still linked by Dotbot
(`./install install.shell.conf.yaml`) as before.

## First-time setup

Run these **from a terminal that is not inside herdr**. Step 4 removes the
herdr binary that a running herdr session is using.

### 1. Make sure the flake is committed

Nix ignores files git doesn't track. On a fresh clone they already are, so
skip this step there.

```bash
cd ~/dotfiles
git status flake.nix nix/
```

### 2. Run the installer

```bash
make install-nix
```

This runs `scripts/darwin/install-nix.sh`, which:

1. **Installs Nix** if it isn't there, using the
   [Determinate Systems installer](https://determinate.systems/nix-installer/).
   It shows its plan and asks you to confirm, then asks for your password.
   It creates a `/nix` volume, a background daemon, and a few `_nixbld`
   users. That's expected.
2. **Finds this machine's entry** in `flake.nix`, named `<your username>@darwin`
   (for example `me@darwin`).
3. **Applies it** with home-manager, which installs the pinned herdr and atuin
   into `~/.nix-profile`.
4. **Lists older copies** of herdr or atuin that would still win on `PATH`.

The first run downloads a lot and can take several minutes. Later runs are
quick.

### 3. Commit the lock file

The first run creates `flake.lock`. Commit it. It's the file that pins the
versions.

```bash
git add flake.lock && git commit -m "chore(nix): lock tool versions"
```

### 4. Remove the old installs

The script prints the exact commands. Usually they're these:

```bash
rm ~/.local/bin/herdr      # from `herdr update` / the herdr install script
rm -rf ~/.atuin            # atuin's own installer; history is NOT in here
```

This matters because `zshrc.d/export.zsh` puts `~/.local/bin` ahead of the Nix
profile, and `~/.atuin/bin/env` puts itself first. Leftovers there silently win
over the pinned versions.

Your atuin history is in `~/.local/share/atuin` and isn't touched.

### 5. Check

Open a new terminal:

```bash
which herdr atuin          # both should be under ~/.nix-profile/bin
herdr --version
atuin --version
herdr config check         # should say: config: ok
```

If herdr was running, restart its server so it picks up the new binary:

```bash
herdr server stop          # closes every herdr pane
herdr
```

## Day to day

| Task | Command |
|---|---|
| Get newer versions of everything | `make nix-update`, test, then commit `flake.lock` |
| Re-apply after pulling someone's `flake.lock` | `make install-nix` |
| Add a tool | add it to `home.packages` in `nix/home.nix`, then `make install-nix` |
| See what's pinned | `nix flake metadata` |

**Don't run `herdr update`** any more. It can't replace a binary in the
read-only Nix store. Versions change only through `flake.lock`.

## Undoing it

```bash
nix run home-manager -- uninstall   # removes the home-manager tools
/nix/nix-installer uninstall        # removes Nix entirely, including /nix
```

Then reinstall herdr and atuin the old way if you need them.

## Troubleshooting

**`error: flake.nix is not tracked by git`**: run `git add flake.nix nix/`.
Nix only sees tracked files.

**`flake.nix has no homeConfigurations."<you>@darwin"`**: your macOS username
isn't in `flake.nix` yet. Copy the `me@darwin` entry and change the
username and home directory.

**`which herdr` still points at `~/.local/bin`**: you skipped step 4, or
haven't opened a new shell since.

**`nix: command not found` in a new terminal**: a macOS update can reset
`/etc/zshrc`. The Determinate installer normally repairs this itself. In the
meantime, run
`. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh`.
