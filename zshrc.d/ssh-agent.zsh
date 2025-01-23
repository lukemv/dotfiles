#!/bin/bash
AGENT_ENV="$HOME/.ssh/agent.env"

# Start agent if not already running
start_agent() {
   (umask 077; ssh-agent > "$AGENT_ENV")
   . "$AGENT_ENV" > /dev/null
}

# Check if the agent is already running
if [ -f "$AGENT_ENV" ]; then
   . "$AGENT_ENV" > /dev/null
   # Check if agent is dead and start it again if needed
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

