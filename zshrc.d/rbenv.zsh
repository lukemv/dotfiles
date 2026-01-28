# rbenv initialization - check multiple possible locations
if command -v rbenv >/dev/null 2>&1; then
  # rbenv is in PATH (e.g., installed via Homebrew on macOS)
  eval "$(rbenv init -)"
elif [[ -d "$HOME/.rbenv" ]]; then
  # User-local rbenv installation
  export RBENV_ROOT="$HOME/.rbenv"
  export PATH="$RBENV_ROOT/bin:$PATH"
  eval "$(rbenv init -)"
elif [[ -x /usr/local/rbenv/bin/rbenv ]]; then
  # System-wide rbenv (Linux)
  export RBENV_ROOT="/usr/local/rbenv"
  export PATH="$RBENV_ROOT/bin:$PATH"
  eval "$(rbenv init -)"
fi

