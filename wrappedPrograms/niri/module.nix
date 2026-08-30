{
  flake.wrappers.niri = {...} @ top: {
    config.install.modules.nixos = {
      config,
      lib,
      pkgs,
      ...
    }: let
      wrapperCfg = top.config.install.getWrapperConfig config;
    in {
      config = lib.mkIf wrapperCfg.enable {
        programs.niri = {
          enable = true;
          package = wrapperCfg.wrapper;
          useNautilus = true;
        };
        security.polkit.enablePkexecWrapper = true;
        environment.etc."xdg/quickshell".source = wrapperCfg.noctalia + /share/noctalia-shell;

        services = {
          upower.enable = true;
          gvfs.enable = true;
        };
        programs.nautilus-open-any-terminal.enable = true;
        programs.nautilus-open-any-terminal.terminal = "ghostty";

        services.displayManager.ly = {
          enable = true;
          settings = {
            animation = "colormix";
            bigclock = "en";
            hide_borders = true;
            text_in_center = true;
          };
        };
        environment.systemPackages = [
          wrapperCfg.noctalia
          wrapperCfg.terminal
          pkgs.adwaita-icon-theme
          pkgs.nautilus
        ];
      };
    };
  };
}
