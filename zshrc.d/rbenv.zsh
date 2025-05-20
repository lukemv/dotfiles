if command -v /usr/local/rbenv/bin/rbenv >/dev/null; then
  eval "$(/usr/local/rbenv/bin/rbenv init -)"
  export RBENV_ROOT="/usr/local/rbenv"
  export PATH="$RBENV_ROOT/bin:$PATH"
fi

