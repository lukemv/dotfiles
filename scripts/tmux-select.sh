#!/bin/bash
windows=$(python ~/dotfiles/scripts/tmux-choose.py)

# Use fzf to select a window
selected=$(echo "$windows" | fzf --height=40% --reverse)

# Extract the window index
index=$(echo "$selected" | cut -d: -f1)

# Switch to the selected window
if [ -n "$index" ]; then
    cp /tmp/tmux.prev.1 /tmp/tmux.prev.2
    echo $selected > /tmp/tmux.prev.1
    tmux select-window -t "$index"
    update_window_file "$index: $(echo "$selected" | cut -d: -f2-)"
fi

