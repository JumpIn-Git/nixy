{
  flake.nixosModules.thinkpad = {
    inputs,
    pkgs,
    ...
  }: {
    imports = [
      inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t14-amd-gen1
      ../_hw.nix
    ];
    hardware.facter.reportPath = ../facter.json;

    services.tlp.pd.enable = true;
    services.fwupd.enable = true;
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings.General.Experimental = true;
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
    swapDevices = [
      {
        device = "/var/lib/swapfile";
        size = 4 * 1024;
      }
    ];
    systemd.oomd = {
      enable = true;
      enableUserSlices = true;
      enableSystemSlice = true;
    };
    boot.zswap.enable = true;

    programs.appimage = {
      enable = true;
      binfmt = true;
    };

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
