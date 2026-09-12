{
  flake.nixosModules.gaming = {
    pkgs,
    inputs',
    ...
  }: {
    programs.steam = {
      enable = true;
      package = pkgs.steam.override {
        extraEnv = {
          LD_AUDIT = "${inputs'.slssteam.packages.sls-steam}/library-inject.so:${inputs'.slssteam.packages.sls-steam}/SLSsteam.so";
          # LD_PRELOAD = "${inputs.cr}";
        };
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
