#!/usr/bin/env bash
set -e

echo "============================================="
echo " Starting Fedora + Nix System Bootstrap"
echo "============================================="

# Update Fedora base system first to ensure latest SELinux policies
echo "--> Updating Fedora core..."
sudo dnf upgrade --refresh -y

# Install Nix using the Determinate Systems Installer
# This automatically handles Fedora's SELinux (Enforced) and enables Flakes
if ! command -v nix &> /dev/null; then
    echo "--> Installing Nix (with SELinux support)..."
    curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install --no-confirm
    
    # Source the Nix environment so it's available in this script immediately
    . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
else
    echo "--> Nix is already installed."
fi

# Install 'just' via Nix so we can run the rest of the setup
if ! command -v just &> /dev/null; then
    echo "--> Installing 'just' via Nix..."
    nix profile add nixpkgs#just
fi

# Hand over control to the Justfile
echo "--> Handing over to Justfile..."
just setup-all

echo "============================================="
echo " Bootstrap complete! Please restart your terminal."
echo "============================================="
