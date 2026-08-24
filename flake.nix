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
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixpkgs-unfree = {
      url = "github:numtide/nixpkgs-unfree";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # legacy stremio in cachix, this version is unsafe, use at your own risk
    nixpkgs-stremio.url = "github:nixos/nixpkgs/66d9241e3dc2296726dc522e62dbfe89c7b449f3";
    finix.url = "github:finix-community/finix";
    community-modules.url = "github:finix-community/community-modules";

    nixos-hardware.url = "github:nixos/nixos-hardware";
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
      inputs.nixpkgs.follows = "nixpkgs";
    };
    monique = {
      url = "github:ToRvaLDz/monique";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    umbriel = {
      url = "git+https://github.com/noctalia-dev/umbriel?rev=dd8b3565f9a776c9d7686fa879852c271542a53b";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    xdg-desktop-portal-umbriel = {
      url = "github:noctalia-dev/xdg-desktop-portal-umbriel?rev=c8a9a223d48e6c62652f3f3cfaaa0f50aca39146";
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
