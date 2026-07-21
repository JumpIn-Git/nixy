{
  flake.nixosModules.niri = {
    pkgs,
    inputs,
    self',
    ...
  }: {
    imports = [inputs.niri.nixosModules.niri];
    programs.niri = {
      enable = true;
      package = self'.packages.niri.wrap {
        noctalia = self'.packages.noctalia.wrap {
          configPath = "/home/cinnamon/nix/config/noctalia/"; # use impure path so i can use gui
        };
        settings.spawn-at-startup = [
            "discord"
        ];
      };
    };
    systemd.user.services.niri-flake-polkit.enable = false;

    services = {
      upower.enable = true;
      dbus.packages = [pkgs.nautilus];
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
    environment.systemPackages = with pkgs; [
      adwaita-icon-theme
      nautilus
      bibata-cursors
    ];
  };
}
