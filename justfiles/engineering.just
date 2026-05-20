default:
    @just --list engineering

# Check system repositories for engineering tools
check-repos:
    #!/usr/bin/env bash
    if [ ! -f /etc/yum.repos.d/openfoam.com.repo ]; then
        sudo dnf config-manager --add-repo https://openfoam.com
    fi

# Install engineering GUI apps via DNF
install-apps:
    #!/usr/bin/env bash
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

# Install uv execution engine
install-uv:
    #!/usr/bin/env bash
    if ! command -v uv &> /dev/null; then
        curl -LsSf https://astral.sh/uv/install.sh | sh
    fi

# Initialize Python execution sandboxes
setup-workspace:
    #!/usr/bin/env bash
    mkdir -p ~/engineering_workspace
    export PATH="$HOME/.local/bin:$PATH"
    cd ~/engineering_workspace
    if [ ! -f pyproject.toml ]; then
        uv init --no-readme
    fi
    uv add numpy scipy matplotlib ngspice

# Nuke the engineering workspace and remove uv
reset-engineering:
    #!/usr/bin/env bash
    rm -rf ~/engineering_workspace
    rm -f ~/.local/bin/uv
    echo "--> Engineering environment reset complete."
