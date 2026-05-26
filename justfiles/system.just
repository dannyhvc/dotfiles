default:
    @just --list system

# Install system-level GUI apps, compilers, and drivers via DNF
install-core-dnf:
    #!/usr/bin/env bash
    echo "--> Installing core system dependencies via DNF..."
    PACKAGES=(
        ffmpeg
        ImageMagick
        wl-clipboard
        perl-FindBin
        perl-core
        openssl-devel
        pkg-config
        fuzzel
        p7zip
        p7zip-plugins   
        cmake
        clang-tools-extra
        @c-development
        @development-tools   
    )
    TO_INSTALL=()
    for pkg in "${PACKAGES[@]}"; do
        if ! rpm -q "$pkg" &> /dev/null; then
            TO_INSTALL+=("$pkg")
        fi
    done
    if [ ${#TO_INSTALL[@]} -gt 0 ]; then
        sudo dnf install -y "${TO_INSTALL[@]}"
    fi

# Install all CLI tools and user environments instantly via Nix
install-nix-userland:
    #!/usr/bin/env bash
    echo "--> Installing terminal userland via Nix..."
    nix profile install \
        nixpkgs#fd \
        nixpkgs#ripgrep \
        nixpkgs#yazi \
        nixpkgs#fzf \
        nixpkgs#zoxide \
        nixpkgs#jq \
        nixpkgs#starship \
        nixpkgs#nushell \
        nixpkgs#helix \
        nixpkgs#lazygit \
        nixpkgs#bat \
        nixpkgs#difftastic \
        nixpkgs#zellij \
        nixpkgs#atuin \
        nixpkgs#jujutsu \
        nixpkgs#ast-grep \
        nixpkgs#just \
        nixpkgs#uv \
        nixpkgs#nil

# Install Brave Browser
install-browser:
    #!/usr/bin/env bash
    if ! command -v brave-browser &> /dev/null; then
        echo "--> Installing Brave..."
        curl -fsS https://dl.brave.com/install.sh | sh
    fi

# Set default browser and add Nix-installed Nushell to system shells
set-defaults:
    #!/usr/bin/env bash
    if command -v xdg-settings &> /dev/null; then
        xdg-settings set default-web-browser brave-browser.desktop
    fi

    NU_PATH="$HOME/.nix-profile/bin/nu"
    if [ -x "$NU_PATH" ]; then
        # Fedora requires the shell to be in /etc/shells before chsh will accept it
        if ! grep -q "$NU_PATH" /etc/shells; then
            echo "--> Adding Nushell to /etc/shells..."
            echo "$NU_PATH" | sudo tee -a /etc/shells
        fi

        if [ "$(getent passwd "$USER" | cut -d: -f7)" != "$NU_PATH" ]; then
            echo "--> Changing default shell to Nushell..."
            sudo chsh -s "$NU_PATH" "$USER"
        fi
    fi

# Reset all system changes, uninstall packages, and revert shell
reset-system:
    #!/usr/bin/env bash
    echo "--> 1. Reverting default shell to bash (CRITICAL FAILSAFE)..."
    if [ "$(getent passwd "$USER" | cut -d: -f7)" != "/bin/bash" ]; then
        sudo chsh -s /bin/bash "$USER" || true
    fi

    echo "--> 2. Removing Nix terminal userland..."
    if command -v nix &> /dev/null; then
        # Removes all packages from the user profile
        nix profile remove '.*' || true
        # Cleans out the Nix store to free up space
        nix-collect-garbage -d || true
    fi

    echo "--> 3. Removing core DNF packages..."
    sudo dnf remove -y \
        ffmpeg \
        ImageMagick \
        wl-clipboard \
        perl-FindBin \
        perl-core \
        openssl-devel \
        pkg-config \
        fuzzel \
        p7zip \
        p7zip-plugins \
        cmake \
        clang-tools-extra \
        || true
