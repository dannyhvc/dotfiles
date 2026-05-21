default:
    @just --list ide

ide-install: uv-install uv-tools

uv-install:
    #!/usr/bin/env bash
    curl -LsSf https://astral.sh/uv/install.sh | sh

uv-tools:
    curl -LsSf https://astral.sh/uv/install.sh | sh
