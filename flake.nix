{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixos-hardware.url = "github:nixos/nixos-hardware";

    hjem = {
      url = "github:feel-co/hjem";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nvf.url = "github:notashelf/nvf";
    niri.url = "github:sodiboo/niri-flake";

    n-i-d = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    nvf,
    ...
  } @ inputs: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      modules = [./nixos/config.nix];
      specialArgs = {inherit inputs;};
    };
    packages.x86_64-linux.default =
      (nvf.lib.neovimConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        modules = [
          ./nvf
          ({lib, ...}: let
            inherit (lib.nvim.dag) entryBefore;
          in {
            vim = {
              startPlugins = ["base16"];
              luaConfigRC.theme = entryBefore ["pluginConfigs" "lazyConfigs"] ''
                local path = vim.fn.expand("~/.cache/noctalia/neovim.lua")
                require("base16-colorscheme").setup(dofile(path))
                vim.uv.new_fs_event():start(path, {},
                  vim.schedule_wrap(function()
                    require("base16-colorscheme").setup(dofile(path))
                  end)
                )
              '';
            };
          })
        ];
      }).neovim;
  };
}
