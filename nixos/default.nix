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
      modules = builtins.attrValues inputs.self.nixosModules;
      specialArgs = {inherit inputs inputs' self';};
    });
}
