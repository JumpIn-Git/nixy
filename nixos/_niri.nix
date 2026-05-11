{
  inputs,
  self',
  pkgs,
  ...
}: {
  imports = [inputs.niri.nixosModules.niri];
  nixpkgs.overlays = [inputs.niri.overlays.niri];
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
  # programs.nautilus-open-any-terminal.terminal = "ghostty";

  users.groups.battery_ctl = {};
  users.users.cinnamon.extraGroups = ["battery_ctl"];
  services.udev.extraRules = ''
    SUBSYSTEM=="power_supply", KERNEL=="BAT*", \
      ATTR{charge_control_end_threshold}=="*", \
      RUN+="${pkgs.coreutils}/bin/chgrp battery_ctl /sys$devpath/charge_control_end_threshold", \
      RUN+="${pkgs.coreutils}/bin/chmod g+w /sys$devpath/charge_control_end_threshold"
  '';

  services.displayManager.ly = {
    enable = true;
    settings = {
      animation = "gameoflife";
      bigclock = "en";
      hide_borders = true;
      text_in_center = true;
    };
  };
  environment.etc."xdg/quickshell".source = inputs.noctalia.packages.${pkgs.system}.default + /share/noctalia-shell;
  environment.variables.QS_CONFIG_PATH = "/etc/xdg/quickshell";
  environment.systemPackages = with pkgs; [
    gpu-screen-recorder
    self'.packages.niri-ocr
    wl-gammarelay-rs
    wl-gammarelay-applet
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
    mission-center
    adwaita-icon-theme
    nautilus
    bibata-cursors
    xwayland-satellite
  ];
}
