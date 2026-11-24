{
  nixConfig = {
    extra-substituters = ["https://noctalia.cachix.org" "https://jump1n.cachix.org"];
    extra-trusted-public-keys = [
      "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
      "jump1n.cachix.org-1:duG5cdEwJOCp/NJJ18hSOk+0NPWEDcjeGA1/fv7WlLA="
    ];
    extra-experimental-features = ["nix-command" "flakes" "pipe-operators"];
  };
  inputs = {
    nixpkgs.url = "https://channels.nixos.org/nixos-unstable/nixexprs.tar.zst";
    nixpkgs-unfree = {
      url = "github:numtide/nixpkgs-unfree";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    noctalia.url = "github:nixos/nixpkgs/8edc0c72e3a38faf5434e40d1f19431125fe4b30";
    nixpkgs-stremio.url = "github:nixos/nixpkgs/66d9241e3dc2296726dc522e62dbfe89c7b449f3"; # legacy stremio in cachix, use at your own risk

    nixos-hardware = {
      url = "github:nixos/nixos-hardware";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    n-i-d = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    wrappers = {
      url = "github:birdeehub/nix-wrapper-modules";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    rikka.url = "github:project-rikka/packages";
    helium = {
      url = "github:greyxp1/helium-flake";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "parts";
      };
    };
    monique = {
      url = "github:ToRvaLDz/monique";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    localsend-nautilus = {
      url = "github:damiansan239/localsend-nautilus-extension";
      flake = false;
    };
    mpris-bridge = {
      url = "github:thedoctorttv/mpris-bridge";
      flake = false;
    };
  };

  outputs = {
    parts,
    nixpkgs,
    ...
  } @ inputs:
    parts.lib.mkFlake {inherit inputs;} {
      imports = with nixpkgs.lib;
        fileset.fileFilter (f:
          f.hasExt "nix"
          && !hasPrefix "_" f.name
          && f.name != "flake.nix")
        ./.
        |> fileset.toList;
    };
}
