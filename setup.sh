#!/usr/bin/env bash
set -e

# Ensure just is installed
if ! command -v just &> /dev/null; then
    echo "--> Installing 'just' runner via DNF..."
    sudo dnf install -y just
else
    echo "--> 'just' runner is already installed."
fi

# Execute the complete configuration pipeline
just setup-all
