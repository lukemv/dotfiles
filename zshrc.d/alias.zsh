alias rc="source ~/.zshrc"

alias c="clear"
alias l="eza -l --icons --git -a"
alias lt="eza --tree --level=2 --long --icons --git"
cx() { cd "$@" && l }

alias fd='fdfind'

alias gp="git push"
alias gpf="git push --force"
alias gs="git stash"
alias gsa="git stash apply"
alias gcur="git rev-parse --short HEAD"
alias gc="git commit --amend"

alias gres="git checkout main && git pull --rebase"
alias mres="git checkout master && git pull --rebase"
# Kubernetes aliases
alias k="kubectl"
alias kctx="kubectl ctx"
alias kns="kubectl ns"
# terraform aliases
alias tf="terraform"
alias tfp="terraform plan"
alias tfa="terraform apply"
alias tfi="terraform init"
