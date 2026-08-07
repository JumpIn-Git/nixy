{
  flake.nixosModules.gaming = {pkgs, ...}: {
    programs.steam = {
      enable = true;
      extraCompatPackages = [pkgs.proton-ge-bin];
    };

    services.ratbagd.enable = true;
    environment.systemPackages = with pkgs; [
      piper
    ];
  };
}
