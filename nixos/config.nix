{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./system.nix
    ./niri.nix
    inputs.n-i-d.nixosModules.default
    inputs.nix-flatpak.nixosModules.nix-flatpak
  ];

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
    shell = pkgs.nushell;
  };

  nixpkgs.config.allowUnfree = true;
  nix = {
    channel.enable = false;
    settings = {
      auto-optimise-store = true;
      experimental-features = ["flakes" "nix-command" "pipe-operators"];
      trusted-users = ["@wheel"];
    };
  };

  services.ratbagd.enable = true;
  environment.systemPackages = with pkgs; [
    # dev
    uv
    nixd
    alejandra
    lua-language-server
    love
    gh
    zed-editor

    # hw
    piper
    libnotify
    usbutils
    evtest

    # cli
    btop
    ripgrep
    fd
    nushell

    # web
    discord
    qbittorrent
    inputs.zen-browser.packages.${system}.default
    proton-pass
  ];
  services.flatpak.enable = true;
  services.flatpak.packages = ["com.stremio.Stremio"];

  system.stateVersion = "25.11";
}
