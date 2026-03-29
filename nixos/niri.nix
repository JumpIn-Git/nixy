{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.niri.nixosModules.niri
    inputs.wrappers.nixosModules.noctalia-shell
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
  # nix.settings = {
  #   extra-substituters = ["https://noctalia.cachix.org"];
  #   extra-trusted-public-keys = ["noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="];
  # };
  wrappers.noctalia-shell = {
    enable = true;
    package = inputs.noctalia.packages.${pkgs.system}.default;
    extraPackages = [pkgs.sqlite];
    outOfStoreConfig = "/home/cinnamon/nix/config/noctalia";
  };
  environment.systemPackages = with pkgs; [
    xdg-user-dirs-gtk
    (inputs.self.wrappers.wlr-which-key.wrap {
      inherit pkgs;
      settings = {
        menu = [
          {
            key = "s";
            cmd = "noctalia-shell ipc call settings toggle";
            desc = "Settings";
          }
          {
            key = "w";
            cmd = "noctalia-shell ipc call wallpaper toggle";
            desc = "Set wallpaper";
          }
        ];
      };
    })
    wl-clipboard
    ghostty
    loupe
    nautilus
    bibata-cursors
    xwayland-satellite
  ];
}
