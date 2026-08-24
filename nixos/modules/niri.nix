{
  flake.nixosModules.niri = {
    self',
    inputs',
    inputs,
    ...
  }: {
    imports = [inputs.self.wrappers.niri.install inputs.umbriel.nixosModules.default];

    wrappers.niri = {
      enable = true;
      noctalia = self'.packages.noctalia.wrap {
        configPath = "/home/cinnamon/nix/config/noctalia/"; # use impure path so i can use gui
      };
      settings.spawn-at-startup = [["discord" "--start-minimized"]];
    };
    xdg.terminal-exec = {
      enable = true;
      settings.default = ["com.mitchellh.ghostty.desktop"];
    };
    programs.umbriel = {
      enable = true;
      package = inputs'.umbriel.packages.default;
      portalPackage = inputs'.xdg-desktop-portal-umbriel.packages.default;
    };
  };
}
