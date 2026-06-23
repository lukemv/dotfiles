export GOROOT="/usr/local/go"
export GOPATH="$HOME/code"
# Mirror go's default (GOPATH/bin) explicitly so tools like go.nvim, which check
# $GOBIN, stop warning. Functionally identical to leaving it unset.
export GOBIN="$GOPATH/bin"

# Auto-deduplicate path entries (keeps first occurrence). path and PATH are tied.
typeset -U path PATH

# Cross-platform entries. Prepended in order; later entries take higher priority. Each
# directory is skipped if it does not exist so PATH stays clean across machines.
_path_candidates=(
  "$GOPATH/bin"
  "$GOROOT/bin"
  "$HOME/.local/bin"
  "$HOME/.npm-global/bin"
  "$HOME/bin"
  "$HOME/code/tfenv/bin"
  "${KREW_ROOT:-$HOME/.krew}/bin"
  "$HOME/.local/scripts"
)

# OS-specific entries. Homebrew lives under /opt on Apple Silicon, while /usr/local/go and
# /usr/local/opt/openssl are Linux / Intel-mac conventions.
if [[ "$(uname)" == "Darwin" ]]; then
  _path_candidates+=("/opt/homebrew/bin")
else
  _path_candidates+=(
    "/usr/local/go/bin"
    "/usr/local/opt/openssl/bin"
  )
fi

for _dir in $_path_candidates; do
  [[ -d $_dir ]] && path=("$_dir" $path)
done
unset _dir _path_candidates
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
