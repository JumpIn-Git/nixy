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
      default = let
        noctaliaExe = lib.getExe self.packages.${pkgs.stdenv.hostPlatform.system}.noctalia;
      in {
        menu = [
          {
            key = "c";
            cmd = "${noctaliaExe} ipc call controlCenter toggle";
            desc = "Control center";
          }
          {
            key = "s";
            cmd = "${noctaliaExe} ipc call settings toggle";
            desc = "Settings";
          }
          {
            key = "w";
            cmd = "${noctaliaExe} ipc call wallpaper toggle";
            desc = "Set wallpaper";
          }
          {
            key = "t";
            cmd = "niri-ocr";
            desc = "Screenshot OCR";
          }
          {
            key = "b";
            cmd = "${noctaliaExe} ipc call plugin:battery-threshold togglePanel";
            desc = "Battery threshold";
          }
        ];
      };
    };
  };
}
