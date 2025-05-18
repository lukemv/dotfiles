if command -v rbenv >/dev/null; then
  eval "$(rbenv init -)"
  eval "$(rbenv virtualenv-init -)"
  export RBENV_ROOT="/usr/local/rbenv"
  export PATH="$RBENV_ROOT/bin:$PATH"
fi

