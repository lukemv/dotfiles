# Dotfiles and workstation configuration

## Quick Start

```bash
# Install shell-only configuration
make install-shell

# Install desktop environment (Fedora/Wayland)
make install-desktop

# Run tests to verify everything works
make test
```

## Testing

This repository includes comprehensive [Goss](https://goss.rocks/) tests to validate configurations.

### Test on Host System
```bash
make test
# Or: goss validate --format documentation
```

### Test in Docker (Safe for Major Changes)
```bash
# Build and test in isolated container
make test-docker

# Or manually explore in container
docker compose build dot
docker compose run -it dot /bin/zsh
cd /home/me/dotfiles
./install install.shell.conf.yaml
goss validate --format documentation
```

**What gets tested:** Shell configuration, tool installations (nvim, git, tmux, cargo tools), config file symlinks, plugins, and integration tests. See `tests/README.md` for details.

## Bluetooth

```
bluetoothctl
# Inside the prompt:
power on
agent on
default-agent
scan on
# Wait for AirPods to appear, then:
pair XX:XX:XX:XX:XX:XX
connect XX:XX:XX:XX:XX:XX
trust XX:XX:XX:XX:XX:XX
(Airpods: CC:08:FA:EF:4B:FB)
exit
```

## GPG Stuff

Generate a new gpgkey using the algo of your choice.

```
$ gpg --default-new-key-algo rsa4096 --gen-key
```

Listing your keys to find the ID of the key you just generated. This key ID
is what goes into the `signing_key` attribute of your gitconfigs

```
$ gpg --list-secret-keys --keyid-format=long

/yourhome/.gnupg/pubring.kbx
-----------------------------------------
sec   rsa4096/<YOURKEYID> 2023-04-22 [SC] [expires: 2025-04-21]
      B89LETTERSLETTERSLETTERSLETTERS
uid                 [ultimate] you <you@yourdomain.com>

```

Exporting your public key, you'll upload this to your git hosting service.

```
$ gpg --armor --export YOURKEYID

-----BEGIN PGP PUBLIC KEY BLOCK-----
YOUR STUFF
-----END PGP PUBLIC KEY BLOCK-----
```

## Adding a second ID to the key

1. Find out the key ID using `gpg --list-secret-keys --keyid-format=long`
2. Edit the key with `gpg --edit-key <ID>`
3. On the GnuPG prompt, use `gpg> adduid`
4. Answer to the interactive prompts for details.
5. Confirm the details.
6. Passphrase for the key will be asked.
7. Remember to save with `gpg> save`

You could also remove the old user ID without email address using `gpg> deluid`

## Other random tweaks

Allow press and hold in Visual Studio Code.

```bash
defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false
```

Speed up keyrepeat

```bash
defaults write -g InitialKeyRepeat -int 10 # normal minimum is 15 (225 ms)
defaults write -g KeyRepeat -int 1 # normal minimum is 2 (30 ms)
```

## Login Lingering

This is required to get the monitors automation to work, (after running the linger and monitors salt profiles)

```
systemctl --user enable --now monitors.timer
```


## Documentation

Additional documentation is available in the `docs/` directory:

- [Go Debugging in Neovim](docs/go-debugging.md) - Comprehensive guide to debugging Go applications with nvim-dap

