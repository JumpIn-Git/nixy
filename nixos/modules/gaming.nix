{
  flake.nixosModules.gaming = {pkgs, ...}: {
    programs.steam = {
      enable = false;
      extraCompatPackages = [pkgs.proton-ge-bin];
    };

    services.ratbagd.enable = true;
    environment.systemPackages = with pkgs; [
      piper
    ];
  };
}
