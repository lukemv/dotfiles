#!/bin/bash
target=$1
docker build -f "Dockerfile-$target" -t dotfiles .
docker run -it -v "$(pwd):/home/me/dotfiles" dotfiles /usr/bin/zsh
echo "[**] The container has exited"
