[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export GOROOT="/usr/local/go"
export GOPATH="$HOME/code/"
export PATH="$GOPATH/bin:$GOROOT/bin:$PATH"
export PATH="/usr/local/go/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.scripts:$PATH"
export PATH="$HOME/bin:$PATH"
export PATH="/usr/local/opt/openssl/bin:$PATH"
export PATH="$HOME/.krew/bin:${PATH}"
export PATH="$HOME/code/tfenv/bin:${PATH}"

# This allows me to retain history between my environment
# being killed and recreated
export HISTFILE="/srv/code/zsh_history_soe"
