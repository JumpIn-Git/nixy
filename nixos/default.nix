{
  inputs,
  self,
  withSystem,
  ...
}: {
  flake.nixosConfigurations.nixos = withSystem "x86_64-linux" ({
    inputs',
    self',
    ...
  }:
    inputs.nixpkgs.lib.nixosSystem {
      modules =
        builtins.attrValues inputs.self.nixosModules
        ++ [
          ({lib, ...}: {
            nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
          })
        ];
      specialArgs = {inherit inputs inputs' self';};
    });
  flake.nixosConfigurations.finix = withSystem "x86_64-linux" ({
    inputs',
    self',
    ...
  }: let
    pkgs = import inputs.nixpkgs {
      system = "x86_64-linux";
      config = {
        allowUnfree = true;
      };
    };
  in
    inputs.finix.lib.finixSystem {
      inherit (pkgs) lib;
      specialArgs = {
        inherit inputs inputs' self';
        modulesPath = inputs.nixpkgs + /nixos/modules;
      };
      modules = [
        {nixpkgs.pkgs = pkgs;}
        self.finixModules.default
      ];
    });
}
