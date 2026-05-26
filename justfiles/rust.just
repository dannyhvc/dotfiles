default:
    @just --list rust

# Install Rust toolchain via official script
install-rust:
    #!/usr/bin/env bash
    if ! command -v rustc &> /dev/null; then
        echo "--> Installing Rust..."
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
        source "$HOME/.cargo/env"
        rustup component add rust-analyzer
    fi

# Uninstall Rust toolchain completely
reset-rust:
    #!/usr/bin/env bash
    if command -v rustup &> /dev/null; then
        echo "--> Uninstalling Rust toolchain..."
        rustup self uninstall -y
    fi
