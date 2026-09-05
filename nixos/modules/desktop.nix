{
  flake.nixosModules.desktop = {
    pkgs,
    inputs',
    self',
    ...
  }: {
    services.flatpak.enable = true;
    environment.systemPackages = with pkgs; [
      libnotify
      ffmpeg

      self'.packages.mpv
      self'.packages.stremio-legacy
      zennotes-desktop
      parabolic
      loupe
      gnome-calculator
      cheese

      (discord.override {
        withOpenASAR = true;
      })
      qbittorrent
      inputs'.helium.packages.default
      proton-pass
    ];
    programs.localsend.enable = true;
    programs.kclock.enable = true;
    programs.obs-studio = {
      enable = true;
      plugins = with pkgs.obs-studio-plugins; [
        input-overlay
      ];
      enableVirtualCamera = true;
    };

    xdg.mime.defaultApplications = {
      "text/html" = "helium.desktop";
      "video/*" = "mpv.desktop";
      "application/x-bittorrent" = ["org.qbittorrent.qBittorrent.desktop"];
      "x-scheme-handler/magnet" = ["org.qbittorrent.qBittorrent.desktop"];
    };
  };
}
