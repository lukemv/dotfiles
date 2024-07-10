#!/bin/bash
docker build -t dotfiles .
docker run -it -v "$(pwd):/home/me/dotfiles" dotfiles /usr/bin/zsh
echo "[**] The container has exited"