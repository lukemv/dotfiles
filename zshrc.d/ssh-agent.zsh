#!/bin/bash
# macOS uses the system ssh-agent with keychain integration
# Linux needs manual ssh-agent management

if [[ "$(uname)" == "Darwin" ]]; then
  # On macOS, use the system keychain for SSH keys
  # Keys are added with: ssh-add --apple-use-keychain ~/.ssh/id_ed25519
  # This is typically done once and persists across reboots
  :
else
  # Linux ssh-agent management
  AGENT_ENV="$HOME/.ssh/agent.env"

  start_agent() {
     (umask 077; ssh-agent > "$AGENT_ENV")
     . "$AGENT_ENV" > /dev/null
  }

  if [ -f "$AGENT_ENV" ]; then
     . "$AGENT_ENV" > /dev/null
     if ! ssh-add -l > /dev/null 2>&1; then
         start_agent
     fi
  else
     start_agent
  fi

  # Add keys if not already added
  if [[ -f ~/.ssh/id_ed25519.pub ]]; then
    if ! ssh-add -l | grep -q "$(ssh-keygen -lf ~/.ssh/id_ed25519.pub | awk '{print $2}')"; then
       ssh-add ~/.ssh/id_ed25519
    fi
  fi
fi

