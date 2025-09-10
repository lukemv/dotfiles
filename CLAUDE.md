# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a comprehensive dotfiles repository for workstation configuration management. It uses a combination of Dotbot for file linking, Salt for system configuration management, and Docker for testing configurations. The repository supports both shell-only and full desktop (Hyprland/Wayland) environments on RHEL-based systems.

## Architecture

### Configuration Management Stack
- **Dotbot**: Handles file linking and basic directory creation
- **Salt**: Manages system packages, services, and complex configurations
- **Docker**: Provides isolated testing environment
- **Shell Configuration**: Zsh with custom configurations, plugins, and tools

### Key Components
- **Shell Environment**: Zsh with autosuggestions, syntax highlighting, z directory jumping
- **Terminal**: tmux configuration with custom keybindings and plugin management
- **Editor**: Neovim configuration with Lazy plugin manager
- **Desktop Environment**: Hyprland (Wayland compositor) with Waybar, Mako, Kitty
- **Development Tools**: Git configuration, various language-specific setups

## Common Commands

### Installation and Setup
```bash
# Initial system setup (must run as root)
sudo ./scripts/pre-install.sh <username>

# Install shell configuration
./install install.shell.conf.yaml

# Install desktop environment (Fedora/Wayland)
./install install.fedora.conf.yaml

# Apply Salt profiles for development tools
sudo salt-call state.apply profiles.golang
sudo salt-call state.apply profiles.docker
sudo salt-call state.apply profiles.nodejs
sudo salt-call state.apply profiles.python
```

### Testing
```bash
# Test configuration in Docker container
docker compose build dot
docker compose run -it dot /bin/zsh

# Validate with Goss (if available)
goss validate
```

### tmux Management
```bash
# Choose tmux session interactively
~/.local/scripts/tmux-choose.py

# Select tmux session with fzf
~/.local/scripts/tmux-select.sh

# Development session
~/.local/scripts/tmux-dev
```

## Repository Structure

### Core Configuration Files
- `install` - Main Dotbot installation script
- `install.shell.conf.yaml` - Shell-only configuration
- `install.fedora.conf.yaml` - Desktop environment configuration
- `docker-compose.yml` - Testing environment setup

### Directory Layout
- `nvim/` - Neovim configuration with Lua-based plugin management
- `zshrc.d/` - Modular zsh configuration (aliases, exports, functions)
- `tmuxinator/` - tmux session templates
- `salt/` - Salt configuration management states and profiles
- `scripts/` - Utility scripts for development and system management
- `fedora/hypr/` - Hyprland window manager configuration
- `qmk_keymaps/` - Custom keyboard firmware configurations

### Submodules
- `dotbot/` - Dotbot installation framework
- `tpm/` - tmux plugin manager
- `zsh-autosuggestions/`, `zsh-syntax-highlighting/`, `zsh-z/` - Zsh plugins

## Development Workflow

### Adding New Configurations
1. Place configuration files in appropriate subdirectories
2. Update relevant Dotbot YAML configuration file to create symlinks
3. For system-level changes, create or modify Salt states in `salt/profiles/`
4. Test changes in Docker environment before applying to host system

### Commit Convention
- Subject line must be ≤80 characters
- Must start with `feat:`, `chore:`, or `fix:`
- Include detailed body wrapped at 100 characters
- Follow examples in `COMMIT_CONVENTION.md`

## Salt Configuration Management

Salt is used for system-level configuration management. Profiles are located in `salt/profiles/` and include:

- Development environments (golang, nodejs, python, ruby)
- System tools (docker, terraform, consul, nomad)
- Desktop components (bluetooth, hyprland, monitors)
- Security tools (1password-cli, warp)

Each profile is self-contained with its own `init.sls` file and any required supporting files.

## Testing and Validation

The repository includes Docker-based testing using Rocky Linux 9.3. The Dockerfile builds a complete environment with:
- Neovim built from source
- Rust toolchain with common CLI tools (eza, ripgrep, atuin)
- Starship prompt
- Complete shell environment setup

## Special Notes

### GPG Configuration
The repository includes guidance for setting up GPG keys for commit signing. Key IDs should be configured in `gitconfig.d/private`.

### SSH Key Management
The pre-install script can generate SSH public keys from existing private keys if needed.

### Desktop Environment
The Hyprland configuration includes window rules, workspace assignments, and integration with Waybar status bar and Mako notifications.

