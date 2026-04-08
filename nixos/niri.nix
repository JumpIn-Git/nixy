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
  };
  # programs.nautilus-open-any-terminal.enable = true;
  programs.nautilus-open-any-terminal.terminal = "ghostty";

  users.groups.battery_ctl = {};
  users.users.cinnamon.extraGroups = ["battery_ctl"];
  services.udev.extraRules = ''
    SUBSYSTEM=="power_supply", KERNEL=="BAT*", \
      ATTR{charge_control_end_threshold}=="*", \
      RUN+="${pkgs.coreutils}/bin/chgrp battery_ctl /sys$devpath/charge_control_end_threshold", \
      RUN+="${pkgs.coreutils}/bin/chmod g+w /sys$devpath/charge_control_end_threshold"
  '';

  services.displayManager.ly.enable = true;
  services.displayManager.ly.settings = {
    animation = "colormix";
    bigclock = "en";
    # blank_box = false;
    # hide_borders = true;
    # text in center
  };
  wrappers.noctalia-shell = {
    enable = true;
    package = inputs.noctalia.packages.${pkgs.system}.default;
    extraPackages = [pkgs.sqlite];
    outOfStoreConfig = "/home/cinnamon/nix/config/noctalia";
  };
  environment.systemPackages = with pkgs; [
    inputs.self.packages.${system}.niri-ocr
    (inputs.self.wrappers.wlr-which-key.wrap {
      inherit pkgs;
      settings = {
        menu = [
          {
            key = "c";
            cmd = "noctalia-shell ipc call controlCenter toggle";
            desc = "Control center";
          }
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
          {
            key = "t";
            cmd = "niri-ocr";
            desc = "Screenshot OCR";
          }
          {
            key = "b";
            cmd = "noctalia-shell ipc call plugin:battery-threshold togglePanel";
            desc = "Battery threshold";
          }
        ];
      };
    })
    wl-clipboard
    ghostty
    tesseract
    mission-center
    adwaita-icon-theme
    nautilus
    bibata-cursors
    xwayland-satellite
  ];
}
