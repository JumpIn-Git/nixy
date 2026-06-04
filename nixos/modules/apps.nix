{inputs, ...}: {
  flake.nixosModules.apps = {pkgs, ...}: {
    imports = [inputs.nix-flatpak.nixosModules.nix-flatpak];
    services.flatpak.enable = true;
    services.flatpak.packages = [
      "com.stremio.Stremio"
      "com.modrinth.ModrinthApp"
    ];

    environment.systemPackages = with pkgs; [
      libnotify
      usbutils
    ];
  };
}
