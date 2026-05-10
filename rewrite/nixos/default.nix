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
      modules = [
        ./_config.nix
      ];
      specialArgs = {inherit inputs inputs' self';};
    });
}
