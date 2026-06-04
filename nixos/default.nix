{
  inputs,
  withSystem,
  ...
}: {
  flake.nixosConfigurations.nixos = withSystem "x86_64-linux" ({
    inputs',
    self',
    ...
  }:
    inputs.nixpkgs.lib.nixosSystem {
      modules = [./_system.nix] ++ builtins.attrValues inputs.self.nixosModules;
      specialArgs = {inherit inputs inputs' self';};
    });
}
