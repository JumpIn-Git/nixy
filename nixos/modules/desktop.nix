{
  flake.nixosModules.desktop = {
    pkgs,
    inputs,
    inputs',
    self',
    ...
  }: {
    # imports = [inputs.nix-flatpak.nixosModules.nix-flatpak];
    # services.flatpak.enable = true;
    # services.flatpak.packages = [
    #   {
    #     appId = "com.stremio.Stremio";
    #     commit = "355c42ab40cc747bf964118d0795b36f62e8e1c7c10a2f4b71653992ce828db8"; # use older version
    #   }
    # ];

    environment.systemPackages = with pkgs; [
      libnotify

      self'.packages.mpv
      obsidian
      zennotes-desktop
      pandoc
      parabolic
      loupe
      gnome-clocks
      gnome-calculator

      discord
      qbittorrent
      inputs'.helium.packages.default
      proton-pass
    ];
    programs.localsend.enable = true;
    programs.obs-studio.enable = true;

    xdg.mime.defaultApplications = {
      "text/html" = "helium.desktop";
      "video/*" = "mpv.desktop";
      "application/x-bittorrent" = ["org.qbittorrent.qBittorrent.desktop"];
      "x-scheme-handler/magnet" = ["org.qbittorrent.qBittorrent.desktop"];
    };
  };
}
