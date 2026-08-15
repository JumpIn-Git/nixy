{
  inputs,
  withSystem,
  self,
  ...
}: {
  flake.nixosModules.finix = {
    pkgs,
    lib,
    ...
  }: let
    finix = withSystem "x86_64-linux" ({
      inputs',
      self',
      ...
    }:
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
  in {
    system.systemBuilderCommands = lib.mkAfter ''
      mkdir -p $out/specialisation
      ln -s ${finix.config.system.build.toplevel} $out/specialisation/finix
    '';
  };
}
