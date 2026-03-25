{
  description = "A very basic flake";
  nixConfig = {
    extra-substituters = ["https://noctalia.cachix.org"];
    extra-trusted-public-keys = ["noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="];
  };
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixos-hardware.url = "github:nixos/nixos-hardware";

    wrappers = {
      url = "github:birdeehub/nix-wrapper-modules";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    niri.url = "github:sodiboo/niri-flake";
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      # inputs.nixpkgs.follows = "nixpkgs";
      # inputs.noctalia-qs.inputs.nixpkgs.follows = "nixpkgs";
    };

    n-i-d = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";
  };

  outputs = {nixpkgs, ...} @ inputs: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      modules = [./nixos/config.nix];
      specialArgs = {inherit inputs;};
    };
  };
}
