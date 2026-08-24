{
  flake.nixosModules.user = {
    inputs,
    config,
    ...
  }: {
    imports = [inputs.self.wrappers.nu.install];
    wrappers.nu = {
      enable = true;
      "config.nu".content = ''
        $env.FLAKE = '/home/cinnamon/nix'
        $env.NH_FLAKE = $env.FLAKE
      '';
    };
    users.users.cinnamon = {
      isNormalUser = true;
      extraGroups = ["wheel" "networkmanager" "input"];
      shell = config.wrappers.nu.wrapper;
    };
  };
}
