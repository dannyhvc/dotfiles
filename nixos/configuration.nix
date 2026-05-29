# RUN:
# sudo nixos-rebuild switch --flake /etc/nixos#nixos --option substituters "https://cache.nixos.org https://niri.cachix.org" --option require-sigs false
# to build nixos generation
{
  config,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    inputs.dms.nixosModules.dank-material-shell
  ];
  # ─── Boot 
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # ─── Networking 
  networking.hostName = "nixos"; # change if you want
  networking.networkmanager.enable = true;

  # ─── Locale 
  time.timeZone = "America/Toronto";
  i18n.defaultLocale = "en_US.UTF-8";

  # ─── Niri session (via niri-flake)
  programs.niri = {
    enable = true;
    package = inputs.niri.packages.${pkgs.system}.niri-unstable;
  };
  programs.dank-material-shell.enable = true;

  # ─── Display manager
  services.greetd = {
    enable = true;
    settings.default_session = {
      command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --cmd niri-session";
      user = "greeter";
    };
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # ─── XDG portals
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    config.common.default = "*";
  };

  # ─── PipeWire audio 
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # ─── Bluetooth
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # ─── Fonts
  fonts = {
    packages = with pkgs; [
      nerd-fonts.hack
      inter
      fira-code
      noto-fonts
      noto-fonts-color-emoji
    ];
    fontconfig.defaultFonts = {
      sansSerif = [ "Inter" ];
      monospace = [
        "Hack Nerd Font"
        "Fira Code"
      ];
      emoji = [ "Noto Color Emoji" ];
    };
  };

  # ─── System packages
  programs.dconf.enable = true;
  environment.systemPackages = with pkgs; [
    adwaita-icon-theme # application icons
    alacritty
    bibata-cursors
    blueman
    brave # browser
    brightnessctl
    cacert
    clang
    clang-tools
    cmake
    curl
    devenv
    ffmpeg
    foot # backup terminal
    fuzzel
    gcc
    git
    gnumake
    grim
    imagemagick
    mako # A superb, minimal notification daemon tailored for Wayland
    nautilus # gui file manager
    networkmanagerapplet
    nushell
    nushell
    openssl
    p7zip
    papirus-icon-theme # application icons
    pavucontrol
    pkg-config
    podman
    polkit_gnome
    slurp
    vim
    wget
    wl-clipboard
    xdg-utils
    xwayland-satellite
    zellij
  ];

  # ─── User
  users.users.dannyhvc = {
    isNormalUser = true;
    description = "Dan";
    extraGroups = [
      "wheel"
      "networkmanager"
      "audio"
      "video"
      "input"
    ];
    shell = pkgs.bash;
  };

  # ─── Nix settings
  nixpkgs.config.allowUnfree = true;

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    auto-optimise-store = true;

    # Pre-compiled binaries to bypass crates.io compilation times
    substituters = [
      "https://cache.nixos.org"
      "https://niri.cachix.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "niri.cachix.org-1:WvSGALzHlAUa526ImCEIVKcv4HgD0N0421U0NlO9y08="
    ];
  };

  # ─── Misc
  # Enable the password vault daemon
  services.gnome.gnome-keyring.enable = true;

  # Unlock the keyring automatically on login via greetd
  security.pam.services.greetd.enableGnomeKeyring = true;

  # Enable trash, mounting, and filesystem backends
  services.gvfs.enable = true;
  services.udisks2.enable = true;

  # Enable peripheral firmware updates
  services.fwupd.enable = true;

  # Linux thermal daemon to prevent overheating
  services.thermald.enable = true;

  # Enables battery percentage indicator
  services.upower.enable = true;

  # Enable the fprintd service
  services.fprintd.enable = true;

  # # Only add these if the default driver fails to detect your scanner
  # services.fprintd.tod.enable = true;
  # services.fprintd.tod.driver = pkgs.libfprint-2-tod1-goodix;

  services.dbus.enable = true;

  # Enable fingerprint support for terminal sudo commands
  security.pam.services.sudo.fprintAuth = true;

  # Enable fingerprint support for graphical privilege escalation
  security.pam.services.polkit-1.fprintAuth = true;

  # If you use a display manager like GDM or SDDM, you can also enable it there:
  # security.pam.services.gdm.fprintAuth = true;
  
  security.polkit.enable = true;
  system.stateVersion = "25.05";
}
