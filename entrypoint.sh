#!/bin/bash

# Generate server SSH keys if they do not exist
ssh-keygen -A

# Set correct permissions on server SSH keys
chmod 600 /etc/ssh/ssh_host_*_key
chmod 644 /etc/ssh/ssh_host_*_key.pub
chown root:root /etc/ssh/ssh_host_*

# Set up SSH key for root if provided
if [ -n "$ROOT_SSH_KEY" ]; then
    mkdir -p /root/.ssh
    echo "$ROOT_SSH_KEY" > /root/.ssh/authorized_keys
    chmod 600 /root/.ssh/authorized_keys
    chmod 700 /root/.ssh
fi

# Configure Git user.name and user.email if provided
if [ -n "$GIT_USER_NAME" ]; then
    git config --global user.name "$GIT_USER_NAME"
fi
if [ -n "$GIT_USER_EMAIL" ]; then
    git config --global user.email "$GIT_USER_EMAIL"
fi

touch /root/.Xauthority
chown root:root /root/.Xauthority

# Start the SSH server
service ssh start

# Keep the container running
tail -f /dev/null

