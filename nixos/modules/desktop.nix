{
  flake.nixosModules.desktop = {
    pkgs,
    inputs,
    inputs',
    self',
    ...
  }: {
    environment.systemPackages = with pkgs; [
      libnotify

      self'.packages.mpv
      self'.packages.stremio-legacy
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
