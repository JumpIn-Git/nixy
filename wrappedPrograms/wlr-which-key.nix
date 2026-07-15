{self, ...}: {
  flake.wrappers.wlr-which-key = {
    pkgs,
    wlib,
    lib,
    config,
    ...
  }: let
    yamlFormat = pkgs.formats.yaml {};
  in {
    imports = [wlib.modules.default];
    config.package = pkgs.wlr-which-key;
    config.addFlag = [(yamlFormat.generate "config.yaml" config.settings)];
    options.settings = lib.mkOption {
      type = yamlFormat.type;
      default = {};
    };
  };
}
