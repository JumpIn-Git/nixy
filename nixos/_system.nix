{
  inputs,
  pkgs,
  ...
}: {
  imports = with inputs; [
    nixos-hardware.nixosModules.lenovo-thinkpad-t14-amd-gen1
    self.nixosModules.core
    ./_hw.nix
  ];

  users.groups.battery_ctl = {};
  users.users.cinnamon.extraGroups = ["battery_ctl"];
  services.udev.extraRules = ''
    SUBSYSTEM=="power_supply", KERNEL=="BAT*", \
      ATTR{charge_control_end_threshold}=="*", \
      RUN+="${pkgs.coreutils}/bin/chgrp battery_ctl /sys$devpath/charge_control_end_threshold", \
      RUN+="${pkgs.coreutils}/bin/chmod g+w /sys$devpath/charge_control_end_threshold"
  '';

  boot.kernelPackages = pkgs.linuxPackages_latest;

  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 4 * 1024;
    }
  ];
  boot.kernelParams = [
    "zswap.enabled=1"
    "zswap.zpool=zsmalloc"
    "zswap.shrinker_enabled=1"
  ];

  services.pipewire = {
    enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    pulse.enable = true;
  };
  hardware.bluetooth.enable = true;
}
