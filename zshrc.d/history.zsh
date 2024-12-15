HISTFILE=~/.zsh_history
# history limit of the file on disk
export HISTFILESIZE=10000000
# current session's history limit,
# also following this https://unix.stackexchange.com/a/595475 $HISTSIZE should be at least 20% bigger than $SAVEHIST
export HISTSIZE=20000000
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY
# records the time when each command was executed along with the command
setopt EXTENDED_HISTORY
# ensures that each command entered in the current session is appended to the history file immediately after execution
setopt APPENDHISTORY
export HISTTIMEFORMAT="%d/%m/%Y %H:%M]"

