{
  inputs,
  ...
}: {
  imports = [
    inputs.wrappers.flakeModules.wrappers
  ];

  perSystem = {system, ...}: {
    _module.args.pkgs = import inputs.nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
  };

  systems = ["x86_64-linux"]; # TODO
}
