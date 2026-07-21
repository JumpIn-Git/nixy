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

    services.tlp.pd.enable = true;
    system.stateVersion = "25.11";
    services.fwupd.enable = true;
    environment.systemPackages = [pkgs.firmware-updater pkgs.sbctl];
    boot.lanzaboote = {
      enable = true;
      pkiBundle = "/var/lib/sbctl";
      autoGenerateKeys.enable = true;
      autoEnrollKeys = {
        enable = true;
        autoReboot = true;
      };
    };

    programs.appimage.enable = true;
    programs.appimage.binfmt = true;
    users.groups.battery_ctl = {};
    users.users.cinnamon.extraGroups = ["battery_ctl"];
    services.udev.extraRules = ''
      SUBSYSTEM=="power_supply", KERNEL=="BAT*", \
        ATTR{charge_control_end_threshold}=="*", \
        RUN+="${pkgs.coreutils}/bin/chgrp battery_ctl /sys$devpath/charge_control_end_threshold", \
        RUN+="${pkgs.coreutils}/bin/chmod g+w /sys$devpath/charge_control_end_threshold"
    '';

    swapDevices = [
      {
        device = "/var/lib/swapfile";
        size = 4 * 1024;
      }
    ];
    boot.zswap.enable = true;

    services.pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
    };
    hardware.bluetooth.enable = true;

    # nixpkgs.overlays = [
    #   (final: prev: {
    #     fwupd = prev.fwupd.overrideAttrs (oldAttrs: {
    #       patches =
    #         (oldAttrs.patches or [])
    #         ++ [
    #           (final.fetchpatch {
    #             name = "fwupd-jcat-limit-fix.patch";
    #             url = "https://github.com/fwupd/fwupd/pull/10479.patch";
    #             hash = "sha256-wthjHm3yjevkOCAqCgZNpyybbI3TZ+07knOdRbUQV7g=";
    #           })
    #         ];
    #     });
    #   })
    # ];
  };
}
