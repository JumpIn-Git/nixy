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
          LD_AUDIT = pkgs.runCommand "SLSsteam.so" {nativeBuildInputs = [pkgs.p7zip];} ''
            7z e -so ${inputs.slssteam} bin/SLSsteam.so > $out
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
