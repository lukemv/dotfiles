#!/bin/bash

# Define the file to store the window order
WINDOW_FILE="$HOME/.tmux_window_order"

# Function to update the window file
update_window_file() {
    # Remove the window if it already exists in the file
    grep -v "^$1$" "$WINDOW_FILE" > "$WINDOW_FILE.tmp"
    # Add the window to the top of the file
    echo "$1" > "$WINDOW_FILE"
    cat "$WINDOW_FILE.tmp" >> "$WINDOW_FILE"
    rm "$WINDOW_FILE.tmp"
}

# Function to get the list of windows
get_windows() {
    tmux list-windows -F '#I: #{window_name}'
}

# Function to load the window order from the file
load_window_order() {
    if [ -f "$WINDOW_FILE" ]; then
        cat "$WINDOW_FILE"
    fi
}

# Function to merge the current windows with the persisted order
merge_windows_with_order() {
    current_windows=$(get_windows)
    ordered_windows=$(load_window_order)
    
    # Combine and sort the windows, with persisted ones at the top
    all_windows=$( (echo "$ordered_windows"; echo "$current_windows") | awk '!seen[$0]++' )
    
    # Swap the first two entries
    first=$(echo "$all_windows" | sed -n '1p')
    second=$(echo "$all_windows" | sed -n '2p')
    rest=$(echo "$all_windows" | sed '1,2d')
    
    echo -e "$second\n$first\n$rest"
}

# Get the list of windows, combining with persisted order
windows=$(merge_windows_with_order)

# Use fzf to select a window
selected=$(echo "$windows" | fzf --height=40% --reverse)

# Extract the window index
index=$(echo "$selected" | cut -d: -f1)

# Switch to the selected window
if [ -n "$index" ]; then
    tmux select-window -t "$index"
    update_window_file "$index: $(echo "$selected" | cut -d: -f2-)"
fi

