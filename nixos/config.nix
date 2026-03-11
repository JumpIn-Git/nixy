{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./system.nix
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
    nixd
    alejandra
    love
    gh
    zed-editor

    piper
    libnotify
    usbutils

    btop
    ripgrep
    fd
    nushell

    discord
    inputs.zen-browser.packages.${system}.default
    # stremio
  ];

  system.stateVersion = "25.11";
}
