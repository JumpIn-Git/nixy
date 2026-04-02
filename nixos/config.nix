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
    inputs.nixos-cli.nixosModules.nixos-cli
  ];
  programs.nixos-cli = {
    enable = true;
    settings = {
      apply.use_nom = true;
      apply.reexec_as_root = true;
      differ.command = ["nvf" "diff"];
      config_location = "/home/cinnamon/nix";
    };
  };

  environment.etc."distrobox/distrobox.conf".text = ''
    container_additional_volumes="/nix/store:/nix/store:ro /etc/profiles/per-user:/etc/profiles/per-user:ro /etc/static/profiles/per-user:/etc/static/profiles/per-user:ro"
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
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
  };
  environment.systemPackages = with pkgs; [
    nvd
    nix-output-monitor
    # dev
    distrobox
    uv

    nixd
    alejandra

    lua-language-server
    love

    gh
    zed-editor
    gemini-cli
    evil-helix

    # hw
    piper
    libnotify
    usbutils

    # cli
    btop
    ripgrep
    fd
    nushell

    # web
    discord
    loupe
    qbittorrent
    inputs.zen-browser.packages.${system}.default
    proton-pass
  ];
  services.flatpak.enable = true;
  services.flatpak.packages = [
    "com.stremio.Stremio"
    "com.modrinth.ModrinthApp"
  ];

  system.stateVersion = "25.11";
}
