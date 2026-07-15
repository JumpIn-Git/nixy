{
  flake.nixosModules.user = {
    inputs,
    config,
    ...
  }: {
    imports = [inputs.self.wrappers.nu.install];
    wrappers.nu.enable = true;
    users.users.cinnamon = {
      isNormalUser = true;
      extraGroups = ["wheel" "networkmanager" "input"];
      shell = config.wrappers.nu.wrapper;
    };
  };
}
