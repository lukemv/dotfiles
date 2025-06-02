#!/bin/bash
SOURCE_DIR="$HOME/.local/share/nvim/gp/chats/"
while true; do
  DEST_DIR="$HOME/.notes"
    rsync -av ~/.local/share/nvim/gp/chats/ ~/.notes/
    sleep 5
done

