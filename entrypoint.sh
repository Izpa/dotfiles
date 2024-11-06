#!/bin/bash

# Set up SSH key for root if provided
if [ -n "$ROOT_SSH_KEY" ]; then
    mkdir -p /root/.ssh
    echo "$ROOT_SSH_KEY" > /root/.ssh/authorized_keys
    chmod 600 /root/.ssh/authorized_keys
    chmod 700 /root/.ssh
fi

# Ensure SSH is configured to use the correct authorized_keys file and allow public key authentication
echo "AuthorizedKeysFile .ssh/authorized_keys" >> /etc/ssh/sshd_config
echo "PubkeyAuthentication yes" >> /etc/ssh/sshd_config

# Start the SSH server
service ssh start

# Keep the container running
tail -f /dev/null

