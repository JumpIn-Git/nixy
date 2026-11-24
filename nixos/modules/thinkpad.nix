{
  flake = {
    nixosModules.thinkpad = {
      inputs,
      pkgs,
      self',
      lib,
      ...
    }: {
      imports = [
        inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t14-amd-gen1
        inputs.self.wrappers.niri.install
        inputs.rikka.nixosModules.default
        ../_hw.nix
      ];
      rikka.enable = true;
      services.power-profiles-daemon.enable = false;
      services.geoclue2.enable = false;
      hardware.graphics.extraPackages = with pkgs; [
        mesa
        libva
      ];
      hardware.facter.reportPath = ../facter.json;
      boot.kernelPackages = pkgs.linuxPackages_latest;

      programs.appimage = {
        enable = true;
        binfmt = true;
        package = pkgs.appimage-run.override {
          extraPkgs = p: [p.libgpg-error];
        };
      };
      wrappers.niri = {
        enable = true;
        noctalia = self'.packages.noctalia.wrap {
          configPath = "/home/cinnamon/nix/config/noctalia/";
        };
        settings.spawn-at-startup = [
          (lib.getExe self'.packages.mpris-bridge)
        ];
      };
      qt = {
        enable = true;
        platformTheme = "gnome";
        style = "adwaita-dark";
      };

      services = {
        fwupd.enable = true;
        tlp = {
          pd.enable = true;
          settings = {
            START_CHARGE_THRESH_BAT0 = 75;
            STOP_CHARGE_THRESH_BAT0 = 80;
          };
        };
        pipewire = {
          enable = true;
          pulse.enable = true;
        };
      };
      hardware.bluetooth = {
        enable = true;
        powerOnBoot = true;
        settings.General = {
          Experimental = true;
          Disable = "Sink";
        };
      };
      environment.systemPackages = with pkgs; [
        blueman
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
          extraEntries = ''
            menuentry 'Windows' --class windows --class os {
              insmod part_gpt
              insmod fat
              search --no-floppy --fs-uuid --set=root 082E-F7DC
              chainloader /EFI/Microsoft/Boot/bootmgfw.efi
            }
          '';
        };
      };
      swapDevices = [
        {
          device = "/var/lib/swapfile";
          size = 4 * 1024;
        }
      ];
      systemd = {
        oomd = {
          enable = true;
          enableUserSlices = true;
          enableSystemSlice = true;
        };
        coredump.settings.Coredump.MaxUse = "1G";
      };
      boot.zswap.enable = true;

      system.stateVersion = "25.11";
    };
  };
}
