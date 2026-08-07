{
  flake.nixosModules.niri = {
    self',
    inputs,
    ...
  }: let
    noctalia-wrapped = self'.packages.noctalia.wrap {
      configPath = "/home/cinnamon/nix/config/noctalia/"; # use impure path so i can use gui
    };
  in {
    imports = [inputs.self.wrappers.niri.install];
    wrappers.niri = {
      enable = true;
      noctalia = noctalia-wrapped;
      settings.spawn-at-startup = [["discord" "--start-minimized"]];
    };
  };
}
