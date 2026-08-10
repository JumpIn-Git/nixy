{
  self,
  inputs,
  ...
}: {
  flake.wrappers.niri = {
    pkgs,
    lib,
    config,
    ...
  }: let
    inherit (pkgs.stdenv.hostPlatform) system;
  in {
    options.wlr-which-key = lib.mkOption {
      type = lib.types.package;
      description = "Wrapped wlr-which-key";
      default = self.packages.${system}.wlr-which-key.wrap {
        settings.menu = let
          noctaliaExe = lib.getExe config.noctalia;
        in [
          {
            key = "m";
            cmd = lib.getExe inputs.monique.packages.${system}.default;
            desc = "Display configuration";
          }
          {
            key = "g";
            cmd = lib.getExe pkgs.wl-gammarelay-applet;
            desc = "Gammarelay applet";
          }
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
            cmd = lib.getExe self.packages.${system}.niri-ocr;
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
