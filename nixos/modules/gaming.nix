{
  flake.nixosModules.gaming = {pkgs, ...}: {
    programs.steam = {
      enable = true;
      package = pkgs.steam.override {
        extraBwrapArgs = [
          "--setenv LD_AUDIT \"/home/cinnamon/Downloads/library-inject.so:/home/cinnamon/Downloads/SLSsteam.so\""
        ];
      };
      extraCompatPackages = [pkgs.proton-ge-bin];
    };

    services.ratbagd.enable = true;
    environment.systemPackages = with pkgs; [
      piper
      prismlauncher
    ];
  };
}
