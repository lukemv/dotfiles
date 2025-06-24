# Start timing zshrc load
if [[ -n "$ZSHRC_TIMING" ]]; then
  ZSHRC_START_TIME=$(date +%s.%N)
fi

autoload -Uz compinit
compinit

# Load all files from .shell/bashrc.d directory
if [ -d $HOME/.zshrc.d ]; then
  for file in $HOME/.zshrc.d/*.zsh; do
    source $file
  done
fi

if [[ -d "$DOTFILES_SHARED_PATH/functions" ]]; then
  for file in $DOTFILES_SHARED_PATH/functions/*.sh; do
    [ -f "$file" ] && source "$file"
  done
fi

eval "$(starship init zsh)"
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.zsh/zsh-z/z.sh
source ~/.atuin/bin/env
eval "$(atuin init zsh)"

# End timing and print result if ZSHRC_TIMING is set
if [[ -n "$ZSHRC_TIMING" ]]; then
  ZSHRC_END_TIME=$(date +%s.%N)
  ZSHRC_DURATION=$(echo "$ZSHRC_END_TIME - $ZSHRC_START_TIME" | bc -l)
  echo "zshrc load time: ${ZSHRC_DURATION}s"
fi
