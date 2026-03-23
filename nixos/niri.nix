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

  services = {
    upower.enable = true;
    dbus.packages = [pkgs.nautilus];
    gvfs.enable = true;
    udisks2.enable = true;
  };

  users.groups.battery_ctl = {};
  users.users.cinnamon.extraGroups = ["battery_ctl"];
  services.udev.extraRules = ''
    SUBSYSTEM=="power_supply", KERNEL=="BAT*", \
      ATTR{charge_control_end_threshold}=="*", \
      RUN+="${pkgs.coreutils}/bin/chgrp battery_ctl /sys$devpath/charge_control_end_threshold", \
      RUN+="${pkgs.coreutils}/bin/chmod g+w /sys$devpath/charge_control_end_threshold"
  '';

  programs.regreet.enable = true;
  environment.systemPackages = with pkgs; [
    (inputs.wrappers.wrappers.noctalia-shell.wrap {
      inherit pkgs;
      package = inputs.noctalia.packages.${system}.default.override {calendarSupport = true;};
      extraPackages = [sqlite];
      outOfStoreConfig = "/home/cinnamon/nix/config/noctalia";
    })
    wl-clipboard
    ghostty
    nautilus
    bibata-cursors
    xwayland-satellite
  ];
}
