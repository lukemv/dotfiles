alias rc="source ~/.zshrc"

alias c="clear"
alias l="eza -l --icons --git -a"
alias lt="eza --tree --level=2 --long --icons --git"
cx() { cd "$@" && l }

alias gl="git log"
alias gp="git push"
alias gpf="git push --force"
alias gs="git stash"
alias gsa="git stash apply"
alias gfa="git fetch --all"
alias gcur="git rev-parse --short HEAD"
alias gc="git commit --amend"

alias dps="docker ps"

alias gres="git checkout main && git pull --rebase"
alias mres="git checkout master && git pull --rebase"
# Kubernetes aliases
alias k="kubectl"
alias kctx="kubectl ctx"
alias kns="kubectl ns"

alias kgp="kubectl get pod"
alias kgs="kubectl get svc"
alias kgc="kubectl get configmap"
alias kgi="kubectl get ingress"
alias kdp="kubectl describe pod"
alias kds="kubectl describe svc"
alias kdc="kubectl describe configmap"
alias kdi="kubectl describe ingress"
alias kdel="kubectl delete"
alias kdpod="kubectl describe pod"
alias kdserv="kubectl describe service"
alias kdep="kubectl describe deployment"

# Terraform aliases
alias tf="terraform"
alias tfp="terraform plan"
alias tfa="terraform apply"
alias tfi="terraform init"
alias dotfiles="cd ~/.dotfiles"

# http xh aliases
alias http="xh"
