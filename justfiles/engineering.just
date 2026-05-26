default:
    @just --list engineering

# Check system repositories for engineering tools
check-repos:
    #!/usr/bin/env bash
    if [ ! -f /etc/yum.repos.d/openfoam.com.repo ]; then
        echo "--> Enabling OpenFOAM repository..."
        sudo dnf config-manager --add-repo https://openfoam.com
    fi

# Install engineering GUI apps via DNF
install-gui-apps:
    #!/usr/bin/env bash
    echo "--> Installing heavy engineering GUIs..."
    PACKAGES=(freecad blender kicad kicad-packages3d calculix-ccx calculix-cgx openfoam elmerfem-gui elmerfem-cli curl)
    TO_INSTALL=()
    for pkg in "${PACKAGES[@]}"; do
        if ! rpm -q "$pkg" &> /dev/null; then
            TO_INSTALL+=("$pkg")
        fi
    done
    if [ ${#TO_INSTALL[@]} -gt 0 ]; then
        sudo dnf update -y
        sudo dnf install -y "${TO_INSTALL[@]}"
    fi

# Remove engineering GUI apps
reset-engineering:
    #!/usr/bin/env bash
    echo "--> Removing heavy engineering GUIs..."
    sudo dnf remove -y \
        freecad \
        blender \
        kicad \
        kicad-packages3d \
        calculix-ccx \
        calculix-cgx \
        openfoam \
        elmerfem-gui \
        elmerfem-cli \
        || true
