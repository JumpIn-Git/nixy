{
  flake.nixosModules.thinkpad = {
    inputs,
    pkgs,
    ...
  }: {
    imports = [
      inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t14-amd-gen1
      inputs.lanzaboote.nixosModules.lanzaboote
      ../_hw.nix
    ];
    hardware.facter.reportPath = ../facter.json;

    services.tlp.pd.enable = true;
    services.fwupd.enable = true;
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings = {
        General = {
          Experimental = true;
        };
      };
    };
    environment.systemPackages = with pkgs; [
      firmware-updater
      sbctl
      overskride
    ];

    boot.loader = {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot/efi";
      };
      grub = {
        enable = true;
        efiSupport = true;
        device = "nodev";
      };
    };
    # boot.lanzaboote = {
    #   enable = true;
    #   pkiBundle = "/var/lib/sbctl";
    #   autoGenerateKeys.enable = true;
    #   autoEnrollKeys = {
    #     enable = true;
    #     autoReboot = true;
    #   };
    # };
    swapDevices = [
      {
        device = "/var/lib/swapfile";
        size = 4 * 1024;
      }
    ];
    # boot.zswap.enable = true;

    programs.appimage.enable = true;
    programs.appimage.binfmt = true;
    systemd.tmpfiles.rules = [
      "z /sys/class/power_supply/BAT*/charge_control_end_threshold 0664 root battery_ctl - -"
    ];

    services.pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
    };

    system.stateVersion = "25.11";
  };
}
