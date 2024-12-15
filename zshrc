# Load all files from .shell/bashrc.d directory
autoload -Uz compinit
compinit

if [ -d $HOME/.zshrc.d ]; then
  for file in $HOME/.zshrc.d/*.zsh; do
    source $file
  done
fi

export SHARED_DOTFILES_PATH="$HOME/dotfiles-shared"

if [ -d $SHARED_DOTFILES_PATH ]; then
  for file in $SHARED_DOTFILES_PATH/functions/*.sh; do
    source $file
  done
fi

source ~/.zsh/spaceship/spaceship.zsh
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.zsh/zsh-z/z.sh
source ~/.atuin/bin/env
eval "$(atuin init zsh)"
