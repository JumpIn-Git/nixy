{
  inputs,
  pkgs,
  ...
}: {
  imports = with inputs; [
    nixos-hardware.nixosModules.lenovo-thinkpad-t14-amd-gen1
    ./hardware.nix
  ];
  boot.kernelPackages = pkgs.linuxPackages_latest; # Magically fixes wifi

  services.pipewire = {
    enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    pulse.enable = true;
  };
  hardware.bluetooth.enable = true;

  networking.hostName = "nixos"; # Define your hostname.
  networking.networkmanager.enable = true;
  networking.networkmanager.wifi.powersave = false;
  # boot.kernelParams = [ "pcie_aspm=off" ];


  # boot.extraModprobeConfig = ''
  #   options mt7921e disable_aspm=Y
  #   options mt76 power_save=0
  # '';

  # services.udev.extraRules = ''
  #   ACTION=="add", SUBSYSTEM=="pci", ATTR{power/control}="on"
  # '';
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.enable = true;

  time.timeZone = "Europe/Amsterdam";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "nl_NL.UTF-8";
    LC_IDENTIFICATION = "nl_NL.UTF-8";
    LC_MEASUREMENT = "nl_NL.UTF-8";
    LC_MONETARY = "nl_NL.UTF-8";
    LC_NAME = "nl_NL.UTF-8";
    LC_NUMERIC = "nl_NL.UTF-8";
    LC_PAPER = "nl_NL.UTF-8";
    LC_TELEPHONE = "nl_NL.UTF-8";
    LC_TIME = "nl_NL.UTF-8";
  };
}
