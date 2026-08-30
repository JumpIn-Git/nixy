{
  flake.nixosModules.niri = {
    self',
    inputs,
    ...
  }: {
    imports = [inputs.self.wrappers.niri.install ];
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
    programs.umbriel = {
      enable = true;
    };
  };
}
