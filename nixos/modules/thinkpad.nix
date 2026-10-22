{
  flake.nixosModules.thinkpad = {
    inputs,
    pkgs,
    self',
    ...
  }: {
    imports = [
      inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t14-amd-gen1
      inputs.self.wrappers.niri.install
      ../_hw.nix
    ];
    hardware.facter.reportPath = ../facter.json;
    boot.kernelPackages = pkgs.linuxPackages_latest;
    services.tlp.pd.enable = true;
    services.xserver.windowManager.oxwm.enable = true;
    services.tlp.settings = {
      START_CHARGE_THRESH_BAT0 = 75;
      STOP_CHARGE_THRESH_BAT0 = 80;
    };

    wrappers.niri = {
      enable = true;
      noctalia = self'.packages.noctalia.wrap {
        configPath = "/home/cinnamon/nix/config/noctalia/"; # use impure path so i can use gui
      };
    };
    qt = {
      enable = true;
      platformTheme = "gnome";
      style = "adwaita-dark";
    };

    services.fwupd.enable = true;
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings.General.Experimental = true;
    };
    environment.systemPackages = with pkgs; [
      kdePackages.qqc2-desktop-style
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
    # systemd.tmpfiles.rules = [
    #   "w /sys/class/power_supply/BAT0/charge_control_start_threshold - - - - 75"
    #   "w /sys/class/power_supply/BAT0/charge_control_end_threshold - - - - 80"
    # ];
  };
}
