{
  pkgs,
  inputs,
  inputs',
  self',
  lib,
  ...
}: {
  imports = [
    ./_system.nix
    ./_niri.nix
    inputs.n-i-d.nixosModules.default
    inputs.nix-flatpak.nixosModules.nix-flatpak
  ];

  environment.etc."distrobox/distrobox.conf".text = ''
    container_additional_volumes="/nix/store:/nix/store:ro /run/current-system:/run/current-system:ro /run/wrappers:/run/wrappers:ro"
  '';
  programs = {
    localsend.enable = true;
    git.enable = true;
    nix-ld.enable = true;
    nix-index-database.comma.enable = true;
    nh = {
      enable = true;
      clean.enable = true;
    };
    steam = {
      enable = true;
      extraCompatPackages = [pkgs.proton-ge-bin];
    };
  };

  nixpkgs.config.allowUnfree = true;
  nix = {
    registry.n.flake = inputs.nixpkgs-unfree;
    channel.enable = false;
    settings = {
      auto-optimise-store = true;
      experimental-features = ["flakes" "nix-command" "pipe-operators"];
      trusted-users = ["@wheel"];
    };
  };

  users.users.cinnamon = {
    isNormalUser = true;
    extraGroups = ["wheel" "networkmanager" "input"];
    shell = self'.packages.nu;
  };
  environment.shells = [
    "/run/current-system/sw/bin/nu"
    (lib.getExe self'.packages.nu)
  ];

  services.ratbagd.enable = true;
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
  };
  environment.systemPackages = with pkgs; [
    # dev
    distrobox
    gemini-cli
    zed-editor

    uv
    gh
    lazygit

    nixd
    alejandra

    lua-language-server
    lua
    love
    # hw
    piper
    libnotify
    usbutils
    # cli
    btop
    dua
    ripgrep
    fd
    self'.packages.nu
    # web
    obsidian
    discord
    parabolic
    loupe
    qbittorrent
    inputs'.helium.packages.default
    proton-pass
  ];
  services.flatpak.enable = true;
  services.flatpak.packages = [
    "com.stremio.Stremio"
    "com.modrinth.ModrinthApp"
  ];

  system.stateVersion = "25.11";
}
