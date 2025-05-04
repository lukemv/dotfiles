# Load all files from .shell/bashrc.d directory
if [ -d $HOME/.zshrc.d ]; then
  for file in $HOME/.zshrc.d/*.zsh; do
    source $file
  done
fi

for file in $DOTFILES_SHARED_PATH/functions/*.sh; do
  [ -f "$file" ] && source "$file"
done

eval "$(starship init zsh)"
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.zsh/zsh-z/z.sh
source ~/.atuin/bin/env
eval "$(atuin init zsh)"
