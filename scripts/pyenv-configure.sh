#!/usr/bin/env bash
set -euo pipefail

PYENV_ROOT="${HOME}/.pyenv"
PYTHON_VERSION="3.11.12"
PATH="${PYENV_ROOT}/bin:${PYENV_ROOT}/shims:${PATH}"

# Ensure pyenv is available
if ! command -v pyenv >/dev/null 2>&1; then
  echo "pyenv not found in PATH: ${PATH}"
  exit 1
fi

# Install Python if not present
if ! pyenv versions --bare | grep -Fxq "${PYTHON_VERSION}"; then
  echo "Installing Python ${PYTHON_VERSION} via pyenv..."
  pyenv install "${PYTHON_VERSION}"
else
  echo "Python ${PYTHON_VERSION} already installed."
fi

# Set global version if not already set
CURRENT_GLOBAL=$(pyenv global)
if [[ "${CURRENT_GLOBAL}" != "${PYTHON_VERSION}" ]]; then
  echo "Setting Python ${PYTHON_VERSION} as global version..."
  pyenv global "${PYTHON_VERSION}"
else
  echo "Python ${PYTHON_VERSION} is already the global version."
fi

