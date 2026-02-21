{
  pkgs,
  inputs,
  lib,
  ...
}: {
  imports = [
    ./system.nix
    ./nvf.nix
    ./niri.nix
    inputs.n-i-d.nixosModules.default
    # inputs.hjem.nixosModules.default
  ];
  # hjem.users.cinnamon.files.foo.source = pkgs.runCommandLocal "foo" {} "ln -s ${lib.escapeShellArg /home/cinnamon/nix/foo} $out";
  # Works! Also with dirs

  programs = {
    git.enable = true;
    nix-ld.enable = true;
    nix-index-database.comma.enable = true;
    firefox.enable = true;
    nh = {
      enable = true;
      clean.enable = true;
    };
    steam = {
      enable = true;
      extraCompatPackages = with pkgs; [
        proton-ge-bin
      ];
    };
  };

  users.users.cinnamon = {
    isNormalUser = true;
    extraGroups = ["wheel" "networkmanager"];
    shell = pkgs.nushell;
    packages = with pkgs; [
      zed-editor
      nushell
      discord
      # stremio

      ripgrep
      fd
      btop
    ];
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
    piper
    nixd
    alejandra
    libnotify
    usbutils
    gh
  ];

  system.stateVersion = "25.11";
}
