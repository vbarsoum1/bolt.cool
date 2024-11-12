#!/bin/bash

# Set up better terminal experience
echo "source /etc/bash_completion" >> ~/.bashrc
echo "export TERM=xterm-256color" >> ~/.bashrc
echo "alias ls='ls --color=auto'" >> ~/.bashrc
echo "alias ll='ls -l'" >> ~/.bashrc
echo "alias la='ls -la'" >> ~/.bashrc
echo "PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '" >> ~/.bashrc

# Create .env.local if it doesn't exist and ANTHROPIC_API_KEY is set
if [ ! -f .env.local ] && [ ! -z "$ANTHROPIC_API_KEY" ]; then
    echo "ANTHROPIC_API_KEY=$ANTHROPIC_API_KEY" > .env.local
    echo "Created .env.local file with API key"
fi

# Original bindings script
bindings=""
while IFS= read -r line || [ -n "$line" ]; do
    if [[ ! "$line" =~ ^# ]] && [[ -n "$line" ]]; then
        name=$(echo "$line" | cut -d '=' -f 1)
        value=$(echo "$line" | cut -d '=' -f 2-)
        value=$(echo $value | sed 's/^"\(.*\)"$/\1/')
        bindings+="--binding ${name}=${value} "
    fi
done < .env.local
bindings=$(echo $bindings | sed 's/[[:space:]]*$//')

# Source the new bashrc settings
source ~/.bashrc

echo $bindings
