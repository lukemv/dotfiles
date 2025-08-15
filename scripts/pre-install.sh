#!/usr/bin/env bash

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if running as root
check_root() {
    if [[ $EUID -ne 0 ]]; then
        log_error "This script must be run as root"
        exit 1
    fi
    log_info "Running as root - proceeding with installation"
}

# Check if we're on a RHEL-based system
check_system() {
    if [[ ! -f /etc/redhat-release ]]; then
        log_error "This script is designed for RHEL-based systems (RHEL, CentOS, Rocky Linux, AlmaLinux)"
        exit 1
    fi
    
    log_info "Detected RHEL-based system: $(cat /etc/redhat-release)"
}

# Determine target user early
determine_target_user() {
    if [[ $EUID -eq 0 ]]; then
        # Running as root, need to determine target user
        if [[ -n "$SUDO_USER" ]]; then
            TARGET_USER="$SUDO_USER"
        elif [[ -n "$1" ]]; then
            TARGET_USER="$1"
        else
            log_error "Running as root but no target user specified. Please run with: sudo ./scripts/pre-install.sh <username>"
            exit 1
        fi
        log_info "Running as root, will install user tools for: $TARGET_USER"
    else
        TARGET_USER="$USER"
        log_info "Running as user: $TARGET_USER"
    fi
}

# Update system packages
update_system() {
    log_info "Updating system packages..."
    sudo dnf makecache
    log_success "System package cache updated"
}

# Install basic dependencies
install_basic_deps() {
    log_info "Checking basic dependencies..."
    
    # Check if key packages are already installed
    if command -v zsh &> /dev/null && command -v tmux &> /dev/null && command -v git &> /dev/null; then
        log_info "Basic dependencies already installed, skipping..."
        return 0
    fi
    
    log_info "Installing basic dependencies..."
    sudo dnf install -y \
        zsh \
        tmux \
        git \
        gcc-c++ \
        cmake \
        make \
        unzip \
        gettext \
        glibc-gconv-extra \
        curl \
        wget \
        vim \
        htop \
        tree \
        ripgrep \
        fzf \
        util-linux-user
    log_success "Basic dependencies installed"
}

# Install ninja-build based on architecture
install_ninja() {
    log_info "Checking ninja-build..."
    
    # Check if ninja is already installed
    if command -v ninja &> /dev/null; then
        log_info "ninja-build already installed, skipping..."
        return 0
    fi
    
    log_info "Installing ninja-build..."
    
    ARCH=$(uname -m)
    if [[ "$ARCH" == "x86_64" ]]; then
        NINJA_URL="https://dl.rockylinux.org/pub/rocky/9/CRB/x86_64/os/Packages/n/ninja-build-1.10.2-6.el9.x86_64.rpm"
    elif [[ "$ARCH" == "aarch64" ]]; then
        NINJA_URL="https://dl.rockylinux.org/pub/rocky/9/CRB/aarch64/os/Packages/n/ninja-build-1.10.2-6.el9.aarch64.rpm"
    else
        log_error "Unsupported architecture: $ARCH"
        exit 1
    fi
    
    # Download and install ninja
    cd /tmp
    curl -OL "$NINJA_URL"
    sudo dnf install -y "./$(basename $NINJA_URL)"
    rm -f "./$(basename $NINJA_URL)"
    cd -
    log_success "ninja-build installed"
}

# Install and build Neovim
install_neovim() {
    log_info "Checking Neovim..."
    
    # Check if neovim is already installed (check both PATH and common install locations)
    if command -v nvim &> /dev/null || [[ -f /usr/local/bin/nvim ]] || [[ -f /usr/bin/nvim ]]; then
        log_info "Neovim already installed, skipping..."
        return 0
    fi
    
    log_info "Installing Neovim from source..."
    
    cd /tmp
    if [[ -d "neovim" ]]; then
        rm -rf neovim
    fi
    
    git clone --branch release-0.10 --single-branch https://github.com/neovim/neovim.git
    cd neovim
    make CMAKE_BUILD_TYPE=Release
    sudo make install
    cd -
    log_success "Neovim installed"
}

# Install Starship prompt (user-specific)
install_starship() {
    log_info "Checking Starship prompt..."
    
    # Check if starship is already installed for the target user
    if [[ $EUID -eq 0 ]]; then
        STARSHIP_CHECK="sudo -u $TARGET_USER bash -c 'command -v starship'"
    else
        STARSHIP_CHECK="command -v starship"
    fi
    
    if eval $STARSHIP_CHECK &> /dev/null; then
        log_info "Starship prompt already installed, skipping..."
        return 0
    fi
    
    log_info "Installing Starship prompt..."
    
    if [[ $EUID -eq 0 ]]; then
        # Switch to target user and set proper environment
        sudo -u "$TARGET_USER" bash -c '
            export HOME="$HOME"
            export PATH="$HOME/.local/bin:$PATH"
            curl -sS https://starship.rs/install.sh | sh -s -- --yes
        '
    else
        curl -sS https://starship.rs/install.sh | sh -s -- --yes
    fi
    
    log_success "Starship prompt installed"
}

# Install Rust and cargo tools (user-specific)
install_rust() {
    log_info "Checking Rust..."
    
    # Check if rust is already installed for the target user
    if [[ $EUID -eq 0 ]]; then
        RUST_CHECK="sudo -u $TARGET_USER bash -c 'command -v rustc && command -v cargo'"
        TOOLS_CHECK="sudo -u $TARGET_USER bash -c 'command -v eza && command -v atuin'"
    else
        RUST_CHECK="command -v rustc && command -v cargo"
        TOOLS_CHECK="command -v eza && command -v atuin"
    fi
    
    if eval $RUST_CHECK &> /dev/null; then
        log_info "Rust already installed, checking tools..."
        
        if eval $TOOLS_CHECK &> /dev/null; then
            log_info "Rust tools already installed, skipping..."
            return 0
        fi
    fi
    
    log_info "Installing Rust..."
    if [[ $EUID -eq 0 ]]; then
        # Install as target user
        sudo -u "$TARGET_USER" bash -c 'curl https://sh.rustup.rs -sSf | sh -s -- -y'
        
        # Install cargo tools as target user
        log_info "Installing Rust tools..."
        sudo -u "$TARGET_USER" bash -c 'source ~/.cargo/env && cargo install eza'
        sudo -u "$TARGET_USER" bash -c 'source ~/.cargo/env && cargo install ripgrep'
        sudo -u "$TARGET_USER" bash -c 'source ~/.cargo/env && cargo install atuin'
    else
        # Install as current user
        curl https://sh.rustup.rs -sSf | sh -s -- -y
        source ~/.cargo/env
        cargo install eza
        cargo install ripgrep
        cargo install atuin
    fi
    
    log_success "Rust and tools installed"
}

# Install Atuin shell history (user-specific)
install_atuin() {
    log_info "Checking Atuin shell history..."
    
    # Check if atuin is already installed for the target user
    if [[ $EUID -eq 0 ]]; then
        ATUIN_CHECK="sudo -u $TARGET_USER bash -c 'command -v atuin'"
    else
        ATUIN_CHECK="command -v atuin"
    fi
    
    if eval $ATUIN_CHECK &> /dev/null; then
        log_info "Atuin already installed, skipping..."
        return 0
    fi
    
    log_info "Installing Atuin shell history..."
    if [[ $EUID -eq 0 ]]; then
        sudo -u "$TARGET_USER" bash -c 'curl --proto "=https" --tlsv1.2 -LsSf https://setup.atuin.sh | sh'
    else
        curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh
    fi
    log_success "Atuin installed"
}

# Install additional useful tools
install_additional_tools() {
    log_info "Checking additional tools..."
    
    # Check if tools are already installed
    if command -v node &> /dev/null && command -v python3 &> /dev/null && command -v pip3 &> /dev/null; then
        log_info "Additional tools already installed, skipping..."
        return 0
    fi
    
    log_info "Installing additional tools..."
    
    # Install Node.js and npm (for various development tools)
    if ! command -v node &> /dev/null; then
        curl -fsSL https://rpm.nodesource.com/setup_lts.x | sudo bash -
        sudo dnf install -y nodejs
    fi
    
    # Install Python3 and pip
    sudo dnf install -y python3 python3-pip
    
    # Install additional Python packages (user-specific)
    log_info "Installing Python packages for user..."
    if [[ $EUID -eq 0 ]]; then
        sudo -u "$TARGET_USER" bash -c 'pip3 install --user --upgrade pip'
        sudo -u "$TARGET_USER" bash -c 'pip3 install --user neovim-remote'
    else
        pip3 install --user --upgrade pip
        pip3 install --user neovim-remote
    fi
    
    log_success "Additional tools installed"
}

# Note: Goss is expected to be already available

# Create necessary directories for dotbot (user-specific)
setup_directories() {
    log_info "Checking necessary directories..."
    
    # Check if directories already exist for the target user
    if [[ $EUID -eq 0 ]]; then
        DIR_CHECK="sudo -u $TARGET_USER bash -c '[[ -d ~/.local/bin && -d ~/.config && -d ~/.zsh && -d ~/.tmux/plugins && -d ~/.local/share/applications ]]'"
    else
        DIR_CHECK="[[ -d ~/.local/bin && -d ~/.config && -d ~/.zsh && -d ~/.tmux/plugins && -d ~/.local/share/applications ]]"
    fi
    
    if eval $DIR_CHECK &> /dev/null; then
        log_info "All necessary directories already exist, skipping..."
        return 0
    fi
    
    log_info "Creating necessary directories for dotbot..."
    
    if [[ $EUID -eq 0 ]]; then
        sudo -u "$TARGET_USER" bash -c 'mkdir -p ~/.local/bin ~/.config ~/.zsh ~/.tmux/plugins ~/.local/share/applications'
    else
        mkdir -p ~/.local/bin ~/.config ~/.zsh ~/.tmux/plugins ~/.local/share/applications
    fi
    
    log_success "Directories created for dotbot"
}

# Setup SSH key pair (user-specific)
setup_ssh_keys() {
    log_info "Checking SSH key setup..."
    
    if [[ $EUID -eq 0 ]]; then
        # Check if private key exists and public key is missing
        SSH_CHECK="sudo -u $TARGET_USER bash -c '[[ -f ~/.ssh/id_ed25519 && ! -f ~/.ssh/id_ed25519.pub ]]'"
        SSH_SETUP="sudo -u $TARGET_USER bash -c 'ssh-keygen -y -f ~/.ssh/id_ed25519 > ~/.ssh/id_ed25519.pub && chmod 644 ~/.ssh/id_ed25519.pub'"
    else
        SSH_CHECK="[[ -f ~/.ssh/id_ed25519 && ! -f ~/.ssh/id_ed25519.pub ]]"
        SSH_SETUP="ssh-keygen -y -f ~/.ssh/id_ed25519 > ~/.ssh/id_ed25519.pub && chmod 644 ~/.ssh/id_ed25519.pub"
    fi
    
    if eval $SSH_CHECK &> /dev/null; then
        log_info "Generating public key from private key..."
        if eval $SSH_SETUP; then
            log_success "SSH public key generated: ~/.ssh/id_ed25519.pub"
        else
            log_error "Failed to generate SSH public key"
        fi
    else
        log_info "SSH keys already properly configured, skipping..."
    fi
}

# Set zsh as default shell
setup_shell() {
    log_info "Checking zsh as default shell..."
    
    # Check if zsh is already the default shell for the target user
    CURRENT_SHELL=$(getent passwd "$TARGET_USER" | cut -d: -f7)
    if [[ "$CURRENT_SHELL" == "/usr/bin/zsh" ]]; then
        log_info "zsh is already the default shell for $TARGET_USER, skipping..."
        return 0
    fi
    
    log_info "Setting zsh as default shell for user: $TARGET_USER..."
    
    # Check if zsh is in the allowed shells list
    if ! grep -q "/usr/bin/zsh" /etc/shells; then
        log_warning "zsh is not in /etc/shells. Adding it..."
        echo "/usr/bin/zsh" | sudo tee -a /etc/shells
    fi
    
    log_info "Changing default shell to zsh for $TARGET_USER..."
    
    # Use usermod directly (more reliable than chsh)
    if sudo usermod -s /usr/bin/zsh "$TARGET_USER"; then
        log_success "Default shell changed to zsh for $TARGET_USER using usermod"
        log_warning "User $TARGET_USER needs to log out and back in for the change to take effect"
        
        # Verify the change
        NEW_SHELL=$(getent passwd "$TARGET_USER" | cut -d: -f7)
        if [[ "$NEW_SHELL" == "/usr/bin/zsh" ]]; then
            log_success "Shell change verified in /etc/passwd"
        else
            log_error "Shell change verification failed"
        fi
    else
        log_error "Failed to change shell for $TARGET_USER"
        exit 1
    fi
}

# Final setup and instructions
final_setup() {
    log_success "Pre-installation setup complete!"
    echo
    log_info "Next steps:"
    echo "1. Run the dotfiles installation: ./install install.shell.conf.yaml"
    echo "2. Test your configuration: goss validate (if available)"
    echo
    log_info "Installed system tools:"
    echo "- zsh, tmux, git"
    echo "- Neovim (built from source)"
    echo "- Starship prompt"
    echo "- Rust and cargo tools (eza, ripgrep, atuin)"
    echo "- Atuin shell history"
    echo
    log_info "Note: Shell configuration files and plugins will be handled by dotbot"
    log_info "Note: Goss is expected to be available for configuration testing"
}

# Main execution
main() {
    log_info "Starting pre-installation setup for dotfiles..."
    
    check_root
    check_system
    determine_target_user
    update_system
    install_basic_deps
    install_ninja
    install_neovim
    install_starship
    install_rust
    install_atuin
    install_additional_tools
    setup_directories
    setup_ssh_keys
    setup_shell
    final_setup
}

# Run main function
main "$@"
