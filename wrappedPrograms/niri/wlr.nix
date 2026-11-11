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
            cmd = lib.getExe inputs.monique.packages.${system}.default;
            desc = "Display configuration";
          }
          {
            cmd = lib.getExe pkgs.wl-gammarelay-applet;
            desc = "Gammarelay applet";
          }
          {
            cmd = "${noctaliaExe} ipc call controlCenter toggle";
            desc = "Control center";
          }
          {
            cmd = "${noctaliaExe} ipc call settings toggle";
            desc = "Settings";
          }
          {
            cmd = "${noctaliaExe} ipc call wallpaper toggle";
            desc = "Wallpaper";
          }
        ]|>lib.map(a: a // {key=builtins.substring 0 1 a.desc |> lib.toLower;});
      };
    };
  };
}
