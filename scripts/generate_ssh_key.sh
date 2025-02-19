#!/bin/bash

# Path to the SSH key
SSH_KEY_PATH="$HOME/.ssh/id_rsa"

# Check if an existing key exists and remove it
if [ -f "$SSH_KEY_PATH" ]; then
    echo "[INFO] Existing SSH key found: $SSH_KEY_PATH"
    echo "[INFO] Overwriting the existing key."
    rm -f "$SSH_KEY_PATH" "$SSH_KEY_PATH.pub"
fi

# Generate a new SSH key (without passphrase)
ssh-keygen -t rsa -b 4096 -f "$SSH_KEY_PATH" -N ""

# Set correct permissions for the key files
chmod 600 "$SSH_KEY_PATH"

# Verify key creation
if [ -f "$SSH_KEY_PATH" ] && [ -f "$SSH_KEY_PATH.pub" ]; then
    echo "[SUCCESS] SSH key has been successfully generated!"
    echo "[INFO] Public key: $SSH_KEY_PATH.pub"
    echo "[INFO] Private key: $SSH_KEY_PATH"
else
    echo "[ERROR] SSH key generation failed!"
    exit 1
fi


# List of target hosts
HOSTS=("172.18.0.2" "172.18.0.3" "172.18.0.4")

# SSH username
USER="root"

# Iterate over each host and copy the SSH key
for HOST in "${HOSTS[@]}"; do
    echo "[INFO] Copying SSH key to $USER@$HOST"
    ssh-copy-id -o StrictHostKeyChecking=no "$USER@$HOST"

    if [ $? -eq 0 ]; then
        echo "[SUCCESS] SSH key copied to $USER@$HOST"
    else
        echo "[ERROR] Failed to copy SSH key to $USER@$HOST"
    fi
done
