{
  nixConfig = {
    extra-substituters = ["https://noctalia.cachix.org" "https://niri.cachix.org" "https://jump1n.cachix.org" "https://lanzaboote.cachix.org" "https://finix.cachix.org"];
    extra-trusted-public-keys = [
      "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
      "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="
      "jump1n.cachix.org-1:duG5cdEwJOCp/NJJ18hSOk+0NPWEDcjeGA1/fv7WlLA="
      "lanzaboote.cachix.org-1:Nt9//zGmqkg1k5iu+B3bkj3OmHKjSw9pvf3faffLLNk="
      "finix.cachix.org-1:0ejikHDeCp0UErsduUUHcg9IJczY2/h2e5132Z/As/c="
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
    finix.url = "github:finix-community/finix";

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
    slssteam = {
      url = "https://github.com/AceSLS/SLSsteam/releases/download/20261014151919/SLSsteam-Any-release.7z";
      flake = false;
    };
    localsend-nautilus = {
      url = "github:damiansan239/localsend-nautilus-extension";
      flake = false;
    };
    prism = {
      url = "github:diegiwg/prismlauncher-cracked";
      inputs.nixpkgs.follows = "nixpkgs";
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
