{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./system.nix
    ./niri.nix
    inputs.n-i-d.nixosModules.default
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
      extraCompatPackages = with pkgs; [proton-ge-bin];
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
    nil #testing
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
    # stremio-linux-shell
  ];

  system.stateVersion = "25.11";
}
