{
  nixConfig = {
    extra-substituters = ["https://noctalia.cachix.org"];
    extra-trusted-public-keys = ["noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="];
  };
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixpkgs-unfree = {
      url = "github:numtide/nixpkgs-unfree";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:nixos/nixos-hardware";

    wrappers = {
      url = "github:birdeehub/nix-wrapper-modules";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    niri.url = "github:sodiboo/niri-flake";
    noctalia.url = "github:noctalia-dev/noctalia-shell";

    n-i-d = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    helium = {
      url = "github:schembriaiden/helium-browser-nix-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";
  };

  outputs = {
    nixpkgs,
    wrappers,
    ...
  } @ inputs: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      modules = [./nixos/config.nix];
      specialArgs = {inherit inputs;};
    };
    packages.x86_64-linux.accela = import ./pkgs/accela.nix {pkgs = nixpkgs.legacyPackages.x86_64-linux;};
    packages.x86_64-linux.niri-ocr = import ./pkgs/niri-ocr nixpkgs.legacyPackages.x86_64-linux;
    wrappers.wlr-which-key = wrappers.lib.wrapModule (
      {
        config,
        pkgs,
        lib,
        ...
      }: let
        yamlFormat = pkgs.formats.yaml {};
      in {
        options = {
          settings = lib.mkOption {
            type = yamlFormat.type;
          };
        };

        config = {
          package = lib.mkDefault pkgs.wlr-which-key;

          addFlag = [(yamlFormat.generate "config.yaml" config.settings)];
        };
      }
    );
  };
}
