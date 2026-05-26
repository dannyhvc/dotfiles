# Run complete system bootstrap
mod symlinks "justfiles/symlinks.just"
mod system "justfiles/system.just"
mod rust "justfiles/rust.just"
mod engineering "justfiles/engineering.just"

default:
    @just --list

# Run complete system bootstrap
setup-all:
    just symlinks link-dots
    just system install-core-dnf
    just system install-nix-userland
    just rust install-rust
    just system install-browser
    just system set-defaults
    just engineering check-repos
    just engineering install-gui-apps
    @echo "============================================="
    @echo " System fully configured via DNF & Nix."
    @echo "============================================="

# Completely reset and uninstall everything added by this script
reset-all:
    @echo "============================================="
    @echo " WARNING: Starting full system reset..."
    @echo "============================================="
    just symlinks reset-symlinks
    just rust reset-rust
    just engineering reset-engineering
    just system reset-system
    @echo "============================================="
    @echo " System reset complete. Back to baseline."
    @echo "============================================="
