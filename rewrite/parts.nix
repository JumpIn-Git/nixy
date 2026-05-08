{
  inputs,
  lib,
  self,
  ...
}: {
  imports = [
    inputs.wrappers.flakeModules.wrappers
    inputs.parts.flakeModules.modules
  ];

  flake.overlays.default = lib.composeManyExtensions [
    inputs.niri.overlays.niri
    inputs.noctalia.overlays.default
  ];
  perSystem = {system, ...}: {
    _module.args.pkgs = import inputs.nixpkgs {
      inherit system;
      overlays = [self.overlays.default];
    };
  };

  systems = ["x86_64-linux"]; # TODO
}
