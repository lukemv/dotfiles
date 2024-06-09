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
	local dotfiles=("bashrc" "zshrc" "zshrc.d" "tmux.conf" "tmux.conf.local" "vimrc" "gitconfig" "gitignore_global" "gitconfig.d")
	for file in "${dotfiles[@]}"; do
		echo " [-] installing $file"
		symlink="${HOME}/.${file}"
		realfile="${thisdir}/${file}"
		[ -e $symlink ] && rm -rf $symlink
		ln -s $realfile $symlink
	done
	echo "[!] All dotfiles are installed"
	echo "-------------------------------"
	ls -allh ~/ | grep -E "($(join '|' ${dotfiles[@]}))"
	echo "-------------------------------"
}

function install_ohmy() {
	if [ ! -d "$HOME/.oh-my-zsh" ]; then
		pushd /tmp >/dev/null
		curl --insecure -OL "https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh"
		popd >/dev/null
		sha=$(shasum /tmp/install.sh)
		res=$(echo $sha | awk '$1=="32cfb5d2b7e4a21f61ff4fc676dd8f0e056eb310"{print"VALID"}')
		[ "$res" = "VALID" ] && chmod a+x /tmp/install.sh && /tmp/install.sh
		[ "$res" != "VALID" ] && echo "oh-my-zsh shasum is invalid want: 32cfb5d2b7e4a21f61ff4fc676dd8f0e056eb310 got: $sha"
	else
		echo "[!] Skipping zsh installation"
	fi
}

install_plug
install_ohmy
install_dotfiles
install_configs
