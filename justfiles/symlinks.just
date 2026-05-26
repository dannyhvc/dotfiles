default:
    @just --list symlinks

# Link all dotfiles safely
link-dots:
    #!/usr/bin/env bash
    @echo "--> Linking dotfiles..."
    ln -sfn ~/dotfiles/alacritty ~/.config/alacritty
    ln -sfn ~/dotfiles/atuin ~/.config/atuin
    ln -sfn ~/dotfiles/gh ~/.config/gh
    ln -sfn ~/dotfiles/helix ~/.config/helix
    ln -sfn ~/dotfiles/niri ~/.config/niri
    ln -sfn ~/dotfiles/nushell ~/.config/nushell
    ln -sfn ~/dotfiles/zellij ~/.config/zellij
    ln -sfn ~/dotfiles/starship/starship.toml ~/.config/starship.toml
    ln -sfn ~/dotfiles/zoxide/init.nu ~/.zoxide.nu
    @echo "--> Symlinks updated."

# Remove dotfile symlinks
reset-symlinks:
    #!/usr/bin/env bash
    @echo "--> Removing dotfile symlinks..."
    rm -f ~/.config/alacritty \
          ~/.config/atuin \
          ~/.config/gh \
          ~/.config/helix \
          ~/.config/niri \
          ~/.config/nushell \
          ~/.config/zellij \
          ~/.config/starship.toml \
          ~/.zoxide.nu
