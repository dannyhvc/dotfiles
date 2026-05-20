default:
    @just --list system
 
# Setup COPR and RPM Fusion
setup-repos:
    #!/usr/bin/env bash
    if [ ! -f /etc/yum.repos.d/_copr:copr.fedorainfracloud.org:lihaohong:yazi.repo ]; then
        echo "--> Enabling Yazi COPR..."
        sudo dnf copr enable -y lihaohong/yazi
    fi
    if [ ! -f /etc/yum.repos.d/ ]; then
        echo "--> Enabling Starship COPR..."
        sudo dnf copr enable -y atim/starship
    fi

    if [! -f /etc/yum.repos.d/_copr:copr.fedorainfracloud.org:atim:lazygit.repo]; then
        echo "--> Enabling lazygit COPR"
        sudo dnf copr enable atim/lazygit -y
    fi
    # if ! rpm -q rpmfusion-free-release &> /dev/null; then
    #     echo "--> Installing RPM Fusion..."
    #     sudo dnf install -y \
    #         https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
    #         https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
    # fi

# Install core CLI tools
install-core:
    #!/usr/bin/env bash
    PACKAGES=(
        fd-find
        ripgrep
        yazi
        ffmpeg
        ImageMagick
        fzf
        xclip
        zoxide
        jq
        wl-clipboard
        starship
        nu
        hx
        perl-FindBin
        perl-core
        openssl-devel
        pkg-config
        fuzzel
        lazygit
        bat
        difftastic
        p7zip
        p7zip-plugins   
        @c-development
        @development-tools   
        cmake
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

# Install Brave
install-browser:
    #!/usr/bin/env bash
    if ! command -v brave-browser &> /dev/null; then
        echo "--> Installing Brave..."
        curl -fsS https://dl.brave.com/install.sh | sh
    fi

# Set default browser and shell
set-defaults:
    #!/usr/bin/env bash
    if command -v xdg-settings &> /dev/null; then
        xdg-settings set default-web-browser brave-browser.desktop
    fi
    NU_PATH=$(which nu 2>/dev/null || echo "")
    if [ -n "$NU_PATH" ] && [ "$(getent passwd "$USER" | cut -d: -f7)" != "$NU_PATH" ]; then
        sudo chsh -s "$NU_PATH" "$USER"
    fi
