# Run complete system bootstrap
mod symlinks "justfiles/symlinks.just"
mod system "justfiles/system.just"
mod rust "justfiles/rust.just"
mod engineering "justfiles/engineering.just"
mod ide "justfiles/ide.just"

default:
    @just --list

# Run complete system bootstrap
setup-all:
    just symlinks link-dots
    just system setup-repos
    just system install-core
    just system install-browser
    just rust install-rust
    just rust install-cargo
    just system set-defaults
    just system check-repos
    just system install-apps
    just engineering install-uv
    just ide setup-workspace
    @echo "============================================="
    @echo " System fully configured."
    @echo "============================================="
