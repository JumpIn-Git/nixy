{self, ...}: {
  flake.finixModules.default = {
    modules,
    pkgs,
    self',
    ...
  }: {
    imports = with modules; [
      self.nixosModules.user
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
    hardware.firmware = with pkgs; [
      linux-firmware
      sof-firmware
    ];
    hardware.graphics.enable = true;

    programs.bash.enable = true;
    services.getty.enable = true;
    # services.greetd.enable = true;
    # programs.regreet.enable = true;
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
    services.polkit.enable = true;
    services.tlp.enable = true;
    services.rtkit.enable = true;
    services.sysklogd.enable = true;
    services.udisks2.enable = true;
    services.upower.enable = true;

    xdg.autostart.enable = true;
    xdg.icons.enable = true;
    xdg.mime.enable = true;
    xdg.portal.enable = true;

    boot.initrd.availableKernelModules = ["nvme" "ehci_pci" "xhci_pci_renesas" "xhci_pci" "usb_storage" "sd_mod" "rtsx_pci_sdmmc"];
    boot.initrd.kernelModules = [];
    boot.kernelModules = ["kvm-amd"];
    boot.extraModulePackages = [];

    fileSystems."/" = {
      device = "/dev/disk/by-uuid/984f4841-b968-4f91-89aa-fca8557cf5f3";
      fsType = "ext4";
    };

    fileSystems."/boot" = {
      device = "/dev/disk/by-uuid/082E-F7DC";
      fsType = "vfat";
      options = ["fmask=0077" "dmask=0077"];
    };

    swapDevices = [];

    hardware.cpu.amd.updateMicrocode = true;
  };
}
