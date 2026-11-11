{inputs, ...}: {
  flake.wrappers.noctalia = {
    pkgs,
    wlib,
    lib,
    config,
    ...
  }: {
    imports = [wlib.modules.default];
    options.configPath = lib.mkOption {
      type = lib.types.str;
      default = toString ../config/noctalia;
    };
    config.package = inputs.noctalia.legacyPackages.${pkgs.stdenv.hostPlatform.system}.noctalia-shell;
    config.runtimePkgs = with pkgs; [
      mission-center
      gpu-screen-recorder
      sqlite
    ];
    config.env.NOCTALIA_CONFIG_DIR = config.configPath;
  };
}
