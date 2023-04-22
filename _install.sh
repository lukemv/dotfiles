#!/bin/bash

function join() {
  local IFS="$1"
  shift
  echo "$*"
}

function install_configs() {
  echo "[!] Installing config files"
  local thisdir=$(pwd)
  local configs=("gh/config.yml")
  for filepath in "${configs[@]}"
  do
    echo " [-] installing $filepath"
    symlink="${HOME}/.config/${filepath}"
    realfile="${thisdir}/config/${filepath}"
    [ -e $symlink  ] && rm -rf $symlink
    ln -s $realfile $symlink
  done
  echo "[!] All configs are installed"
  echo "-------------------------------"
  # ls -allh ~/ | grep -E "($(join '|' ${dotfiles[@]}))"
  echo "-------------------------------"
}

function install_dotfiles() {
  echo "[!] Installing dotfiles"
  local thisdir=$(pwd)
  local dotfiles=("bashrc" "zshrc" "zshrc.d" "tmux.conf" "vimrc" "gitconfig" "gitconfig.d")
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

install_dotfiles
install_configs
