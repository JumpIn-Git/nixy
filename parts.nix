{inputs, ...}: {
  imports = [
    inputs.wrappers.flakeModules.wrappers
  ];

  perSystem = {system, ...}: {
    _module.args.pkgs = inputs.nixpkgs-unfree.legacyPackages.${system};
  };

  systems = ["x86_64-linux"]; # TODO
}
