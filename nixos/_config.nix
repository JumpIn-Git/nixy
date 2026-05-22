{
  pkgs,
  inputs,
  self',
  lib,
  ...
}: {
  imports = [
    ./_system.nix
    inputs.self.nixosModules.niri
    inputs.self.nixosModules.desktop
    inputs.n-i-d.nixosModules.default
    inputs.nix-flatpak.nixosModules.nix-flatpak
  ];

  environment.etc."distrobox/distrobox.conf".text = ''
    container_additional_volumes="/nix/store:/nix/store:ro /run/current-system:/run/current-system:ro /run/wrappers:/run/wrappers:ro"
  '';
  programs = {
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
    uv
    gh

    lazygit
    gemini-cli
    zed-editor

    nixd
    alejandra
    lua-language-server
    lua
    love
    qemu
    go
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
  ];
  services.flatpak.enable = true;
  services.flatpak.packages = [
    "com.stremio.Stremio"
    "com.modrinth.ModrinthApp"
  ];

  system.stateVersion = "25.11";
}
