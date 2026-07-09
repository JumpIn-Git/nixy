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
      package = self'.packages.niri // {cargoBuildNoDefaultFeatures = false;};
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
      self'.packages.noctalia
      adwaita-icon-theme
      nautilus
      bibata-cursors
    ];
  };
}
