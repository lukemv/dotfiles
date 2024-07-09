#!/bin/bash

function join() {
	local IFS="$1"
	shift
	echo "$*"
}

# This part of the install is for creating symlinks beneath the ~/.config
# directory. The convention is that all of these folders should be in the
# root of this repository, they're then linked into ~/.config/<the folder>
function install_configs() {
	echo "[!] Installing config files"
	local thisdir=$(pwd)
	local configs=("gh" "nvim")
	for filepath in "${configs[@]}"; do
		echo " [-] installing $filepath"
		symlink="${HOME}/.config/${filepath}"
		realfile="${thisdir}/${filepath}"

		# Ensure that the parent folder exists before trying
		# to create the symlink in that path.
		parentdir="$(dirname "$symlink")"
		[ ! -d $parentdir ] && mkdir -p $parentdir

		[ -e $symlink ] && rm -rf $symlink
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
	local dotfiles=("bashrc" "zshrc" "zshrc.d" "tmux.conf" "tmux.reset.conf" "vimrc" "gitconfig" "gitignore_global" "gitconfig.d" "private")
	for file in "${dotfiles[@]}"; do
		echo " [-] installing $file"
		symlink="${HOME}/.${file}"
		realfile="${thisdir}/${file}"
		echo "Deleting $symlink"
		rm -rf $symlink
		ln -s $realfile $symlink
	done
	echo "[!] All dotfiles are installed"
	echo "-------------------------------"
	ls -allh ~/ | grep -E "($(join '|' ${dotfiles[@]}))"
	echo "-------------------------------"
}

function install_spaceship() {
	mkdir -p "$HOME/.zsh"
	git clone --depth=1 https://github.com/spaceship-prompt/spaceship-prompt.git "$HOME/.zsh/spaceship"
	git clone https://github.com/zsh-users/zsh-autosuggestions "$HOME/.zsh/zsh-autosuggestions"
	git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$HOME/.zsh/zsh-syntax-highlighting"
}

function install_tpm() {
	git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
}

install_spaceship
install_tpm
install_dotfiles
install_configs

