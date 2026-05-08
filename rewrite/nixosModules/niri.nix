{
  flake.nixosModules.niri = {
    inputs,
    self',
    pkgs,
    ...
  }: {
    imports = [inputs.niri.nixosModules.default];
    programs.niri = {
      enable = true;
      package = self'.niri;
    };
    systemd.user.services.niri-flake-polkit.enable = false;

    users.groups.battery_ctl = {};
    users.users.cinnamon.extraGroups = ["battery_ctl"]; # TODO
    services.udev.extraRules = ''
      SUBSYSTEM=="power_supply", KERNEL=="BAT*", \
        ATTR{charge_control_end_threshold}=="*", \
        RUN+="${pkgs.coreutils}/bin/chgrp battery_ctl /sys$devpath/charge_control_end_threshold", \
        RUN+="${pkgs.coreutils}/bin/chmod g+w /sys$devpath/charge_control_end_threshold"
    '';

    services = {
      upower.enable = true;
      gvfs.enable = true;
      displayManager.ly = {
        enable = true;
        settings = {
          animation = "gameoflife";
          bigclock = "en";
          hide_borders = true;
          text_in_center = true;
        };
      };
    };
  };
}
