{self, ...}: {
  flake.finixModules.default = {
    modules,
    pkgs,
    self',
    lib,
    ...
  }: {
    imports = with modules; [
      ../_finixhw.nix
      self.nixosModules.user
      limine
      niri
      atd
      bash
      bluetooth
      brightnessctl
      chronyd
      earlyoom
      fcron
      fwupd
      getty
      greetd
      networkmanager
      nix-daemon
      pipewire
      wireplumber
      polkit
      tlp
      regreet
      rtkit
      sudo
      sysklogd
      udisks2
      upower
      zzz
    ];

    programs.niri = {
      enable = true;
      package = self'.packages.niri;
    };

    boot.kernelParams = [
      "loglevel=1"
    ];

    # graphical runlevel
    finit.runlevel = 3;

    finit.cgroups.system.settings = {
      "cpu.weight" = 100;
    };

    environment.systemPackages = [
      pkgs.nixos-rebuild-ng
      pkgs.nh
      pkgs.tlp-pd
    ];

    fonts.fontconfig.enable = true;
    fonts.enableDefaultPackages = true;
    hardware.graphics.enable = true;

    programs.bash.enable = true;
    services.getty.enable = true;
    programs.sudo.enable = true;

    programs.brightnessctl.enable = true;
    programs.resolvconf.enable = true;
    programs.zzz.enable = true;
    programs.pipewire.enable = true;
    programs.wireplumber.enable = true;
    services.udev.enable = true;
    services.elogind.enable = true;
    services.networkmanager.enable = true;
    services.bluetooth.enable = true;

    services.atd.enable = true;
    services.chrony.enable = true;
    services.dbus.enable = true;
    services.earlyoom.enable = true;
    services.earlyoom.extraArgs = [
      "-r"
      "3600"
    ];
    services.fcron.enable = true;
    services.fwupd.enable = true;
    services.nix-daemon.enable = true;
    services.nix-daemon.settings = let
      cfg = (import ../../flake.nix).nixConfig;
    in {
      auto-optimise-store = true;
      trusted-users = ["@wheel" "root"];
      inherit (cfg) extra-experimental-features;
      substituters = cfg.extra-substituters;
      trusted-public-keys = cfg.extra-trusted-public-keys;
    };
    services.polkit.enable = true;
    services.tlp.enable = true;
    services.rtkit.enable = true;
    services.sysklogd.enable = true;
    services.udisks2.enable = true;
    services.upower.enable = true;
    programs.limine.enable = true;

    xdg.autostart.enable = true;
    xdg.icons.enable = true;
    xdg.mime.enable = true;
    xdg.portal.enable = true;
  };
}
