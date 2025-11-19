# Goss Tests for Dotfiles

This directory contains [Goss](https://goss.rocks/) tests to validate that the dotfiles configuration is working correctly.

## Test Structure

- `goss.yaml` - Main test configuration that imports all test suites
- `tests/shell.yaml` - Shell environment tests (zsh, bash, directories)
- `tests/tools.yaml` - Tool installation tests (nvim, cargo tools, starship, etc.)
- `tests/configs.yaml` - Configuration file symlink and content tests
- `tests/plugins.yaml` - Plugin and integration tests

## Running Tests

### On Host System

```bash
# Run all tests
make test

# Or directly with goss
goss validate --format documentation
```

### In Docker Container

```bash
# Build and run tests in clean container
make test-docker

# Or step by step
make test-docker-build
docker compose run --rm dot /bin/zsh
cd /home/me/dotfiles
./install install.shell.conf.yaml
goss validate --format documentation
```

## What Gets Tested

### Shell Environment
- ✓ Zsh and bash are installed
- ✓ User shell is set to zsh
- ✓ Required directories exist (~/.local/bin, ~/.config, etc.)
- ✓ Shell config files are symlinked correctly
- ✓ PATH contains critical directories

### Tools
- ✓ Neovim is installed and can start
- ✓ Git, tmux are available
- ✓ Rust cargo tools (eza, ripgrep, atuin) are installed
- ✓ Starship prompt is installed
- ✓ All tools can execute successfully

### Configuration Files
- ✓ All dotfiles are symlinked to correct locations
- ✓ Git, tmux, nvim, starship configs exist
- ✓ Config files have valid content
- ✓ Critical config sections are present

### Plugins & Integrations
- ✓ Tmux plugin manager (TPM) is installed
- ✓ Zsh plugins are available
- ✓ Neovim lazy.nvim is set up (when not skipped)
- ✓ Shells can load without errors
- ✓ Tmux can start successfully

## Environment Variables

- `SKIP_NVIM_PLUGINS=true` - Skip nvim plugin directory checks (useful for fresh installs)
- `CI=true` - Skip rust tool checks (useful in minimal CI environments)

## Troubleshooting

### Test Failures

1. **Symlink tests fail**: Run `./install install.shell.conf.yaml` first
2. **Tool tests fail**: Ensure tools are installed (check Dockerfile-RHEL for install commands)
3. **Plugin tests fail**: Run `make tmux-plugins` and open nvim to install plugins
4. **Path tests fail**: Restart your shell after installation

### Updating Tests

When adding new configurations:
1. Add corresponding test to appropriate test file
2. Run tests locally first: `make test`
3. Verify in Docker: `make test-docker`
4. Commit test updates with configuration changes

## Safe Refactoring Workflow

The tests enable safe refactoring:

1. **Baseline**: Run `make test` to ensure current state passes
2. **Refactor**: Make organizational changes
3. **Verify**: Run `make test` again to confirm nothing broke
4. **Docker Test**: Run `make test-docker` for clean environment validation

This lets you reorganize files, rename directories, and restructure configs with confidence.
