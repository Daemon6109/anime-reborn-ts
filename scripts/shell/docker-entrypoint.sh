#!/bin/bash
set -e

# Fix ownership issues in CI environments
if [ "$(id -u)" != "$(stat -c '%u' /workspace)" ]; then
    # If we're running as a different user than owns /workspace, fix permissions
    if [ -w /workspace ]; then
        # We have write access, so we can create directories
        echo "Fixing workspace permissions for CI environment"
    else
        # We don't have write access, need to use sudo
        echo "Using sudo to fix workspace permissions"
        sudo chown -R "$(id -u):$(id -g)" /workspace || true
    fi
fi

# Ensure include directory exists and is writable
mkdir -p /workspace/include 2>/dev/null || sudo mkdir -p /workspace/include 2>/dev/null || true
chmod 755 /workspace/include 2>/dev/null || sudo chmod 755 /workspace/include 2>/dev/null || true

# Execute the command passed to the container
exec "$@"
