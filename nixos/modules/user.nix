{
  flake.nixosModules.user = {
    self',
    lib,
    ...
  }: {
    users.users.cinnamon = {
      isNormalUser = true;
      extraGroups = ["wheel" "networkmanager" "input"];
      shell = self'.packages.nu;
    };

    environment.shells = [
      "/run/current-system/sw/bin/nu"
      (lib.getExe self'.packages.nu)
    ];

    environment.systemPackages = [
      self'.packages.nu
    ];
  };
}
