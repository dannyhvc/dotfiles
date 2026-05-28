{ config, pkgs, ... }:

{
  home.username    = "dannyhvc";
  home.homeDirectory = "/home/dannyhvc";
  home.stateVersion  = "25.05";

  programs.home-manager.enable = true;

  # ─── Dotfiles symlinks ────────────────────────────────────────────────────
  # mkOutOfStoreSymlink means changes to ~/dotfiles are live immediately
  home.file = {
    ".config/alacritty".source  = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/alacritty";
    ".config/helix".source      = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/helix";
    ".config/niri".source       = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/niri";
    ".config/nushell".source    = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/nushell";
    ".config/zellij".source     = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/zellij";
    ".config/atuin".source      = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/atuin";
    ".config/gh".source         = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/gh";
    ".config/starship.toml".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/starship/starship.toml";
    ".config/lazygit".source    = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/lazygit";
    ".config/yazi".source       = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/yazi";
  };

  # ─── User packages ────────────────────────────────────────────────────────
  home.packages = with pkgs; [
    alacritty
    zellij
    nushell

    # Shell tooling
    starship
    zoxide
    atuin

    # Search / nav
    fd
    ripgrep
    fzf
    yazi

    # Git
    lazygit
    gh
    jujutsu           # jj
    difftastic

    # JSON / data
    jq
    bat

    # Build / task
    just
    ast-grep

    # Python
    uv
    ty
    ruff

    # Nix LSP
    nil

    # Rust
    rustup

    # Editor
    helix

    # Node
    nodejs_22
    pnpm

    # DB
    dbeaver-bin

    # Extra dev tools
    perl
    bottom

    # apps
    kicad
    freecad
    librecad
    libreoffice
    ltspice
  ];

  # ─── Env vars ─────────────────────────────────────────────────────────────
  home.sessionVariables = {
    EDITOR  = "hx";
    VISUAL  = "hx";
    TERMINAL = "alacritty";
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
    NIXOS_OZONE_WL = "1";
  };

  # ─── PATH additions ───────────────────────────────────────────────────────
  home.sessionPath = [
    "$HOME/.cargo/bin"
    "$HOME/.local/bin"
  ];
}
