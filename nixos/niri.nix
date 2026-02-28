{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.niri.nixosModules.niri
  ];
  programs.niri = {
    enable = true;
    package = pkgs.niri;
  };
  services = {
    upower.enable = true;
    dbus.packages = [pkgs.nautilus];
  };
  users.users.cinnamon = {
    packages = with pkgs; [
      noctalia-shell
      ghostty
      nautilus
      bibata-cursors
      xwayland-satellite
    ];
  };
}
