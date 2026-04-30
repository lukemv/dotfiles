export GOROOT="/usr/local/go"
export GOPATH="$HOME/code"
export PATH="$GOPATH/bin:$GOROOT/bin:$PATH"
export PATH="/usr/local/go/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.npm-global/bin:$PATH"
export PATH="$HOME/.scripts:$PATH"
export PATH="$HOME/bin:$PATH"
export PATH="/usr/local/opt/openssl/bin:$PATH"
export PATH="$HOME/code/tfenv/bin:${PATH}"
export PATH="/opt/homebrew/bin:$PATH"
export PATH="$PATH:$HOME/dotfiles/scripts"
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
# Some dotfiles for work stuff
export DOTFILES_SHARED_PATH="$HOME/dotfiles-shared"
export SHARED_DOTFILES_PATH="$HOME/dotfiles-shared"
export DOTFILES_WORK_PATH="$HOME/dotfiles-shared"

# Set browser based on OS
if [[ "$(uname)" == "Darwin" ]]; then
  export BROWSER=open
else
  export BROWSER=google-chrome
fi

# Starship prompt configuration
export STARSHIP_CONFIG="$HOME/.config/starship.toml"
