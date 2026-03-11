{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.niri.nixosModules.niri
  ];
  programs.niri = {
    enable = true;
    package = pkgs.niri;
  };

  systemd.user.services.niri-flake-polkit.enable = false;
  users.groups.battery = {};
  users.users.cinnamon.extraGroups = ["battery"];
  systemd.tmpfiles.rules = [
    ''
      z /sys/class/power_supply/BAT0/charge_control_end_threshold 0664 root battery -
    ''
  ];
  services = {
    upower.enable = true;
    dbus.packages = [pkgs.nautilus];
  };

  programs.regreet.enable = true;
  environment.systemPackages = with pkgs; [
    (noctalia-shell.override {calendarSupport = true;})
    wl-clipboard
    ghostty
    nautilus
    bibata-cursors
    xwayland-satellite
  ];
}
