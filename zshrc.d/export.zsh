export GOROOT="/usr/local/go"
export GOPATH="$HOME/code"

# Auto-deduplicate path entries (keeps first occurrence). path and PATH are tied.
typeset -U path PATH

# Prepended in order; later entries take higher priority. Skipped if the directory
# does not exist on this host so PATH stays clean across machines.
for _dir in \
  "$GOPATH/bin" \
  "$GOROOT/bin" \
  "/usr/local/go/bin" \
  "$HOME/.local/bin" \
  "$HOME/.npm-global/bin" \
  "$HOME/.scripts" \
  "$HOME/bin" \
  "/usr/local/opt/openssl/bin" \
  "$HOME/code/tfenv/bin" \
  "/opt/homebrew/bin" \
  "${KREW_ROOT:-$HOME/.krew}/bin"; do
  [[ -d $_dir ]] && path=("$_dir" $path)
done

# Appended (lowest priority).
for _dir in \
  "$HOME/dotfiles/scripts"; do
  [[ -d $_dir ]] && path+=("$_dir")
done
unset _dir
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
