{
  flake.nixosModules.gaming = {
    pkgs,
    inputs,
    ...
  }: {
    programs.steam = {
      enable = true;
      package = pkgs.steam.override {
        extraEnv = {
          LD_AUDIT = pkgs.runCommand "SLSsteam.so" {} ''
            ${pkgs.p7zip}/bin/7z e -so ${inputs.slssteam} bin/SLSsteam.so > $out
          '';
        };
      };
      extraCompatPackages = [pkgs.proton-ge-bin];
    };

    services.ratbagd.enable = true;
    environment.systemPackages = with pkgs; [
      piper
      prismlauncher
      samrewritten
    ];
  };
}
