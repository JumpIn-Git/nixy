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
      "com.stremio.Stremio"
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
    };
  };
}
