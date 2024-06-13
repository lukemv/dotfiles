#!/bin/bash

# List tmux windows
windows=$(tmux list-windows -F '#I: #{window_name}')

# Use fzf to select a window
selected=$(echo "$windows" | fzf --height=40% --reverse)

# Extract the window index
index=$(echo "$selected" | cut -d: -f1)

# Switch to the selected window
[ -n "$index" ] && tmux select-window -t "$index"
