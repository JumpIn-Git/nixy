{
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
    config.package = pkgs.noctalia-shell;
    config.runtimePkgs = with pkgs; [
      mission-center
      gpu-screen-recorder
      sqlite

      grim
      slurp
      wl-clipboard
      tesseract
      imagemagick
      translate-shell
      wl-screenrec
      ffmpeg
      jq
      python3
      python3Packages.pygobject3
    ];
    config.env.NOCTALIA_CONFIG_DIR = config.configPath;
  };
}
