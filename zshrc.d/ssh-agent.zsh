#!/bin/bash
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
if ! ssh-add -l | grep -q "$(ssh-keygen -lf ~/.ssh/id_ed25519.pub | awk '{print $2}')"; then
   ssh-add ~/.ssh/id_ed25519
fi

