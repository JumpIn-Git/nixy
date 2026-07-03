{
  flake.nixosModules.desktop = {
    pkgs,
    inputs,
    inputs',
    self',
    ...
  }: {
    imports = [inputs.nix-flatpak.nixosModules.nix-flatpak];
    services.flatpak.enable = true;
    services.flatpak.packages = [
      {
        appId = "com.stremio.Stremio";
        commit = "355c42ab40cc747bf964118d0795b36f62e8e1c7c10a2f4b71653992ce828db8"; # use older version
      }
      "com.modrinth.ModrinthApp"
    ];

    environment.systemPackages = with pkgs; [
      libnotify
      usbutils
      wl-gammarelay-rs
      wl-gammarelay-applet

      zed-editor
      self'.packages.mpv
      obsidian
      self'.packages.zennotes
      pandoc
      parabolic
      loupe

      discord
      qbittorrent
      inputs'.helium.packages.default
      proton-pass
    ];
    programs.localsend.enable = true;
    programs.obs-studio.enable = true;

    xdg.mime.defaultApplications = {
      "text/plain" = "dev.zed.Zed.desktop";
      "text/html" = "helium.desktop";
      "video/*" = "mpv.desktop";
      "application/x-bittorrent" = ["org.qbittorrent.qBittorrent.desktop"];
      "x-scheme-handler/magnet" = ["org.qbittorrent.qBittorrent.desktop"];
    };
  };
}
