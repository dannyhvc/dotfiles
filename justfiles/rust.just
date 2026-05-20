default:
    @just --list rust

# Install Rust toolchain
install-rust:
    #!/usr/bin/env bash
    if ! command -v rustc &> /dev/null; then
        echo "--> Installing Rust..."
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
        source "$HOME/.cargo/env"
        rustup component add rust-analyzer
    fi

# Install cargo crates in parallel
install-cargo:
    #!/usr/bin/env bash
    source "$HOME/.cargo/env"
    { if ! command -v cargo-install-update &> /dev/null; then cargo install cargo-update; fi; } &
    { if ! command -v zoxide &> /dev/null; then cargo install zoxide --locked; fi; } &
    { if ! command -v zellij &> /dev/null; then cargo install zellij --locked; fi; } &
    { if ! command -v atuin &> /dev/null; then cargo install atuin --locked; fi; } &
    { if ! command -v just-lsp &> /dev/null; then cargo install just --locked; fi } &
    wait
    echo "--> Cargo apps installed."
