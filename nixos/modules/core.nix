{
  flake.nixosModules.core = {
    inputs,
    pkgs,
    lib,
    ...
  }: {
    imports = [inputs.n-i-d.nixosModules.default];
    nixpkgs.config.allowUnfree = true;
    nix = {
      registry.n.flake = inputs.nixpkgs-unfree;
      channel.enable = false;
      settings =
        let cfg = (import ../../flake.nix).nixConfig;
        in {
          auto-optimise-store = true;
          trusted-users = ["@wheel"];
          inherit (cfg) extra-experimental-features;
          substituters = cfg.extra-substituters;
          trusted-public-keys = cfg.extra-trusted-public-keys;
        };
    };
    programs.git.enable = true;
    programs = {
      nix-ld.enable = true;
      nix-index-database.comma.enable = true;
      nh = {
        enable = true;
        clean.enable = true;
      };
    };

    environment.systemPackages = with pkgs; [
      btop
      dua
      ripgrep
      fd
      undollar
      usbutils
    ];

    networking.hostName = "nixos"; # Define your hostname.
    networking.networkmanager.enable = true;

    boot.loader.efi.canTouchEfiVariables = true;
    boot.loader.systemd-boot.enable = lib.mkForce false; # lanzaboot

    time.timeZone = "Europe/Amsterdam";
    i18n.defaultLocale = "en_US.UTF-8";
    i18n.extraLocaleSettings = {
      LC_ADDRESS = "nl_NL.UTF-8";
      LC_IDENTIFICATION = "nl_NL.UTF-8";
      LC_MEASUREMENT = "nl_NL.UTF-8";
      LC_MONETARY = "nl_NL.UTF-8";
      LC_NAME = "nl_NL.UTF-8";
      LC_NUMERIC = "nl_NL.UTF-8";
      LC_PAPER = "nl_NL.UTF-8";
      LC_TELEPHONE = "nl_NL.UTF-8";
      LC_TIME = "nl_NL.UTF-8";
    };
  };
}
