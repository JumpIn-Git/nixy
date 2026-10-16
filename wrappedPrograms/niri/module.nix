{inputs, ...}: {
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
        programs.ydotool.enable = true;

        services.displayManager.ly = {
          enable = true;
          settings = {
            animation = "colormix";
            bigclock = "en";
            hide_borders = true;
            text_in_center = true;
          };
        };
        environment.systemPackages = with pkgs; [
          wrapperCfg.noctalia
          wrapperCfg.terminal
          adwaita-icon-theme
          nautilus
          nautilus-python
          (runCommand "localsend-nautilus" {} ''
            mkdir -p $out/share/nautilus-python/extensions
            ln -s ${inputs.localsend-nautilus}/src/localsend_extension.py $out/share/nautilus-python/extensions/localsend_extension.py
          '')
          bibata-cursors
        ];
        environment.pathsToLink = ["/share/nautilus-python/extensions"];
        environment.sessionVariables.NAUTILUS_4_EXTENSION_DIR = "${pkgs.nautilus-python}/lib/nautilus/extensions-4";
      };
    };
  };
}
