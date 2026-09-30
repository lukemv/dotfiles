#!/usr/bin/env python3
"""Fail if any tracked YAML, TOML or JSON config does not parse.

A config that no longer parses is usually only noticed when the tool that
reads it starts, on whichever machine happens to install it next. Parsing
every tracked file here catches that on push instead.

Some files carry the extension without being plain data, so they are skipped:
Salt states are Jinja templates, goss files are Go templates, and VS Code
settings are JSONC (JSON with comments).
"""
import json
import subprocess
import sys
import tomllib

import yaml

SKIP_PREFIXES = ("salt/", "tests/", "vscode/")
SKIP_FILES = {"goss.yaml"}


def parse(path):
    if path.endswith((".yaml", ".yml")):
        with open(path) as f:
            list(yaml.safe_load_all(f))
    elif path.endswith(".toml"):
        with open(path, "rb") as f:
            tomllib.load(f)
    elif path.endswith(".json"):
        with open(path) as f:
            json.load(f)
    else:
        return False
    return True


def main():
    files = subprocess.run(
        ["git", "ls-files"], capture_output=True, text=True, check=True
    ).stdout.splitlines()
    failed = 0
    for path in files:
        if path in SKIP_FILES or path.startswith(SKIP_PREFIXES):
            continue
        try:
            if parse(path):
                print(f"ok   {path}")
        except Exception as e:
            failed += 1
            print(f"FAIL {path}: {e}")
    return 1 if failed else 0


if __name__ == "__main__":
    sys.exit(main())
