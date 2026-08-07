{
  nixConfig = {
    extra-substituters = ["https://noctalia.cachix.org" "https://niri.cachix.org" "https://jump1n.cachix.org" "https://lanzaboote.cachix.org"];
    extra-trusted-public-keys = [
      "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
      "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="
      "jump1n.cachix.org-1:duG5cdEwJOCp/NJJ18hSOk+0NPWEDcjeGA1/fv7WlLA="
      "lanzaboote.cachix.org-1:Nt9//zGmqkg1k5iu+B3bkj3OmHKjSw9pvf3faffLLNk="
    ];
    extra-experimental-features = ["nix-command" "flakes" "pipe-operators"];
  };
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixpkgs-unfree = {
      url = "github:numtide/nixpkgs-unfree";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:nixos/nixos-hardware";
    n-i-d = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-flatpak.url = "github:gmodena/nix-flatpak?ref=latest";
    lanzaboote.url = "github:nix-community/lanzaboote/v1.1.0";

    parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    wrappers = {
      url = "github:birdeehub/nix-wrapper-modules";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia.url = "github:noctalia-dev/noctalia-shell";
    helium = {
      url = "github:greyxp1/helium-flake";
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
          && f.name != "flake.nix"
          && !hasPrefix "_" f.name)
        ./.
        |> fileset.toList;
    };
}
