{
  flake.nixosModules.desktop = {
    pkgs,
    inputs',
    ...
  }: {
    environment.systemPackages = with pkgs; [
      mpv
      wl-gammarelay-rs
      wl-gammarelay-applet

      obsidian
      discord
      parabolic
      loupe
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
