#!/bin/bash

function join() {
  local IFS="$1"
  shift
  echo "$*"
}

function make_symlnks() {
  echo "[!] Installing dotfiles"
  local thisdir=$(pwd)
  dotfiles=("zshrc" "zshrc.d" "tmux.conf" "vimrc" "gitconfig" "gitconfig.d")
  for file in "${dotfiles[@]}"
  do
    echo " [-] installing $file"
    symlink="${HOME}/.${file}"
    realfile="${thisdir}/${file}"
    [ -e $symlink  ] && rm -rf $symlink
    ln -s $realfile $symlink
  done
  echo "[!] All dotfiles are installed"
  echo "-------------------------------"
  ls -allh ~/ | grep -E "($(join '|' ${dotfiles[@]}))"
  echo "-------------------------------"
}

make_symlnks
