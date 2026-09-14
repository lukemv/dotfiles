#!/usr/bin/env bash
# Point this repository's git at the tracked `githooks/` directory.
#
# Hooks in `.git/hooks` are not versioned and do not survive a fresh clone, so
# the hooks live in `githooks/` and `core.hooksPath` is aimed at them. The
# pre-commit hook there blocks commits carrying employer-internal identifiers
# into what is a public repository.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

current="$(git config --get core.hooksPath || true)"
if [ "$current" = "githooks" ]; then
  echo "git hooks already pointed at githooks/"
  exit 0
fi

git config core.hooksPath githooks
echo "core.hooksPath -> githooks/ ($(ls githooks | tr '\n' ' '))"
